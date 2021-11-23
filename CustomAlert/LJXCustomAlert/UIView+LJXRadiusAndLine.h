//
//  UIView+LJXRadiusAndLine.h
//  LJXRadiusAndLine
//
//  Created by 栾金鑫 on 2019/9/2.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

/* corners 的可能值  */
typedef NS_OPTIONS(NSUInteger, LJXBorderSideType) {
    UIBorderSideTypeAll  = 0,
    UIBorderSideTypeTop = 1 << 0,
    UIBorderSideTypeBottom = 1 << 1,
    UIBorderSideTypeLeft = 1 << 2,
    UIBorderSideTypeRight = 1 << 3,
    UIBorderSideTypeTopRight = 1 << 4,          // 上右
    UIBorderSideTypeBottomRight = 1 << 5,       // 下右
    UIBorderSideTypeTopLeft = 1 << 6,           // 上左
    UIBorderSideTypeBottomLeft = 1 << 7,        // 下左
};

@interface UIView (LJXRadiusAndLine)
// 仅圆角
- (void)radiusOnlyWithType:(LJXBorderSideType)borderType Radius:(CGFloat)radius;

// 圆角+边线
- (void)addLineOriginWithType:(LJXBorderSideType)borderType Radius:(CGFloat)radius backgroundColor:(UIColor*)backgroundColor borderLineColor:(UIColor *)color borderLineWidth:(CGFloat)borderLineWidth ;
@end


