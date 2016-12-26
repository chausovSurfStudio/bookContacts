//
//  AlertViewController.m
//  TimeLock_ios
//
//  Created by Александр Чаусов on 27.04.16.
//  Copyright © 2016 Александр Чаусов. All rights reserved.
//

#import "AlertViewController.h"
#import "AppDelegate.h"
#import "BCTThemeConstant.h"
#import "BCTConstant.h"
#import "FrameAccessor.h"

static NSInteger const alertHeight = 70;
static NSInteger const alertLeftSpace = 74;
static NSInteger const alertRightSpace = 6;
static CGFloat const alertDurationAnimation = 0.5;
static CGFloat const alertDelayAnimation = 0.0;
static CGFloat const alertDelayHideAnimation = 2.0;
static CGFloat const alertLabelHeightOffset = 12;

@interface AlertViewController ()

@property (nonatomic, strong) IBOutlet UILabel *alertLabel;
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;
@property (nonatomic) BOOL isNavigationAlert;
@end

@implementation AlertViewController

//синглтон
+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AlertViewController alloc] initWithNibName:@"AlertViewController" bundle:nil];
        [sharedInstance view];
    });
    
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //фрейм сообщения
    self.view.frame = CGRectMake(0, -alertHeight, SCREEN_WIDTH, alertHeight);
    self.alertLabel.numberOfLines = 0;
    [self.alertLabel sizeToFit];
    self.alertLabel.textColor = mainTextNrmColor;
    
    //gest для закрытия окна (tap и swipe)
    UITapGestureRecognizer *tapGestr = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(tapHandle:)];
    [self.view addGestureRecognizer:tapGestr];
    UISwipeGestureRecognizer *swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandle:)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipe];
}

#pragma mark - close alert
//закрытие сообщения по тапу
- (void)tapHandle:(UITapGestureRecognizer *)recognizer {
    [self hideAlert:YES delay:alertDelayAnimation];
}
//закрытие сообщения по свайпу
- (void)swipeHandle:(UITapGestureRecognizer *)recognizer {
    //[self hideAlert:YES delay:alertDelayAnimation];
}


#pragma mark - error alert
// сообщения об ошибках (параметр hide - скрывать ли сообщение автоматически)
// текст по умолчанию "Возникла ошибка"
- (void)showErrorAlert:(NSString *)text animation:(BOOL)animation autoHide:(BOOL)hide {
    self.view.backgroundColor = alertErrorColor;
    self.iconImageView.hidden = NO;
    self.alertLabel.textAlignment = NSTextAlignmentLeft;
    if (text && text.length > 0) {
        self.alertLabel.text = text;
    } else {
        self.alertLabel.text = NSLocalizedString(@"ERROR_DEFAULT_ALERT", nil);
    }
    self.isNavigationAlert = NO;
    [self showAlert:animation autoHide:hide];
}

#pragma mark - info alert
//сообщения об хороших результатах  (параметр hide - скрывать ли сообщение автоматически)
- (void)showInfoAlert:(NSString *)text animation:(BOOL)animation autoHide:(BOOL)hide {
    self.view.backgroundColor = alertInfoColor;
    self.iconImageView.hidden = NO;
    self.alertLabel.textAlignment = NSTextAlignmentLeft;
    self.alertLabel.text = text;
    self.isNavigationAlert = NO;
    [self showAlert:animation autoHide:hide];
}

#pragma mark - info alert
//сообщения об хороших результатах  (параметр hide - скрывать ли сообщение автоматически)
- (void)showInfoBasketAlert:(NSString *)text animation:(BOOL)animation autoHide:(BOOL)hide {
    self.iconImageView.hidden = YES;
    self.alertLabel.textAlignment = NSTextAlignmentCenter;
    self.view.backgroundColor = [UIColor colorWithRed:67/255. green:65/255. blue:61/255. alpha:0.98];
    self.alertLabel.text = text;
    self.isNavigationAlert = YES;
    [self showAlert:animation autoHide:hide];
}

#pragma mark - common alert show/hide
//показ сообщений любого типа (общая часть)
- (void)showAlert:(BOOL)animation autoHide:(BOOL)hide {
    self.showAfterClose = NO;
    CGFloat height = 0.0;
    CGFloat statusBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    CGFloat statusBarMinHeight = 20.f;
    CGFloat resultTopSpace = statusBarHeight > statusBarMinHeight ? statusBarHeight : 0.f;
    
    if (self.isNavigationAlert) {
        self.alertLabel.frame = CGRectMake(alertRightSpace, 0, SCREEN_WIDTH - alertRightSpace - alertRightSpace, 0);
        self.alertLabel.alpha = 0;
        CGSize maximumLabelSize = CGSizeMake(self.alertLabel.width, CGFLOAT_MAX);
        CGSize expectSize = [self.alertLabel sizeThatFits:maximumLabelSize];
        height = expectSize.height + alertLabelHeightOffset * 2;
        self.view.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, self.view.width, 0);
    } else {
        self.alertLabel.frame = CGRectMake(alertLeftSpace, 0, SCREEN_WIDTH - alertRightSpace - alertLeftSpace, alertHeight);
        self.alertLabel.alpha = 1;
        CGSize maximumLabelSize = CGSizeMake(self.alertLabel.width, CGFLOAT_MAX);
        CGSize expectSize = [self.alertLabel sizeThatFits:maximumLabelSize];
        
        height = expectSize.height + alertLabelHeightOffset * 2;
        if (height < alertHeight) {
            height = alertHeight;
        }
        self.view.frame = CGRectMake(0, resultTopSpace, SCREEN_WIDTH, 0);
    }
    
    if (self.isActive) {
        return;
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:self.view];
    self.isActive = YES;
    
    [UIView animateWithDuration:animation ? alertDurationAnimation : alertDelayAnimation
                          delay:alertDelayAnimation
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (self.isNavigationAlert) {
                             self.view.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, self.view.width, height);
                             self.alertLabel.frame = CGRectMake(alertRightSpace, 0, SCREEN_WIDTH - alertRightSpace - alertRightSpace, height);
                             self.alertLabel.alpha = 1;
                         } else {
//                             self.view.frame = CGRectMake(0, 0, self.view.width, alertHeight);
                             
                             self.view.frame = CGRectMake(0, resultTopSpace, SCREEN_WIDTH, height);
                             self.alertLabel.frame = CGRectMake(alertLeftSpace, alertLabelHeightOffset, SCREEN_WIDTH - alertLeftSpace - alertRightSpace, height);
                             self.alertLabel.alpha = 1;
                         }
                     } completion:^(BOOL finished){
                         if (hide) {
                             self.showAfterClose = NO;
                             [self hideAlert:animation delay:alertDelayHideAnimation];
                         }
                     }];
}

//скрыть сообщение с задержкой delay
- (void)hideAlert:(BOOL)animation delay:(CGFloat)delay {
    if (!self.isActive || self.showAfterClose) {
        return;
    }
    
    [UIView animateWithDuration: animation ? alertDurationAnimation : alertDelayAnimation
                          delay: delay
                        options: UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         if (self.isNavigationAlert) {
                             self.view.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, self.view.width, 0);
                             self.alertLabel.alpha = 0;
                         } else {
                             self.view.frame = CGRectMake(0, -alertHeight, self.view.width, alertHeight);
                         }
                     }
                     completion:^(BOOL finished) {
                         self.isActive = NO;
                         [self.view removeFromSuperview];
                     }];
}

@end