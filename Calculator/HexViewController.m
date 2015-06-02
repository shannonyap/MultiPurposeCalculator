//
//  HexViewController.m
//  Calculator
//
//  Created by Shannon Yap on 5/7/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import "HexViewController.h"

@interface HexViewController ()

@end


@implementation HexViewController

@synthesize buttonArray, console, firstNum, secondNum, op, opNow, hasPress, opCount, equalPress, colorArray, consoleBack, colorCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.view.userInteractionEnabled = YES;
    
    self.colorArray = [[NSMutableArray alloc] initWithObjects:
                       [UIColor colorWithRed: 89/255.0f green: 217/255.0f blue: 170/255.0f alpha:1.0f],
                       [UIColor colorWithRed: 209/255.0f green: 123/255.0f blue: 224/255.0f alpha: 1.0f],
                       [UIColor colorWithRed: 82/255.0f green: 206/255.0f blue: 255/255.0f alpha: 1.0f],
                       [UIColor colorWithRed: 255/255.0f green: 154/255.0f blue: 82/255.0f alpha: 1.0f],
                       [UIColor colorWithRed: 255/255.0f green: 82/255.0f blue: 113/255.0f alpha: 1.0f], nil];
    
    self.consoleBack = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, 149.55)];
    [self.consoleBack setBackgroundColor: [self.colorArray objectAtIndex: 0]];
    self.consoleBack.userInteractionEnabled = YES;
    [self.view addSubview: self.consoleBack];
    
    // Swipe to change background color!
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(changeColorLeft:)];
    [swipeLeft setDirection: UISwipeGestureRecognizerDirectionLeft];
    [self.consoleBack addGestureRecognizer: swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(changeColorRight:)];
    [swipeRight setDirection: UISwipeGestureRecognizerDirectionRight];
    [self.consoleBack addGestureRecognizer: swipeRight];
    
    // blur effect
    UIImageView *img = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, 149.55)];
    [self.view addSubview: img];
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = img.bounds;
    [img addSubview:visualEffectView];
    
    // Console for showing calculator input
    self.console = [[UITextField alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, img.frame.size.height)];
    [self.console setUserInteractionEnabled: NO];
    [self.console setContentVerticalAlignment: UIControlContentVerticalAlignmentBottom];
    [self.console setTextAlignment: NSTextAlignmentRight];
    self.console.adjustsFontSizeToFitWidth = YES;
    [self.console setFont: [UIFont fontWithName: @"Arial" size: 70.0f]];
    self.console.minimumFontSize = 35.0f;
    [self.console setText: @""];
    [self.view addSubview: self.console];
    
    //Numpad
    CGRect numPad = CGRectMake(0, img.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - img.frame.size.height - self.tabBarController.tabBar.frame.size.height);
    NSMutableArray *numPadArr = [[NSMutableArray alloc] initWithObjects: @"A", @"B",@"C",@"AC", @"D",@"E", @"F", @"÷", @"1",@"2",@"3",@"×",@"4",@"5",@"6",@"+",@"7",@"8",@"9",@"-",@"0",@"=", nil];
    self.buttonArray = [[NSMutableArray alloc] init];
    
    int x = 0;
    int y = 0;
    for (int i = 0; i < 23; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake((numPad.size.width / 4) * x, img.frame.size.height + (numPad.size.height / 6) * y, self.view.bounds.size.width / 4,  numPad.size.height / 6)];
        if (i == 20) {
            button = [[UIButton alloc] initWithFrame: CGRectMake((numPad.size.width / 4) * x, img.frame.size.height + (numPad.size.height / 6) * y, self.view.bounds.size.width * 0.75 , numPad.size.height / 6)];
            x += 2;
        }
        x++;
        if (x > 3) {
            x = 0;
            y++;
        }
        
        //button actions
        [button addTarget: self action: @selector(tapNumber:) forControlEvents:UIControlEventTouchDown];
        [button addTarget: self action: @selector(removeTap:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchDragExit];
        
        // button characteristics
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize: 30];
        [[button layer] setBorderWidth: 0.25];
        [[button layer] setMasksToBounds: YES];
        [[button layer] setBorderColor: [UIColor blackColor].CGColor];
        button.backgroundColor = [UIColor colorWithRed:89/255.0f green: 217/255.0f blue: 170/255.0f alpha:1.0f];
        if (i != 22) {
            [button setTitle: [numPadArr objectAtIndex: (NSUInteger) i] forState: UIControlStateNormal];
            if (x != 0){
                [button setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
                button.backgroundColor = [UIColor whiteColor];
            }
        }
        [self.buttonArray addObject: button];
    }
    
    // add buttons to view
    for (UIButton *button in self.buttonArray) {
        [self.view addSubview: button];
    }
}

- (void) tapNumber:(UIButton *)sender {
    if (op != nil) {
        if (!(opCount == 1 && (sender.tag == 7 || sender.tag == 11 || sender.tag == 15 || sender.tag == 19))){
            self.console.text = @"";
            opCount = 0;
        }
        if (sender.tag != 22){
            equalPress = 0;
        }
        op = nil;
    } else if (op == nil && equalPress > 0){
        if (sender.tag != 7 && sender.tag != 11 && sender.tag != 15 && sender.tag != 19 && sender.tag != 21){
            self.console.text = @"";
        }
        equalPress = 0;
    }
    if (sender.tag != 3 && sender.tag != 7 && sender.tag != 11 && sender.tag != 15 && sender.tag != 19 && sender.tag != 21) {
        if (!(sender.tag == 21 && [self.console.text containsString: @"."])){
            self.console.text = [self.console.text stringByAppendingString: sender.titleLabel.text]; // append text
        }
    }
    if (sender.tag == 3) { // clear everything
        self.console.text = @"";
        firstNum = 0;
        secondNum = 0;
        equalPress = 0;
        opCount = 0;
        op = nil;
        opNow = nil;
    }
    if (sender.tag == 7 || sender.tag == 11 || sender.tag == 15 || sender.tag == 19 || sender.tag == 21) {
        [UIView animateWithDuration: 0.15 animations: ^{
            [self.console setAlpha: 0.0f];
        }completion: ^(BOOL finished){
            [self.console setAlpha: 1.0f];
        }];
        if (sender.tag != 21) {
            unsigned result = 0;
            NSScanner *scanner = [NSScanner scannerWithString: self.console.text];
            [scanner scanHexInt:&result];
            
            op = sender.titleLabel.text;
            opNow = op;
            opCount = 1;
            firstNum = result;
        } else if (sender.tag == 21) { // if equals button is pressed
            unsigned result = 0;
            NSScanner *scanner = [NSScanner scannerWithString: self.console.text];
            [scanner scanHexInt:&result];
            
            equalPress++;
            secondNum = result;
            if (equalPress == 1){
                if ([opNow isEqual: @"÷"]){
                    self.console.text = [NSString stringWithFormat: @"%X", firstNum / secondNum];
                } else if ([opNow isEqual: @"×"]){
                    self.console.text = [NSString stringWithFormat: @"%X", firstNum * secondNum];
                } else if ([opNow isEqual: @"+"]){
                    self.console.text = [NSString stringWithFormat: @"%X", firstNum + secondNum];
                } else if ([opNow isEqual: @"-"]){
                    self.console.text = [NSString stringWithFormat: @"%X", firstNum - secondNum];
                }
            }
        }
    }
    sender.alpha = 0.8;
}

- (void) removeTap:(UIButton *)sender {
    sender.alpha = 1.0;
}

- (void) changeColorLeft:(UISwipeGestureRecognizer *)swipe {
    colorCount++;
    if (colorCount > 4){
        colorCount = 0;
    }
    [UIImageView animateWithDuration: 0.5 animations: ^{
        self.consoleBack.backgroundColor = [self.colorArray objectAtIndex: colorCount];
    }];
    for ( UIButton *buttons in self.buttonArray) {
        if (buttons.tag == 3 || buttons.tag == 7 || buttons.tag == 11 || buttons.tag == 15 || buttons.tag == 19 || buttons.tag == 21){
            [UIButton animateWithDuration: 0.5 animations: ^{
                buttons.backgroundColor = [self.colorArray objectAtIndex: colorCount];
            }];
        }
    }
}

- (void) changeColorRight:(UISwipeGestureRecognizer *)swipe {
    colorCount--;
    if (colorCount < 0){
        colorCount = 4;
    }
    [UIImageView animateWithDuration: 0.5 animations: ^{
        self.consoleBack.backgroundColor = [self.colorArray objectAtIndex: colorCount];
    }];
    for ( UIButton *buttons in self.buttonArray) {
        if (buttons.tag == 3 || buttons.tag == 7 || buttons.tag == 11 || buttons.tag == 15 || buttons.tag == 19 || buttons.tag == 21){
            [UIButton animateWithDuration: 0.5 animations: ^{
                buttons.backgroundColor = [self.colorArray objectAtIndex: colorCount];
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
