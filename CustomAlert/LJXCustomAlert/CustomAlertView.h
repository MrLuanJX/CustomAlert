//
//  CustomAlertView.h
//  CustomAlert
//
//  Created by hogo0211 on 2021/11/23.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UIView

@property(nonatomic,strong)UIFont* titleFont;
@property(nonatomic,strong)UIColor* titleColor;

@property(nonatomic,strong)UIFont* contentFont;
@property(nonatomic,strong)UIColor* contentColor;

+ (CustomAlertView*)showInWindowAlertWithTitle:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actionTitles  actionTitleColors:(NSArray *)actionTitleColors handler:(void(^)(NSUInteger buttonIndex, NSString *buttonTitle))handler;

+ (CustomAlertView*)dismiss;

@end

@interface CustomActionSheetView : UIView

@property(nonatomic,strong)UIColor* cancelBtnColor;

+ (CustomActionSheetView*)showInWindowActionSheetWithTitle:(NSString *)title actionTitles:(NSArray *)actionTitles actionTitleColors:(NSArray *)actionTitleColors handler:(void(^)(NSUInteger buttonIndex, NSString *buttonTitle))handler;

+ (CustomActionSheetView*)dismiss;

@end
