//
//  FFRulerControl.m
//  FFRuler
//
//  Created by 刘凡 on 2016/8/15.
//  Copyright © 2016年 joyios. All rights reserved.
//

#import "FFRulerControl.h"

/**
 * 小刻度间距默认值
 */
#define kMinorScaleDefaultSpacing   8.0

/**
 * 主刻度长度默认值
 */
#define kMajorScaleDefaultLength    40.0
/**
 * 中间刻度长度默认值
 */
#define kMiddleScaleDefaultLength   25.0
/**
 * 小刻度长度默认值
 */
#define kMinorScaleDefaultLength    10.0
/**
 * 刻度尺背景颜色默认值
 */
#define kRulerDefaultBackgroundColor    ([UIColor clearColor])
/**
 * 刻度颜色默认值
 */
#define kScaleDefaultColor          ([UIColor lightGrayColor])

/**
 * 刻度字体颜色默认值
 */
#define kScaleDefaultFontColor      ([UIColor darkGrayColor])
/**
 * 刻度字体默认值
 */
#define kScaleDefaultFontSize       10.0

/**
 * 指示器默认颜色
 */
#define kIndicatorDefaultColor      ([UIColor redColor])
/**
 * 指示器长度默认值
 */
#define kIndicatorDefaultLength     40.0

@interface FFRulerControl() <UIScrollViewDelegate>

@end

@implementation FFRulerControl {
    UIScrollView *_scrollView;
    UIImageView *_rulerImageView;
    UIView *_indicatorView;
}

#pragma mark - 构造函数
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    [self reloadRuler];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    if (_verticalScroll) {
        _indicatorView.frame = CGRectMake(0, size.height * 0.5, self.indicatorLength, 1);
    } else {
        _indicatorView.frame = CGRectMake(size.width * 0.5, size.height - self.indicatorLength, 1, self.indicatorLength);
    }
    
    // 设置滚动视图内容间距
    CGSize textSize = [self maxValueTextSize];
    if (_verticalScroll) {
        CGFloat offset = size.height * 0.5 - textSize.width;
        
        _scrollView.contentInset = UIEdgeInsetsMake(offset, 0, offset, 0);
    } else {
        CGFloat offset = size.width * 0.5 - textSize.width;
        
        _scrollView.contentInset = UIEdgeInsetsMake(0, offset, 0, offset);
    }
}

#pragma mark - 设置属性
- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorView.backgroundColor = indicatorColor;
}

- (void)setSelectedValue:(CGFloat)selectedValue {
    if (selectedValue < _minValue || selectedValue > _maxValue || _valueStep <= 0) {
        return;
    }
    
    _selectedValue = selectedValue;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    CGFloat spacing = self.minorScaleSpacing;
    CGSize size = self.bounds.size;
    CGSize textSize = [self maxValueTextSize];
    CGFloat offset = 0;
    
    // 计算偏移量
    CGFloat steps = [self stepsWithValue:selectedValue];
    
    if (_verticalScroll) {
        offset = size.height * 0.5 - textSize.width - steps * spacing;
        
        _scrollView.contentOffset = CGPointMake(0, -offset);
    } else {
        offset = size.width * 0.5 - textSize.width - steps * spacing;
        
        _scrollView.contentOffset = CGPointMake(-offset, 0);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGFloat spacing = self.minorScaleSpacing;
    CGSize size = self.bounds.size;
    CGSize textSize = [self maxValueTextSize];
    
    if (_verticalScroll) {
        CGFloat offset = targetContentOffset->y + size.height * 0.5 - textSize.width;
        NSInteger steps = (NSInteger)(offset / spacing + 0.5);
        
        targetContentOffset->y = -(size.height * 0.5 - textSize.width - steps * spacing) - 0.5;
    } else {
        CGFloat offset = targetContentOffset->x + size.width * 0.5 - textSize.width;
        NSInteger steps = (NSInteger)(offset / spacing + 0.5);
        
        targetContentOffset->x = -(size.width * 0.5 - textSize.width - steps * spacing) - 0.5;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!scrollView.isDragging) {
        return;
    }
    
    CGFloat spacing = self.minorScaleSpacing;
    CGSize size = self.bounds.size;
    CGSize textSize = [self maxValueTextSize];
    
    CGFloat offset = 0;
    if (_verticalScroll) {
        offset = scrollView.contentOffset.y + size.height * 0.5 - textSize.width;
    } else {
        offset = scrollView.contentOffset.x + size.width * 0.5 - textSize.width;
    }
    
    NSInteger steps = (NSInteger)(offset / spacing + 0.5);
    CGFloat value = _minValue + steps * _valueStep / 10.0;
    
    if (value != _selectedValue && (value >= _minValue && value <= _maxValue)) {
        _selectedValue = value;
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - 绘制标尺相关方法
/**
 * 刷新标尺
 */
- (void)reloadRuler {
    UIImage *image = [self rulerImage];
    
    if (image == nil) {
        return;
    }
    
    _rulerImageView.image = image;
    _rulerImageView.backgroundColor = self.rulerBackgroundColor;
    
    [_rulerImageView sizeToFit];
    _scrollView.contentSize = _rulerImageView.image.size;
    
    // 水平标尺靠下对齐
    if (!_verticalScroll) {
        CGRect rect = _rulerImageView.frame;
        rect.origin.y = _scrollView.bounds.size.height - _rulerImageView.image.size.height;
        _rulerImageView.frame = rect;
    }
    
    // 更新初始值
    self.selectedValue = _selectedValue;
}

/**
 * 生成标尺图像
 */
- (UIImage *)rulerImage {
    
    // 1. 常数计算
    CGFloat steps = [self stepsWithValue:_maxValue];
    if (steps == 0) {
        return nil;
    }
    
    // 水平方向绘制图像的大小
    CGSize textSize = [self maxValueTextSize];
    CGFloat height = self.majorScaleLength + textSize.height + 2 * self.minorScaleSpacing;
    CGFloat startX = textSize.width;
    CGRect rect = CGRectMake(0, 0, steps * self.minorScaleSpacing + 2 * startX, height);
    
    // 2. 绘制图像
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    // 1> 绘制刻度线
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (NSInteger i = _minValue; i <= _maxValue; i += _valueStep) {
        
        // 绘制主刻度
        CGFloat x = (i - _minValue) / _valueStep * self.minorScaleSpacing * 10 + startX;
        [path moveToPoint:CGPointMake(x, height)];
        [path addLineToPoint:CGPointMake(x, height - self.majorScaleLength)];
        
        if (i == _maxValue) {
            break;
        }
        
        // 绘制小刻度线
        for (NSInteger j = 1; j < 10; j++) {
            CGFloat scaleX = x + j * self.minorScaleSpacing;
            [path moveToPoint:CGPointMake(scaleX, height)];
            
            CGFloat scaleY = height - ((j == 5) ? self.middleScaleLength : self.minorScaleLength);
            [path addLineToPoint:CGPointMake(scaleX, scaleY)];
        }
    }
    
    [self.scaleColor set];
    [path stroke];
    
    // 2> 绘制刻度值
    NSDictionary *strAttributes = [self scaleTextAttributes];
    
    for (NSInteger i = _minValue; i <= _maxValue; i += _valueStep) {
        NSString *str = @(i).description;
        
        CGRect strRect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:strAttributes
                                           context:nil];
        strRect.origin.x = (i - _minValue) / _valueStep * self.minorScaleSpacing * 10 + startX - strRect.size.width * 0.5;
        strRect.origin.y = 8;
        
        [str drawInRect:strRect withAttributes:strAttributes];
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // 3. 旋转图像
    if (!_verticalScroll) {
        return result;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.height, rect.size.width), NO, 0);
    CGContextRotateCTM(UIGraphicsGetCurrentContext(), M_PI_2);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, -result.size.height);
    
    [result drawInRect:rect];
    
    result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

/**
 * 计算最小值和指定 value 之间的步长，即：绘制刻度的总数量
 */
- (CGFloat)stepsWithValue:(CGFloat)value {
    
    if (_minValue >= value || _valueStep <= 0) {
        return 0;
    }
    
    return (value - _minValue) / _valueStep * 10;
}

/**
 * 以水平绘制方向计算 `最大数值的文字` 尺寸
 */
- (CGSize)maxValueTextSize {
    
    NSString *scaleText = @(self.maxValue).description;
    
    CGSize size = [scaleText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:[self scaleTextAttributes]
                                          context:nil].size;
    
    return CGSizeMake(floor(size.width), floor(size.height));
}

/**
 * 文本属性字典
 */
- (NSDictionary *)scaleTextAttributes {
    
    CGFloat fontSize = self.scaleFontSize * [UIScreen mainScreen].scale * 0.5;
    
    return @{NSForegroundColorAttributeName: self.scaleFontColor,
             NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize]};
}

#pragma mark - 设置界面
- (void)setupUI {
    // 默认水平方向滚动
    _verticalScroll = NO;
    
    // 滚动视图
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.delegate = self;
    
    [self addSubview:_scrollView];
    
    // 标尺图像
    _rulerImageView = [[UIImageView alloc] init];
    
    [_scrollView addSubview:_rulerImageView];
    
    // 指示器视图
    _indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = self.indicatorColor;
    
    [self addSubview:_indicatorView];
}

#pragma mark - 属性默认值
- (CGFloat)minorScaleSpacing {
    if (_minorScaleSpacing <= 0) {
        _minorScaleSpacing = kMinorScaleDefaultSpacing;
    }
    return _minorScaleSpacing;
}

- (CGFloat)majorScaleLength {
    if (_majorScaleLength <= 0) {
        _majorScaleLength = kMajorScaleDefaultLength;
    }
    return _majorScaleLength;
}

- (CGFloat)middleScaleLength {
    if (_middleScaleLength <= 0) {
        _middleScaleLength = kMiddleScaleDefaultLength;
    }
    return _middleScaleLength;
}

- (CGFloat)minorScaleLength {
    if (_minorScaleLength <= 0) {
        _minorScaleLength = kMinorScaleDefaultLength;
    }
    return _minorScaleLength;
}

- (UIColor *)rulerBackgroundColor {
    if (_rulerBackgroundColor == nil) {
        _rulerBackgroundColor = kRulerDefaultBackgroundColor;
    }
    return _rulerBackgroundColor;
}

- (UIColor *)scaleColor {
    if (_scaleColor == nil) {
        _scaleColor = kScaleDefaultColor;
    }
    return _scaleColor;
}

- (UIColor *)scaleFontColor {
    if (_scaleFontColor == nil) {
        _scaleFontColor = kScaleDefaultFontColor;
    }
    return _scaleFontColor;
}

- (CGFloat)scaleFontSize {
    if (_scaleFontSize <= 0) {
        _scaleFontSize = kScaleDefaultFontSize;
    }
    return _scaleFontSize;
}

- (UIColor *)indicatorColor {
    if (_indicatorView.backgroundColor == nil) {
        _indicatorView.backgroundColor = kIndicatorDefaultColor;
    }
    return _indicatorView.backgroundColor;
}

- (CGFloat)indicatorLength {
    if (_indicatorLength <= 0) {
        _indicatorLength = kIndicatorDefaultLength;
    }
    return _indicatorLength;
}

@end
