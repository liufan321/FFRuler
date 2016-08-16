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
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@end

@implementation CodeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FFRulerControl *ruler = [[FFRulerControl alloc] initWithFrame:CGRectMake(0, 0, 300, 120)];
    ruler.center = self.view.center;
    
    [self.view addSubview:ruler];
    
    ruler.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    
    // 最小值
    ruler.minValue = 10;
    // 最大值
    ruler.maxValue = 100;
    // 数值步长
    ruler.valueStep = 5;
    
    // 添加监听方法
    [ruler addTarget:self action:@selector(weightChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)weightChanged:(FFRulerControl *)ruler {
    _weightLabel.text = [NSString stringWithFormat:@"体重: %.02f kg", ruler.selectedValue];
}

@end
