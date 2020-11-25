//
//  MTModule.h
//  MTModuleKit
//
//  Created by SACRELEE on 6/2/18.
//  Copyright © 2018 MinewTech. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const sServiceString = @"Service";
static NSString *const sReceiveString = @"Receive";
static NSString *const sWriteString = @"Write";

typedef NS_ENUM(NSUInteger, Connection) {
    Disconnected = 0,
    Connected,
    Connecting,
    Validating,
};

@class MTModule;

typedef void(^WriteCompletion)(BOOL success, NSError *error);
typedef void(^ReceiveCompletion)(NSData *data);
typedef void(^ConnectionChangeCompletion)(MTModule *module, Connection connection);

@interface MTModule : NSObject


/**
   bluetooth advertising name.
 */
@property (nonatomic, readonly, copy) NSString *name;
/**
 bluetooth advertising mac.
 */
@property (nonatomic, readonly, copy) NSString *mac;

@property (nonatomic, assign) BOOL isNeedApartData;

@property (nonatomic, assign) int size;


/**
   a identifier for this module
   !!! Please note every new scanning task will get a new identifier
 */
@property (nonatomic, readonly, copy) NSString *identifier;

/**
   advertising data
 */
@property (nonatomic, readonly, strong) NSDictionary *advertisingData;

/**
   the timestamp of last update.
 */
@property (nonatomic, readonly, strong) NSDate *lastUpdate;

/**
   current connection status.
 */
@property (nonatomic, readonly, assign) Connection connection;

/**
   current rssi of this device.
 */
@property (nonatomic, readonly, assign) NSInteger rssi;

/**
   service and characteristics uuid.
 */
@property (nonatomic, readonly, strong) NSDictionary<NSString *, NSString *> *uuids;

/**
   infomations of this device.
 */
@property (nonatomic, readonly, strong) NSDictionary<NSString *, NSString *> *infos;

/**
  Send data to the device

 @param data the sending data.
 @param handler writing completion callback, success == YES means send successfully.
 */
- (void)writeData:(NSData *)data completion:(WriteCompletion)handler;

/**
  Received data from device.
  !!! this is a callback method, please listen to the block, it will execute when receiving data from device.
 @param completionHandler the receiving completion block.
 */
- (void)didReceiveData:(ReceiveCompletion)completionHandler;

/**
   listen the changes of connection.
  !!! this is a callback method, please listen to the block, it will execute when the device changes connection.
 @param completionHandler the connection changing block.
 */
- (void)didChangeConnection:(ConnectionChangeCompletion)completionHandler;

@end
