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

#import "BagelUtility.h"

@implementation BagelUtility

+ (NSString *)UUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

+ (NSString *)projectName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
}


+ (NSString *)deviceId
{
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
    
    return @"";
    
#else
    
    return [NSString stringWithFormat:@"%@-%@",[self deviceName],[self deviceDescription]];
    
#endif
}

+ (NSString *)deviceName
{
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
    
    return @"";
    
#else
    
    return [UIDevice currentDevice].name;
    
#endif
}

+ (NSString *)deviceDescription
{
    NSString* information = @"";
    
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
    
    return @"";
#else
    
    information = [UIDevice currentDevice].model;
    information = [NSString stringWithFormat:@"%@ %@",information,[UIDevice currentDevice].systemName];
    information = [NSString stringWithFormat:@"%@ %@",information,[UIDevice currentDevice].systemVersion];
    
#endif
    
    return information;
}

@end
