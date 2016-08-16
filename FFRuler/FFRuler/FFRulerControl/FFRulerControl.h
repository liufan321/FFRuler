//
//  FFRulerControl.h
//  FFRuler
//
//  Created by 刘凡 on 2016/8/15.
//  Copyright © 2016年 joyios. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 轻量级标尺控件
 */
IB_DESIGNABLE
@interface FFRulerControl : UIControl

/**
 * 选中的数值
 */
@property (nonatomic, assign) IBInspectable CGFloat selectedValue;

/**
 * 垂直滚动，默认 NO
 */
@property (nonatomic, assign, getter=isVerticalScroll) IBInspectable BOOL verticalScroll;

/**
 * 最小值
 */
@property (nonatomic, assign) IBInspectable NSInteger minValue;
/**
 * 最大值
 */
@property (nonatomic, assign) IBInspectable NSInteger maxValue;
/**
 * 步长
 */
@property (nonatomic, assign) IBInspectable NSInteger valueStep;

/**
 * 小刻度间距，默认值 `8.0`
 */
@property (nonatomic, assign) IBInspectable CGFloat minorScaleSpacing;

/**
 * 主刻度长度，默认值 `40.0`
 */
@property (nonatomic, assign) IBInspectable CGFloat majorScaleLength;
/**
 * 中间刻度长度，默认值 `25.0`
 */
@property (nonatomic, assign) IBInspectable CGFloat middleScaleLength;
/**
 * 小刻度长度，默认值 `10.0`
 */
@property (nonatomic, assign) IBInspectable CGFloat minorScaleLength;

/**
 * 刻度尺背景颜色，默认为 `clearColor`
 */
@property (nonatomic, strong) IBInspectable UIColor *rulerBackgroundColor;
/**
 * 刻度颜色，默认为 `lightGrayColor`
 */
@property (nonatomic, strong) IBInspectable UIColor *scaleColor;

/**
 * 刻度字体颜色，默认为 `darkGrayColor`
 */
@property (nonatomic, strong) IBInspectable UIColor *scaleFontColor;
/**
 * 刻度字体尺寸，默认为 `10.0`
 */
@property (nonatomic, assign) IBInspectable CGFloat scaleFontSize;

/**
 * 指示器颜色，默认 `redColor`
 */
@property (nonatomic, strong) IBInspectable UIColor *indicatorColor;
/**
 * 指示器长度，默认值为 `40.0`
 */
@property (nonatomic, assign) IBInspectable CGFloat indicatorLength;

@end
