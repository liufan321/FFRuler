//
//  IBDemoViewController.m
//  FFRuler
//
//  Created by 刘凡 on 2016/8/15.
//  Copyright © 2016年 joyios. All rights reserved.
//

#import "IBDemoViewController.h"
#import "FFRulerControl.h"

@interface IBDemoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@end

@implementation IBDemoViewController

- (IBAction)heightChanged:(FFRulerControl *)sender {
    _heightLabel.text = [NSString stringWithFormat:@"身高: %.02f cm", sender.selectedValue];
}

- (IBAction)weightChanged:(FFRulerControl *)sender {
    _weightLabel.text = [NSString stringWithFormat:@"体重: %.02f kg", sender.selectedValue];
}

@end
