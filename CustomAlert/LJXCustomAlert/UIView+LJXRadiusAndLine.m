//
//  UIView+LJXRadiusAndLine.m
//  LJXRadiusAndLine
//
//  Created by 栾金鑫 on 2019/9/2.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import "UIView+LJXRadiusAndLine.h"

@implementation UIView (LJXRadiusAndLine)
// 仅切圆角
- (void)radiusOnlyWithType:(LJXBorderSideType)borderType Radius:(CGFloat)radius {
    
    UIBezierPath *maskPath = [self bezierPathWithType:borderType radius:radius];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];

    maskLayer.frame = self.bounds;

    maskLayer.path = maskPath.CGPath;

    self.layer.mask = maskLayer;
}
// 圆角+边线
- (void)addLineOriginWithType:(LJXBorderSideType)borderType Radius:(CGFloat)radius backgroundColor:(UIColor*)backgroundColor borderLineColor:(UIColor *)color borderLineWidth:(CGFloat)borderLineWidth {
    
    UIBezierPath * path = [self bezierPathWithType:borderType radius:radius];
    
    CAShapeLayer * mask  = [[CAShapeLayer alloc] init];
    mask.lineWidth = borderLineWidth;
    mask.lineCap = kCALineCapSquare;
    
    // 带边框则两个颜色不要设置成一样即可
    mask.strokeColor = color.CGColor;
    mask.fillColor = backgroundColor.CGColor;
    
    mask.path = path.CGPath;
    [self.layer addSublayer:mask];
}

- (UIBezierPath *) bezierPathWithType:(LJXBorderSideType) borderType radius:(CGFloat) radius {
    
    UIBezierPath * path;
    // 全角
    if (borderType == UIBorderSideTypeAll) {
        path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    }
    // 左侧
    if (borderType & UIBorderSideTypeLeft) {
        path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(radius, radius)];
    }
    
    // 右侧
    if (borderType & UIBorderSideTypeRight) {
        path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
    }
    // 上侧
    if (borderType & UIBorderSideTypeTop) {
        path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(radius, radius)];
    }
    // 下侧
    if (borderType & UIBorderSideTypeBottom) {
        path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
    }
    // 上左
    if (borderType & UIBorderSideTypeTopLeft) {
        path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(radius, radius)];
    }
    // 下左
    if (borderType & UIBorderSideTypeBottomLeft) {
        path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(radius, radius)];
    }
    // 上右
    if (borderType & UIBorderSideTypeTopRight) {
        path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)];
    }
    // 下右
    if (borderType & UIBorderSideTypeBottomRight) {
        path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
    }
    
    return path;
}






@end
