//
//  ViewController.m
//  GooeySlideMenu
//
//  Created by fernando on 2017/2/4.
//  Copyright © 2017年 fernando. All rights reserved.
//

#import "ViewController.h"
#import "GooeySlideMenu.h"

@interface ViewController () {
    GooeySlideMenu *menu;
}

@end
@implementation ViewController
- (IBAction)trgger:(id)sender {
    [menu trigger];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    menu = [[GooeySlideMenu alloc] initWithTitles:@[@"首页",@"消息",@"发布",@"发现",@"个人",@"设置"]];
    menu.menuClickedBlock = ^(NSInteger index, NSString *title) {
        NSLog(@"index : %zd, title:%@",index, title);
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
