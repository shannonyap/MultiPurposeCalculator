//
//  HexViewController.h
//  Calculator
//
//  Created by Shannon Yap on 5/7/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HexViewController : UIViewController

@property int firstNum;
@property int secondNum;
@property NSMutableArray *buttonArray;
@property NSMutableArray *colorArray;
@property (nonatomic, strong) UITextField *console;
@property UIImageView *consoleBack;
@property NSString *op;
@property NSString *opNow;
@property int opCount;
@property int hasPress;
@property int equalPress;
@property int colorCount;
- (void) tapNumber :(UIButton *)sender;
- (void) removeTap :(UIButton *)sender;
- (void) changeColorLeft: (UISwipeGestureRecognizer *) swipe;
- (void) changeColorRight: (UISwipeGestureRecognizer *) swipe;
@end
