//
// Copyright (c) 2017 Bagel (https://github.com/yagiz/BagelCore)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "BagelCryptor.h"
#import <Security/Security.h>
#import "Bagel+NSData+CommonCrypto.h"
#import <CommonCrypto/CommonCrypto.h>

NSString * const BagelCryptorErrorDomain = @"BagelCryptorErrorDomain";

const uint32_t BagelCryptor_PADDING = kSecPaddingPKCS1;

@implementation BagelCryptor

+ (instancetype)shared;
{
    static BagelCryptor* shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[BagelCryptor alloc] init];
    });
    return shared;
}

- (BOOL)loadPublicKeyFromBundledCertificate:(NSString *)name error:(NSError **)error
{
	NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:@"cer"];
    
	if (url)
    {
		NSData *certData = [NSData dataWithContentsOfURL:url];
        
		if (certData)
        {
			SecKeyRef public = [self publicKeyFromData:certData error:error];
            
			if (public) {
				if (self.publicKey)
                {
					CFRelease(self.publicKey);
				}
                
				self.publicKey = public;
                
				return YES;
			}
		}
		else if (error)
        {
			*error = [NSError errorWithDomain:BagelCryptorErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"Failed to read bundled public key data"}];
		}
	}
	else if (error)
    {
		NSString *message = [NSString stringWithFormat:@"Bundled certificate named «%@.cer» not found", name];
		*error = [NSError errorWithDomain:BagelCryptorErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: message}];
	}
	return NO;
}

- (SecKeyRef)publicKeyFromData:(NSData *)data error:(NSError **)error
{
	SecCertificateRef certificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)data);
    
	if (certificate)
    {
		SecPolicyRef policy = SecPolicyCreateBasicX509();
		SecTrustRef trust;
        
		OSStatus status = SecTrustCreateWithCertificates(certificate, policy, &trust);
		
        CFRelease(certificate);
		CFRelease(policy);
        
		if (errSecSuccess == status)
        {
			SecKeyRef key = SecTrustCopyPublicKey(trust);
			CFRelease(trust);
            
			return key;
		}
		if (error)
        {
			NSString *message = [self errorMessageForCode:status message:@"Failed to establish trust with certificate"];
			*error = [NSError errorWithDomain:BagelCryptorErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: message}];
		}
	}
	else if (error)
    {
		*error = [NSError errorWithDomain:BagelCryptorErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"Failed to create certificate"}];
	}
	return NULL;
}


- (BOOL)hasPublicKey
{
	return NULL != self.publicKey;
}

- (NSData * __nullable)encryptData:(NSData *)content
{
    NSData *aesKey = [self generateKey];
    NSData *iv = [self generateIV];
    NSData *encryptedData = [content AES256EncryptedDataUsingKey:aesKey andIV:iv error:nil];
    
    // encrypt aesKey with publicKey
    NSData *encryptedAESKey = [self wrapSymmetricKey:aesKey keyRef:self.publicKey];
    
    NSMutableData *result = [NSMutableData data];
    [result appendData:iv];
    [result appendData:encryptedAESKey];
    [result appendData:encryptedData];
    
    return result;
}


- (NSData * __nullable)decryptData:(NSData *)content keyRef:(SecKeyRef)keyRef
{
    @try {
        
        NSData *iv = [content subdataWithRange:NSMakeRange(0, 16)];
        NSData *wrappedSymmetricKey = [content subdataWithRange:NSMakeRange(16, 256)];
        NSData *encryptedData = [content subdataWithRange:NSMakeRange(272, [content length] - 272)];
        
        if(iv && wrappedSymmetricKey && encryptedData)
        {
            NSData *key = [self unwrapSymmetricKey:wrappedSymmetricKey keyRef:keyRef];
            
            return [encryptedData decryptedAES256DataUsingKey:key andIV:iv error:nil];
        }
        
        return nil;
        
        
    } @catch (NSException *exception) {
        
        return nil;
    }
}




+ (NSString *)randomStringOfLength:(NSUInteger)length {
	NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789@%#$^_.*-+/=";
	NSMutableString *s = [NSMutableString stringWithCapacity:length];
	for (NSUInteger i = 0U; i < length; i++) {
		u_int32_t r = arc4random() % [alphabet length];
		unichar c = [alphabet characterAtIndex:r];
		[s appendFormat:@"%C", c];
	}
	return [s copy];
}

- (NSString * __nonnull)errorMessageForCode:(OSStatus)code message:(NSString *)message {
	NSString *explanation = nil;
	switch (code) {
		case errSecAuthFailed:
			explanation = @"wrong password";
			break;
		case errSSLCrypto:
			explanation = @"invalid encryption";
			break;
	}
	return [NSString stringWithFormat:@"%@: %@", message, explanation ?: [NSString stringWithFormat:@"Error code %d", (int)code]];
}


+ (NSData *)randomDataOfLength:(size_t)length
{
    NSMutableData *data = [NSMutableData dataWithLength:length];
    
    int result = SecRandomCopyBytes(kSecRandomDefault, length, data.mutableBytes);
    NSAssert(result == 0, @"Unable to generate random bytes: %d", errno);
    
    return data;
}

- (NSData *)generateKey {
    return [[self class] randomDataOfLength:kCCKeySizeAES256];
}

- (NSData *)generateIV {
    return [[self class] randomDataOfLength:kCCBlockSizeAES128];
}

- (NSData *)wrapSymmetricKey:(NSData *)symmetricKey keyRef:(SecKeyRef)publicKey {
    size_t keyBufferSize = [symmetricKey length];
    size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
    
    NSMutableData *cipher = [NSMutableData dataWithLength:cipherBufferSize];
    OSStatus sanityCheck = SecKeyEncrypt(publicKey,
                                         kSecPaddingPKCS1,
                                         (const uint8_t *)[symmetricKey bytes],
                                         keyBufferSize,
                                         cipher.mutableBytes,
                                         &cipherBufferSize);
    NSAssert(sanityCheck == noErr, @"Error encrypting, OSStatus == %d.", (int)sanityCheck);
    [cipher setLength:cipherBufferSize];
    
    return cipher;
}

- (NSData *)unwrapSymmetricKey:(NSData *)wrappedSymmetricKey keyRef:(SecKeyRef)privateKey {
    size_t cipherBufferSize = SecKeyGetBlockSize(privateKey);
    size_t keyBufferSize = [wrappedSymmetricKey length];
    
    NSMutableData *key = [NSMutableData dataWithLength:keyBufferSize];
    OSStatus sanityCheck = SecKeyDecrypt(privateKey,
                                         kSecPaddingPKCS1,
                                         (const uint8_t *) [wrappedSymmetricKey bytes],
                                         cipherBufferSize,
                                         [key mutableBytes],
                                         &keyBufferSize);
    NSAssert(sanityCheck == noErr, @"Error decrypting, OSStatus == %d.", (int)sanityCheck);
    [key setLength:keyBufferSize];
    
    return key;
}

@end
