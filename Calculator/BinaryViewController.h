//
//  BinaryViewController.h
//  Calculator
//
//  Created by Shannon Yap on 5/7/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BinaryViewController : UIViewController

@property NSMutableArray *buttonArray;
@property NSMutableArray *colorArray;
@property UIImageView *consoleBack;
@property UITextField *console;
@property NSString *op;
@property NSString *opNow;
@property int opCount;
@property int equalPress;
@property int colorCount;
@property long firstNum, secondNum;

- (void) tapNumber :(UIButton *)sender;
- (void) removeTap :(UIButton *)sender;
- (void) changeColorLeft: (UISwipeGestureRecognizer *) swipe;
- (void) changeColorRight: (UISwipeGestureRecognizer *) swipe;
+ (NSString *) decToBinary:(NSUInteger)decInt;
@end
