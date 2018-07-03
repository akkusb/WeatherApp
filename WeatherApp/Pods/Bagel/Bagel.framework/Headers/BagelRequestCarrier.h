//
// Copyright (c) 2017 Bagel (https://github.com/yagiz/Bagel)
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

#import <Foundation/Foundation.h>
#import <BagelCore/BagelRequestPacket.h>

@interface BagelRequestCarrier : NSObject

@property (nonatomic,strong) NSString* carrierId;

@property (nonatomic,weak) NSURLSessionTask* task;
@property (nonatomic,weak) NSURLConnection* connection;

@property (nonatomic,strong) NSURLRequest* request;
@property (nonatomic,strong) NSURLResponse* response;

@property (nonatomic,strong) NSDate* startDate;
@property (nonatomic,strong) NSDate* endDate;

@property (nonatomic,strong) NSMutableData* data;
@property (nonatomic,strong) NSError* error;

@property (nonatomic) BOOL isCompleted;

- (instancetype)initWithTask:(NSURLSessionTask*)task;
- (instancetype)initWithConnection:(NSURLConnection*)connection;

- (BagelRequestPacket*)packet;

- (void)appenData:(NSData*)data;
- (void)complete;

@end
