//
//  DetailViewController.m
//  ModuleKitDemo
//
//  Created by Minewtech on 2020/11/25.
//

#import "DetailViewController.h"
#import <MTModuleKit/MTModuleKit.h>

@interface DetailViewController ()
{
    UILabel *writeLable;
    UILabel *receiveLabel;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    writeLable = [[UILabel alloc] init];
    writeLable.textColor = [UIColor brownColor];
    writeLable.frame = CGRectMake(100, 100, 100, 40);
    [self.view addSubview:writeLable];
    
    receiveLabel = [[UILabel alloc] init];
    receiveLabel.textColor = [UIColor blackColor];
    receiveLabel.frame = CGRectMake(300, 100, 100, 40);
    [self.view addSubview:receiveLabel];
    
    
    [self writeData];
    
    [_module didReceiveData:^(NSData *data) {
        if (data) {
            NSLog(@"The data is received, the data is:%@",data);
            NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (s && s.length != 0) {
                self->receiveLabel.text = [@"received:" stringByAppendingString:s];
            }
        }
    }];
    // Do any additional setup after loading the view.
}

- (void)writeData {
    if (_module) {
        NSString *s = @"123";
        
//        Byte b[1024] = {0x01};
//        NSMutableData *mData = [[NSMutableData alloc] initWithBytes:b length:1024];
//        NSLog(@"mData : %@",mData);
        
        NSData *da = [s dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"da:%@",da);
        [_module writeData:da completion:^(BOOL success, NSError *error) {
            if (success) {
                NSLog(@"write data success");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.015 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self writeData];
                });
                self->writeLable.text = [@"write:" stringByAppendingString:s];
            }
            else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.015 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self writeData];
                });

                NSLog(@"write data failed");
            }
        }];
    }
}

@end
