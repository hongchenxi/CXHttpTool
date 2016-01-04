//
//  ViewController.m
//  AFN和MBProgressHUD组合封装
//
//  Created by cx on 16/1/3.
//  Copyright © 2016年 cx. All rights reserved.
//

#import "ViewController.h"
#import "CXHttpTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}
- (IBAction)sendAction {
    
    if(![CXHttpTool hasNetworkReachability])return;
    
    [CXHttpTool get:@"http://a.apix.cn/datatiny/phoneinfos/phoneinfo.php" params:@{@"deviceinfo":@"100c"} graceTime:NetWorkRequestGraceTimeTypeAlways success:^(id responseObj) {
        
        NSLog(@"responseObj:%@",responseObj);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error:%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
