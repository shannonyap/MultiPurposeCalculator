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

@synthesize buttonArray, console, firstNum, secondNum, op, opNow, hasPress, opCount, equalPress;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    self.view.userInteractionEnabled = YES;
    
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
        button.backgroundColor = [UIColor orangeColor];
        if (i != 22) {
            [button setTitle: [numPadArr objectAtIndex: (NSUInteger) i] forState: UIControlStateNormal];
            if (x != 0){
                [button setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
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
    }
    if (sender.tag != 3 && sender.tag != 7 && sender.tag != 11 && sender.tag != 15 && sender.tag != 19 && sender.tag != 21) {
        if (!(sender.tag == 21 && [self.console.text containsString: @"."])){
            self.console.text = [self.console.text stringByAppendingString: sender.titleLabel.text]; // append text
        }
    }
    if (sender.tag == 3) {
        self.console.text = @"";
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
