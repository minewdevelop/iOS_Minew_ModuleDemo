//
//  MTModuleManager.h
//  MTModuleKit
//
//  Created by SACRELEE on 6/2/18.
//  Copyright © 2018 MinewTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTModule.h"

typedef NS_ENUM(NSUInteger, BluetoothStatus) {
    Unknown = 0,
    Poweroff,
    Poweron,
};

typedef void(^ScanCompletion)(NSArray<MTModule *> *modules);
typedef void(^BluetoothChangeCompletion)(BluetoothStatus statues);

@interface MTModuleManager : NSObject

/**
  the status of iphone bluetooth.
 */
@property (nonatomic, readonly, assign) BluetoothStatus status;

/**
  the scanned modules
 */
@property (nonatomic, readonly, strong) NSArray<MTModule *> *scannedModules;

/**
  the connected modules.
 */
@property (nonatomic, readonly, strong) NSArray<MTModule *> *connectedModules;


/**
  get a sharedinstance of the MTModuleManager

 @return a sharedinstance.
 */
+ (instancetype)sharedInstance;

/**
  start a scanning task, get modules from the compltionhandler or "scannedModules" property.

 @param completionHandler a block for scanned modules.
 */
- (void)startScan:(ScanCompletion)completionHandler;

/**
  stop the scanning task.
 */
- (void)stopScan;

/**
  connect to a module

 @param module a module for connecting.
 */
- (void)connect:(MTModule *)module;

/**
 disconnect from a module.

 @param module a module for disconnecting.
 */
- (void)disconnect:(MTModule *)module;

/**
  a callback for iphone bluetooth changes.

 @param completionHandler the bluetooth status changes block.
 */
- (void)didChangesBluetoothStatus:(BluetoothChangeCompletion)completionHandler;


@end
