//
//  CustomAlertView.m
//  CustomAlert
//
//  Created by hogo0211 on 2021/11/23.
//

#import "CustomAlertView.h"
#import "LBBorderLabel.h"
#import <Masonry/Masonry.h>
#import "UIView+JFBorders.h"
#import "UIImage+Extension.h"
#import "UIView+LJXRadiusAndLine.h"

//字体类型
#define Font_Bold @"PingFangSC-Semibold"
#define Font_Medium @"PingFangSC-Medium"
#define Font_Regular @"PingFangSC-Regular"

// window窗口
#ifdef __IPHONE_13_0
#define LBkWindow [UIApplication sharedApplication].keyWindow
#else
#define LBkWindow [UIApplication sharedApplication].windows[0]
#endif

/********************屏幕宽和高*******************/
#define LBScreenW [UIScreen mainScreen].bounds.size.width
#define LBScreenH [UIScreen mainScreen].bounds.size.height
//根据屏幕宽度计算对应View的高
#define LBFit(value) ((value * LBScreenW) / 375.0f)

#define LBNULLString(string) ((string == nil) ||[string isEqualToString:@""] ||([string length] == 0)  || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 ||[string isEqual:[NSNull null]])
//数组是否为空
#define LBArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define LBDictIsEmpty(dic) (dic == nil || ![dic isKindOfClass:[NSDictionary class]] || dic.allKeys == 0)

#define LBFontSize(x) [UIFont systemFontOfSize:(LBScreenW > 374 ? (LBScreenW > 375 ? x * 1.1 : x ) : x / 1.1)]
//16进制颜色设置
#define LBUIColorWithRGB(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 blue:((float)(rgbValue & 0x0000FF))/255.0 alpha:alphaValue]

/**字体*/
#define LBFontNameSize(name,s) [UIFont fontWithName:name size:(LBScreenW > 374 ? (LBScreenW > 375 ?s * 1.1 : s) :s / 1.1)]

@interface CustomAlertView()

@property(nonatomic, strong)UIView* bgView;
@property(nonatomic, strong)LBBorderLabel* titleLabel;
@property(nonatomic, strong)LBBorderLabel* contentLabel;
@property(nonatomic, strong)UIView* btnsView;
@property(nonatomic, copy)NSArray* buttonArray;
@property(nonatomic, copy)void(^btnsHandler)(NSUInteger buttonIndex, NSString *buttonTitle);
@end

@implementation CustomAlertView

+ (CustomAlertView*)showInWindowAlertWithTitle:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actionTitles  actionTitleColors:(NSArray *)actionTitleColors handler:(void(^)(NSUInteger buttonIndex, NSString *buttonTitle))handler {
    
    [self dismiss];
    CustomAlertView *hud = [[CustomAlertView alloc] initWithFrame:LBkWindow.bounds Title:title message:message actionTitles:actionTitles actionTitleColors:actionTitleColors];
    hud.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.2f];
    hud.titleLabel.text = title;
    hud.contentLabel.text = message;
    hud.buttonArray = actionTitles;
    hud.btnsHandler = handler;
    [LBkWindow addSubview:hud];
    
    [hud shakeToShow:hud.bgView];

    return hud;
}

+ (CustomAlertView*)dismiss {
    CustomAlertView *hud = nil;
    for (CustomAlertView *subView in LBkWindow.subviews) {
        if ([subView isKindOfClass:[CustomAlertView class]]) {
            [UIView animateWithDuration:0.15 animations:^{
                subView.bgView.transform = CGAffineTransformMakeScale(0.4, 0.4);
                subView.alpha = 0;
            } completion:^(BOOL finished) {
                [subView removeFromSuperview];
            }];
           hud = subView;
        }
    }
    return hud;
}

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actionTitles  actionTitleColors:(NSArray *)actionTitleColors {
    if (self = [super initWithFrame:frame]) {
        
        [self createUIWithTitle:title message:message actionTitles:actionTitles actionTitleColors:actionTitleColors];
    }
    return self;
}

- (void)createUIWithTitle:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actionTitles  actionTitleColors:(NSArray *)actionTitleColors {
    
    [self addSubview: self.bgView];
    [self.bgView addSubview: self.titleLabel];
    [self.bgView addSubview: self.contentLabel];
    [self.bgView addSubview: self.btnsView];
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.left.offset(LBFit(40));
        make.right.offset(-LBFit(40));
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
    }];
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentLabel.superview);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
    }];
        
    [self.btnsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.mas_equalTo(self.contentLabel.mas_bottom);
        make.bottom.mas_equalTo(self.bgView.mas_bottom);
        make.height.mas_equalTo(actionTitles.count == 0||actionTitleColors.count<actionTitles.count?0:actionTitles.count <=2 ?LBFit(50):LBFit(50)*actionTitles.count);
    }];
    
    self.titleLabel.edgeInsets = LBNULLString(title)?UIEdgeInsetsMake(0,0,0,0):LBNULLString(message)?UIEdgeInsetsMake(20,20,20,20):UIEdgeInsetsMake(20,20,0,20);
    self.contentLabel.edgeInsets = LBNULLString(message)?UIEdgeInsetsMake(0,0,0,0):LBNULLString(title)?UIEdgeInsetsMake(35,40,20,40):UIEdgeInsetsMake(20,40,20,40);

    [self btnWithTitlesArray:actionTitles colorsArray:actionTitleColors];
}

- (void)btnWithTitlesArray:(NSArray*)titlesArray colorsArray:(NSArray*)colorsArray {
    
    UIButton * firstBtn = [UIButton new];
    firstBtn.tag = 1000;
    [firstBtn setTitle:titlesArray.firstObject forState:UIControlStateNormal];
    [firstBtn setTitleColor:colorsArray.firstObject forState:UIControlStateNormal];
    firstBtn.titleLabel.font = LBFontSize(15);
    [firstBtn addTarget:self action:@selector(btnsDown:) forControlEvents:UIControlEventTouchDown];
    [firstBtn addTarget:self action:@selector(btnsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnsView addSubview:firstBtn];
    
    if (titlesArray.count == 1) {
        [firstBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self.btnsView);
            make.height.mas_equalTo(LBFit(50));
        }];
    } else if (titlesArray.count == 2) {
        UIButton * btn = [UIButton new];
        btn.tag = 1001;
        [btn setTitle:titlesArray.lastObject forState:UIControlStateNormal];
        [btn setTitleColor:colorsArray.lastObject forState:UIControlStateNormal];
        btn.titleLabel.font = LBFontSize(15);
        [btn addTarget:self action:@selector(btnsDown:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(btnsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnsView addSubview:btn];
        
        UIView * line = [UIView new];
        line.backgroundColor = LBUIColorWithRGB(0xDBDBDB, 1.0);
        [self.btnsView addSubview:line];
        
        [firstBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self.btnsView);
            make.height.mas_equalTo(LBFit(50));
            make.width.mas_equalTo(self.btnsView.mas_width).multipliedBy(0.5);
        }];
        
        [line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(self.btnsView);
            make.width.mas_equalTo(1);
            make.left.mas_equalTo(firstBtn.mas_right);
        }];
        
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.btnsView);
            make.width.height.top.mas_equalTo(firstBtn);
        }];
    } else {
        if (colorsArray.count<titlesArray.count) return;
        
        for (int i = 0; i<titlesArray.count; i++) {
            UIButton *btn = [UIButton new];
            btn.tag = 1000+i;
            [btn setTitle:titlesArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:colorsArray[i] forState:UIControlStateNormal];
            btn.titleLabel.font = LBFontSize(15);
            [btn addTarget:self action:@selector(btnsDown:) forControlEvents:UIControlEventTouchDown];
            [btn addTarget:self action:@selector(btnsAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnsView addSubview:btn];
            
            [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.btnsView);
                make.height.mas_equalTo(LBFit(50));
                make.top.mas_equalTo(i*LBFit(50));
            }];
            if (i < titlesArray.count) {
                UIView *line = [UIView new];
                line.backgroundColor = LBUIColorWithRGB(0xDBDBDB, 1.0);
                [self.btnsView addSubview:line];
                [line mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.offset(0);
                    make.height.mas_equalTo(1);
                    make.top.mas_equalTo(btn.mas_bottom);
                }];
            }
        }
    }
}

- (void)btnsDown:(UIButton*)sender {
    sender.backgroundColor = [UIColor colorWithWhite:0.8 alpha:.5];
}
- (void)btnsAction:(UIButton*)sender {
    sender.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    if (self.btnsHandler) {
        self.btnsHandler(sender.tag-1000, self.buttonArray[sender.tag - 1000]);
    }
    
    [CustomAlertView dismiss];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self.btnsView jf_addTopBorderWithHeight:1 andColor:LBUIColorWithRGB(0xDBDBDB, 1.0)];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 10.0f;
        _bgView.clipsToBounds = YES;
    }
    return _bgView;
}

- (LBBorderLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [LBBorderLabel new];
        _titleLabel.font = LBFontNameSize(Font_Bold, 17);
        _titleLabel.textColor = LBUIColorWithRGB(0xEA521A, 1.0);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        [_titleLabel sizeToFit];
        _titleLabel.preferredMaxLayoutWidth = LBScreenW - LBFit(80) - LBFit(40);
    }
    return _titleLabel;
}

- (LBBorderLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [LBBorderLabel new];
        _contentLabel.font = LBFontNameSize(Font_Regular, 15);
        _contentLabel.textColor = LBUIColorWithRGB(0x696969, 1.0);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        _contentLabel.preferredMaxLayoutWidth = LBScreenW - LBFit(120);
        [_contentLabel sizeToFit];
    }
    return _contentLabel;
}

- (UIView *)btnsView {
    if (!_btnsView) {
        _btnsView = [UIView new];
        _btnsView.backgroundColor = [UIColor whiteColor];
    }
    return _btnsView;
}

- (NSArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = @[].copy;
    }
    return _buttonArray;
}

/* 显示提示框的动画 */
- (void)shakeToShow:(UIView*)aView {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.15;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5,1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0,1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}
- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

- (void)setContentColor:(UIColor *)contentColor {
    _contentColor = contentColor;
    self.contentLabel.textColor = contentColor;
}
- (void)setContentFont:(UIFont *)contentFont {
    _contentFont = contentFont;
    self.contentLabel.font = contentFont;
}

@end


#pragma mark - ActionSheet
@interface CustomActionSheetView()

@property(nonatomic, strong)UIView* actionBGView;
@property(nonatomic, strong)UILabel* titleLabel;
@property(nonatomic, strong)UIButton* cancelBtn;
@property(nonatomic, copy)NSArray* buttonArray;
@property(nonatomic, copy)void(^btnsHandler)(NSUInteger buttonIndex, NSString *buttonTitle);
@property(nonatomic, strong)MASConstraint *btmConstraint;
@property(nonatomic, assign)CGFloat actionSheetHeight;

@end

@implementation CustomActionSheetView

static float btnHeight = 50;

+ (CustomActionSheetView*)showInWindowActionSheetWithTitle:(NSString *)title actionTitles:(NSArray *)actionTitles  actionTitleColors:(NSArray *)actionTitleColors handler:(void(^)(NSUInteger buttonIndex, NSString *buttonTitle))handler {
    [self dismiss];
    CustomActionSheetView *hud = [[CustomActionSheetView alloc] initWithFrame:LBkWindow.bounds Title:title actionTitles:actionTitles actionTitleColors:actionTitleColors];
    hud.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.15f];
    hud.titleLabel.text = title;
    hud.buttonArray = actionTitles;
    hud.btnsHandler = handler;
    [LBkWindow addSubview:hud];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [hud shakeToShow:hud.actionBGView];
    });
    return hud;
}

+ (CustomActionSheetView*)dismiss {
    CustomActionSheetView *hud = nil;
    for (CustomActionSheetView *subView in LBkWindow.subviews) {
        if ([subView isKindOfClass:[CustomActionSheetView class]]) {
            //告知需要更改约束
            [subView.superview setNeedsUpdateConstraints];
            [UIView animateWithDuration:0.2 animations:^{
                subView.btmConstraint.mas_equalTo(subView.actionSheetHeight);
                [subView layoutIfNeeded];
            } completion:^(BOOL finished) {
                [subView removeFromSuperview];
            }];
            hud = subView;
        }
    }
    return hud;
}

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title actionTitles:(NSArray *)actionTitles  actionTitleColors:(NSArray *)actionTitleColors {
    if (self = [super initWithFrame:frame]) {
        
        [self createUIWithTitle:title actionTitles:actionTitles actionTitleColors:actionTitleColors];
    }
    return self;
}

- (void)createUIWithTitle:(NSString *)title actionTitles:(NSArray *)actionTitles actionTitleColors:(NSArray *)actionTitleColors {
    CGFloat cancelHeight = LBFit(btnHeight);
    if (@available(iOS 11.0, *)) {
        cancelHeight = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom>0 ?LBFit(btnHeight)+34:LBFit(btnHeight);
    }
    CGFloat titleLabelHeight = LBNULLString(title)?0:50;
    self.actionSheetHeight = cancelHeight+actionTitles.count*LBFit(btnHeight)+10+titleLabelHeight;
    
    [self addSubview:self.actionBGView];
    [self.actionBGView addSubview:self.cancelBtn];
    
    [self.actionBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.btmConstraint = make.bottom.offset(self.actionSheetHeight);
        make.height.mas_equalTo(self.actionSheetHeight);
        make.width.mas_equalTo(LBScreenW);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(cancelHeight);
        make.bottom.left.right.mas_equalTo(self.actionBGView);
    }];
    
    for (NSInteger i = 0; i < actionTitles.count; i++) {
        UIButton *btn = [UIButton new];
        [btn setTitle:actionTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:LBArrayIsEmpty(actionTitleColors)?LBUIColorWithRGB(0x666666, 1.0):actionTitleColors[i] forState:UIControlStateNormal];
        btn.titleLabel.font = LBFontNameSize(Font_Regular, 16);
        btn.tag = 2000+i;
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:LBUIColorWithRGB(0xDBDBDB, 1.0)] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionBGView addSubview:btn];
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.mas_equalTo(LBFit(btnHeight));
            make.bottom.mas_equalTo(self.cancelBtn.mas_top).offset(-10-(LBFit(btnHeight)*i));
        }];
        if (i > 0) {
            UIView *line = [UIView new];
            line.backgroundColor = LBUIColorWithRGB(0xDBDBDB, 1.0);
            [self.actionBGView addSubview:line];
            [line mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(1);
                make.left.right.offset(0);
                make.top.mas_equalTo(btn.mas_bottom);
            }];
        }
    }
    if (!LBNULLString(title)) {
        [self.actionBGView addSubview:self.titleLabel];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.offset(LBArrayIsEmpty(actionTitles)? -(cancelHeight+actionTitles.count*LBFit(btnHeight)): -(cancelHeight+actionTitles.count*LBFit(btnHeight)+10));
        }];
        
        UIView* titleLine = [UIView new];
        titleLine.backgroundColor = LBUIColorWithRGB(0xDBDBDB, 1.0);
        [self.actionBGView addSubview:titleLine];
        [titleLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.mas_equalTo(1);
            make.bottom.offset(LBArrayIsEmpty(actionTitles)?-cancelHeight:-(cancelHeight+actionTitles.count*LBFit(btnHeight)+10));
        }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 切圆角
    [self.titleLabel radiusOnlyWithType:UIBorderSideTypeTop Radius:20];
}

- (UIView *)actionBGView {
    if (!_actionBGView) {
        _actionBGView = [UIView new];
        _actionBGView.backgroundColor = [UIColor clearColor];
    }
    return _actionBGView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = LBUIColorWithRGB(0x999999, 1.0);
        _titleLabel.font = LBFontNameSize(Font_Regular, 13);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        
    }
    return _titleLabel;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:LBUIColorWithRGB(0xEA521A, 1.0) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = LBFontNameSize(Font_Regular, 16);
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn setBackgroundImage:[UIImage imageWithColor:LBUIColorWithRGB(0xDBDBDB, 1.0)] forState:UIControlStateHighlighted];
        [_cancelBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

/* 显示提示框的动画 */
- (void)shakeToShow:(UIView*)aView {
    //告知需要更改约束
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:.2 animations:^{
        [self.actionBGView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.btmConstraint.mas_equalTo(0);
        }];
        //告知父类控件绘制，不添加注释的这两行的代码无法生效
        [self.actionBGView.superview layoutIfNeeded];
    }];
}

- (void)btnsAction:(UIButton*)sender {
    if (self.btnsHandler) {
        self.btnsHandler(sender.tag-2000, self.buttonArray[sender.tag - 2000]);
    }
    [CustomActionSheetView dismiss];
}

- (void)cancelAction {
    [CustomActionSheetView dismiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [CustomActionSheetView dismiss];
}

- (void)setCancelBtnColor:(UIColor *)cancelBtnColor {
    _cancelBtnColor = cancelBtnColor;
    [self.cancelBtn setTitleColor:cancelBtnColor forState:UIControlStateNormal];
}

@end
