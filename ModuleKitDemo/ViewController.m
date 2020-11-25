//
//  ViewController.m
//  ModuleKitDemo
//
//  Created by Minewtech on 2020/11/25.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import <MTModuleKit/MTModuleKit.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    MTModuleManager * manager;
    UITableView *table;
    NSMutableArray *dataAry;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataAry = [NSMutableArray arrayWithCapacity:10];
    // Get Manager instance
    manager = [MTModuleManager sharedInstance];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(self->manager.status == Poweron) {
            // startScan
            [self->manager startScan:^(NSArray<MTModule *> *Modules){
                // When the surrounding devices are detected, this block will call back.
                [self update];
            }];
        }
    });
    
    // If you need to respond to the Bluetooth status of the phone. Please listen for callback.
    [manager didChangesBluetoothStatus:^(BluetoothStatus status){
        
        switch(status) {
            case Poweron:
                NSLog(@"bluetooth status change to poweron");
                break;
            case Poweroff:
                NSLog(@"bluetooth status change to poweroff");
                break;
            case Unknown:
                NSLog(@"bluetooth status change to unknown");
        }
        
    }];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataAry.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [manager stopScan];
    MTModule *module = dataAry[indexPath.row];
    [module didChangeConnection:^(MTModule *module, Connection connection) {
        if (connection == Connected) {
            NSLog(@"device has connected");
            DetailViewController *detail = [[DetailViewController alloc] init];
            detail.module = module;
            [self presentViewController:detail animated:YES completion:nil];
        }
    }];
    
    // connect to module deveice
    [manager connect:module];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tableviewcellID = @"testcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableviewcellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableviewcellID];
    }
    cell.textLabel.text = ((MTModule *)dataAry[indexPath.row]).mac;
    return cell;
}

- (void)update {
    [dataAry removeAllObjects];
    for (MTModule *mo in manager.scannedModules) {
        //you can filter what your want.
//        if ([mo.name containsString:@"Minew"]) {
            [dataAry addObject:mo];
//        }
    }
    [table reloadData];
}

@end
