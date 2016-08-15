//
//  CodeDemoViewController.m
//  FFRuler
//
//  Created by 刘凡 on 2016/8/15.
//  Copyright © 2016年 joyios. All rights reserved.
//

#import "CodeDemoViewController.h"
#import "FFRulerControl.h"

@interface CodeDemoViewController ()

@end

@implementation CodeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FFRulerControl *ruler = [[FFRulerControl alloc] initWithFrame:CGRectMake(0, 0, 300, 120)];
    ruler.center = self.view.center;
    
    [self.view addSubview:ruler];
    
    ruler.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
}

@end
