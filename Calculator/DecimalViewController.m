//
//  DecimalViewController.m
//  Calculator
//
//  Created by Shannon Yap on 5/7/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import "DecimalViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DecimalViewController ()

@end

@implementation DecimalViewController

@synthesize console, opcode, opPrev, firstNum, secondNum;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage: nil];
    backgroundImage.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    backgroundImage.userInteractionEnabled = YES; // enable touch events
    [self.view addSubview:backgroundImage];
    
    // Blur effect to show calculator number screen
    UIImageView *img = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, 149.55)];
    [[img layer] setBorderWidth: 0.25];
    [[img layer] setMasksToBounds: YES];
    [backgroundImage addSubview: img];
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = img.bounds;
    [img addSubview:visualEffectView];
    
    UIImageView *consoleColor = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, img.bounds.size.height)];
    [consoleColor setBackgroundColor: [UIColor colorWithRed:72.0/255.0f green:137.0/255.0f blue:249.0/255.0f alpha:0.8f]];
    [self.view addSubview: consoleColor];
    
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
    
    // Creating the number pad
    CGRect numPad = CGRectMake(0, img.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - img.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    NSMutableArray *buttonArray = [[NSMutableArray alloc] init];
    int x = 0;
    int y = 0;
    for(int i = 0; i < 19; i++){
        //Create the button
        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(numPad.size.width/4 * x, (numPad.size.height/5 * y) + img.bounds.size.height, numPad.size.width/4, (numPad.size.height)/5)];
        // create enlarged 0 button
        if (i == 16) {
            button = [[UIButton alloc] initWithFrame: CGRectMake(numPad.size.width/4 * x, (numPad.size.height/5 * y) + img.bounds.size.height, numPad.size.width/2, numPad.size.height/5)];
            x++;
        }
        x++;
        if (x % 4 == 0 && x != 0) {
            x = 0;
            y++;
        }
        
        // button design
        button.backgroundColor = [UIColor colorWithRed: 245.0/255.0f green:245.0/255.0f blue:245.0/255.0f alpha: 1.0f];
        if (i == 0 || i == 1 || i == 2 || i == 3 || i == 7 || i == 11 || i == 15 || i == 18){
            button.backgroundColor = [UIColor colorWithRed:72.0/255.0f green:137.0/255.0f blue:249.0/255.0f alpha:1.0f];
            
        }
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize: 30];
        [[button layer] setBorderWidth: 0.25];
        [[button layer] setMasksToBounds: YES];
        [[button layer] setBorderColor: [UIColor blackColor].CGColor];
        //button actions
        [button addTarget: self action: @selector(tapNumber:) forControlEvents:UIControlEventTouchDown];
        [button addTarget: self action: @selector(removeTap:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchDragExit];
        // get all the text and populate the number pad.
        NSArray *numPadArr = [NSArray arrayWithObjects: @"C", @"%", @"+/-", @"÷", @"1", @"2", @"3", @"X", @"4", @"5", @"6", @"-", @"7", @"8", @"9", @"+", @"0", @".", @"=", nil];
        [button setTitle: [numPadArr objectAtIndex: (NSUInteger) i ] forState: UIControlStateNormal];
        [button setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        //Store the button in our array
        [buttonArray addObject:button];
    }
    for(UIButton *buttons in buttonArray){
        if (buttons.tag == 0 || buttons.tag == 1 || buttons.tag == 2 || buttons.tag == 3 || buttons.tag == 7 || buttons.tag == 11 || buttons.tag == 15 || buttons.tag == 18){
            [buttons setTitleColor: [UIColor colorWithRed: 200.0/255.0f green:200.0/255.0f blue:200.0/255.0f alpha: 1.0f] forState: UIControlStateNormal];
        }
        //add the button to the view
        [backgroundImage addSubview:buttons];
    }
}

- (void) tapNumber:(UIButton *)sender {
    if (opcode != nil) {
        self.console.text = @"";
        opcode = nil;
    }
    if (sender.tag == 4 || sender.tag == 5 || sender.tag == 6 || sender.tag == 8 || sender.tag == 9 || sender.tag == 10 || sender.tag == 12 || sender.tag == 13 || sender.tag == 14 || sender.tag == 16){
        [sender setTitleColor: [UIColor colorWithRed:120.0/255.0f  green:120.0/255.0f blue:120.0/255.0f alpha:1.0f] forState: UIControlStateHighlighted];
        self.console.text = [self.console.text stringByAppendingString: sender.titleLabel.text];

    } else if (sender.tag == 17){
        if ([[self.console.text componentsSeparatedByString: @"."]count] - 1 == 0){
            self.console.text = [self.console.text stringByAppendingString: sender.titleLabel.text];
        }
    } else if (sender.tag == 1){
      // percent op
        double percentile = [self.console.text doubleValue]/100.0;
        self.console.text = [NSString stringWithFormat: @"%f", percentile];
    } else if (sender.tag == 2){
        // negative or positive
        double sign = -[self.console.text doubleValue];
        if (sign == (int) sign){
            self.console.text = [NSString stringWithFormat: @"%d", (int) sign];
        } else {
            self.console.text = [NSString stringWithFormat: @"%f", sign];
        }
    } else {
        opcode = sender.titleLabel.text;
    }
    if ([opcode containsString: @"+"] || [opcode containsString: @"-"] || [opcode containsString: @"X"] || [opcode containsString: @"÷"]){
        firstNum = [self.console.text doubleValue];
        opPrev = opcode;
    } else if ([opcode containsString: @"="]){
        secondNum = [self.console.text doubleValue];
        if ([opPrev containsString: @"+"]){
            if ((firstNum + secondNum) == (int)(firstNum + secondNum)){
                self.console.text = [NSString stringWithFormat: @"%d", (int)(firstNum + secondNum)];
            } else {
                self.console.text = [NSString stringWithFormat: @"%f", firstNum + secondNum];
            }
        } else if ([opPrev containsString: @"-"]){
            if ((firstNum - secondNum) == (int)(firstNum - secondNum)){
                self.console.text = [NSString stringWithFormat: @"%d", (int)(firstNum - secondNum)];
            } else {
                self.console.text = [NSString stringWithFormat: @"%f", firstNum - secondNum];
            }
        } else if ([opPrev containsString: @"X"]){
            if ((firstNum * secondNum) == (int)(firstNum * secondNum)){
                self.console.text = [NSString stringWithFormat: @"%d", (int)(firstNum * secondNum)];
            } else {
                self.console.text = [NSString stringWithFormat: @"%f", firstNum * secondNum];
            }
        } else if ([opPrev containsString: @"÷"]) {
            if ((firstNum / secondNum) == (int)(firstNum / secondNum)){
                self.console.text = [NSString stringWithFormat: @"%d", (int)(firstNum / secondNum)];
            } else {
                self.console.text = [NSString stringWithFormat: @"%f", firstNum / secondNum];
            }
        }
    }
    if (sender.tag == 0){
        // clear
        self.console.text = @"";
        opPrev = nil;
        firstNum = 0;
        secondNum = 0;
    }
    sender.alpha = 0.8;
}

- (void) removeTap:(UIButton *)sender {
    sender.alpha = 1;
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
