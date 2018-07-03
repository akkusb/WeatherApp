#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Bagel+NSData+CommonCrypto.h"
#import "BagelBaseModel.h"
#import "BagelConstants.h"
#import "BagelCryptor.h"
#import "BagelDevice.h"
#import "BagelProject.h"
#import "BagelRequestInfo.h"
#import "BagelRequestPacket.h"
#import "BagelUtility.h"

FOUNDATION_EXPORT double BagelCoreVersionNumber;
FOUNDATION_EXPORT const unsigned char BagelCoreVersionString[];

