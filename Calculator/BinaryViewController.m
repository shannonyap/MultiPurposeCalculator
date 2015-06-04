//
//  BinaryViewController.m
//  Calculator
//
//  Created by Shannon Yap on 5/7/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import "BinaryViewController.h"

@interface BinaryViewController ()

@end

@implementation BinaryViewController

@synthesize buttonArray, console, op, opNow, opCount, equalPress, firstNum, secondNum, colorArray, consoleBack, colorCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.colorArray = [[NSMutableArray alloc] initWithObjects:
                       [UIColor colorWithRed: 89/255.0f green: 217/255.0f blue: 170/255.0f alpha:1.0f],
                       [UIColor colorWithRed: 209/255.0f green: 123/255.0f blue: 224/255.0f alpha: 1.0f],
                       [UIColor colorWithRed: 82/255.0f green: 206/255.0f blue: 255/255.0f alpha: 1.0f],
                       [UIColor colorWithRed: 255/255.0f green: 154/255.0f blue: 82/255.0f alpha: 1.0f],
                       [UIColor colorWithRed: 255/255.0f green: 82/255.0f blue: 113/255.0f alpha: 1.0f], nil];
    
    self.consoleBack = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, 149.55)];
    [self.consoleBack setBackgroundColor: [self.colorArray objectAtIndex: 3]];
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
    
    CGRect numPad = CGRectMake(0, img.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - img.frame.size.height - self.tabBarController.tabBar.frame.size.height);
    NSMutableArray *numPadArr = [[NSMutableArray alloc] initWithObjects: @"C",@"÷", @"×", @"+", @"-", @"NOT", @"AND", @"XOR", @"OR", @"0", @"1", @"=", nil];
    self.buttonArray = [[NSMutableArray alloc] init];
    
    int x = 0;
    int y = 0;
    
    for (int i = 0; i < 12; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(numPad.size.width/4 * x, img.frame.size.height + (y * numPad.size.height / 5), numPad.size.width / 4, numPad.size.height / 5)];
        if (i == 0 || i == 11) {
            button = [[UIButton alloc] initWithFrame: CGRectMake(numPad.size.width/4 * x,  img.frame.size.height + (y * numPad.size.height / 5), numPad.size.width, numPad.size.height / 5)];
            y++;
        }
        button.backgroundColor = [self.colorArray objectAtIndex: 3];
        if (i == 9 || i == 10) {
            button = [[UIButton alloc] initWithFrame: CGRectMake(numPad.size.width/4 * x, img.frame.size.height + (y * numPad.size.height / 5), numPad.size.width/2, numPad.size.height / 5)];
            [button setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            x++;
        }
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize: 30];
        [button setTitle: [numPadArr objectAtIndex: i] forState: UIControlStateNormal];
        [[button layer] setBorderWidth: 0.25];
        [[button layer] setMasksToBounds: YES];
        [[button layer] setBorderColor: [UIColor blackColor].CGColor];
        
        //button actions
        [button addTarget: self action: @selector(tapNumber:) forControlEvents:UIControlEventTouchDown];
        [button addTarget: self action: @selector(removeTap:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchDragExit];
        
        if (i != 0){
            x++;
        }
        if (x % 4 == 0 && x != 0) {
            y++;
            x = 0;
        }
        [self.buttonArray addObject: button];
    }
    
    for (UIButton *button in self.buttonArray) {
        [self.view addSubview: button];
    }
}

- (void) tapNumber:(UIButton *)sender {
    if (op != nil) {
        if (!(opCount == 1 && (sender.tag != 0 && sender.tag != 9 && sender.tag != 10 && sender.tag != 11))){
            self.console.text = @"";
            opCount = 0;
        }
        if (sender.tag != 12){
            equalPress = 0;
        }
        op = nil;
    } else if (op == nil && equalPress > 0){
        if (sender.tag == 0 || sender.tag == 9 || sender.tag == 10){
            self.console.text = @"";
        }
        equalPress = 0;
    }
    if (sender.tag == 9 || sender.tag == 10) {
        if ([self.console.text stringByAppendingString: sender.titleLabel.text].length <= 16) { // limit length to 16 bits
            self.console.text = [self.console.text stringByAppendingString: sender.titleLabel.text]; // append text
        }
    }
    if (sender.tag == 0) { // clear everything
        self.console.text = @"";
        firstNum = 0;
        secondNum = 0;
        equalPress = 0;
        opCount = 0;
        op = nil;
        opNow = nil;
    }
    if (sender.tag != 0 && sender.tag != 9 && sender.tag != 10) {
        [UIView animateWithDuration: 0.15 animations: ^{
            [self.console setAlpha: 0.0f];
        }completion: ^(BOOL finished){
            [self.console setAlpha: 1.0f];
        }];
        if (sender.tag != 11 && sender.tag != 5) {
            op = sender.titleLabel.text;
            opNow = op;
            opCount = 1;
            firstNum = strtol([self.console.text UTF8String], NULL, 2);
        } else if (sender.tag == 5) { // Bitwise NOT function
            NSMutableString *strResult = [NSMutableString string];
            for (NSUInteger i = 0; i < [self.console.text length]; i++) {
                char ch = [self.console.text characterAtIndex:i];
                NSString* string = [NSString stringWithFormat:@"%c" , ch];
                [strResult appendFormat:@"%d", !string.intValue];
            }
            self.console.text = strResult;
        } else if (sender.tag == 11) { // if equals button is pressed
            secondNum = strtol([self.console.text UTF8String], NULL, 2);
            equalPress++;
            if (equalPress == 1){
                if ([opNow isEqual: @"÷"]){
                    if (secondNum != 0){
                        self.console.text = [NSString stringWithFormat: @"%@", [BinaryViewController decToBinary: (firstNum / secondNum)]];
                    } else {
                        self.console.text = @"NaN";
                    }
                } else if ([opNow isEqual: @"×"]){
                    self.console.text = [NSString stringWithFormat: @"%@", [BinaryViewController decToBinary: (firstNum * secondNum)]];
                } else if ([opNow isEqual: @"+"]){
                    self.console.text = [NSString stringWithFormat: @"%@", [BinaryViewController decToBinary: (firstNum + secondNum)]];
                } else if ([opNow isEqual: @"-"]){
                    self.console.text = [NSString stringWithFormat: @"%@", [BinaryViewController decToBinary: (firstNum - secondNum)]];
                } else if ([opNow isEqual: @"AND"]){
                    self.console.text = [NSString stringWithFormat: @"%@", [BinaryViewController decToBinary: (firstNum & secondNum)]];
                } else if ([opNow isEqual: @"XOR"]){
                    self.console.text = [NSString stringWithFormat: @"%@", [BinaryViewController decToBinary: (firstNum ^ secondNum)]];
                } else if ([opNow isEqual: @"OR"]){
                    self.console.text = [NSString stringWithFormat: @"%@", [BinaryViewController decToBinary: (firstNum | secondNum)]];
                }
            }
        }
    }
    sender.alpha = 0.8;
}

- (void) removeTap:(UIButton *)sender {
    sender.alpha = 1.0;
}

+ (NSString *)decToBinary:(NSUInteger)decInt
{
    NSString *string = @"";
    NSUInteger x = decInt ;
    do {
        string = [[NSString stringWithFormat: @"%lu", x&1] stringByAppendingString:string];
    } while (x >>= 1);
    return string;
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
        if (buttons.tag != 9 && buttons.tag != 10){
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
        if (buttons.tag != 9 && buttons.tag != 10){
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
