# CustomAlert
自定义 Alert 和 ActionSheet

* pod install 引入
pod ‘LJXCustomAlert’

* 导入头文件
#import "CustomAlertView.h"

* alertView 调用

[CustomAlertView showInWindowAlertWithTitle:@"提示" message:@"这是一个提示信息" actionTitles:@[@"取消",@"我知道了"] actionTitleColors:@[[UIColor lightGrayColor],[UIColor orangeColor]] handler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
        
}];


* actionSheet 调用

[CustomActionSheetView showInWindowActionSheetWithTitle:@"请选择" actionTitles:@[@"相机",@"相册"] actionTitleColors:@[[UIColor lightGrayColor],[UIColor lightGrayColor]] handler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
            
}];
