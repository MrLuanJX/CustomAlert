//
//  ViewController.m
//  CustomAlert
//
//  Created by hogo0211 on 2021/11/23.
//

#import "ViewController.h"

#import "CustomAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *ljxAlertBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 30)];
    ljxAlertBtn.backgroundColor = [UIColor redColor];
    [ljxAlertBtn setTitle:@"alertBtn" forState:UIControlStateNormal];
    [ljxAlertBtn addTarget:self action:@selector(alertAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ljxAlertBtn];
    
    UIButton *sheetBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 100, 30)];
    sheetBtn.backgroundColor = [UIColor grayColor];
    [sheetBtn setTitle:@"actionSheet" forState:UIControlStateNormal];
    [sheetBtn addTarget:self action:@selector(sheetAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sheetBtn];
}

- (void)alertAction {
    [CustomAlertView showInWindowAlertWithTitle:@"提示" message:@"pod lib lint CustomAlert.podspec" actionTitles:@[@"取消",@"我知道了"] actionTitleColors:@[[UIColor lightGrayColor],[UIColor orangeColor]] handler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
        NSLog(@"alert: %ld--%@",buttonIndex,buttonTitle);
    }];
}

- (void)sheetAction {
    [CustomActionSheetView showInWindowActionSheetWithTitle:@"请选择" actionTitles:@[@"相机",@"相册"] actionTitleColors:@[[UIColor lightGrayColor],[UIColor lightGrayColor]] handler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
        NSLog(@"actionSheet: %ld--%@",buttonIndex,buttonTitle);
    }];
}

@end
