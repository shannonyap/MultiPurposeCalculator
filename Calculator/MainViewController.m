//
//  MainViewController.m
//  Calculator
//
//  Created by Shannon Yap on 5/7/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import "MainViewController.h"
#import "DecimalViewController.h"
#import "HexViewController.h"
#import "BinaryViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    DecimalViewController *decimalCalc = [[DecimalViewController alloc] init];
    HexViewController *hexCalc = [[HexViewController alloc] init];
    BinaryViewController *binCalc = [[BinaryViewController alloc] init];
    
    // Create 3 views representing different calculators
    NSMutableArray *tabViewControllers = [[NSMutableArray alloc] init];
    [tabViewControllers addObject: decimalCalc];
    [tabViewControllers addObject: hexCalc];
    [tabViewControllers addObject: binCalc];
    
    [self setViewControllers: tabViewControllers animated: YES];
    
    // decimal tab
    UIImage *decimalImg =[[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"decimal" ofType: @"png" inDirectory: @"icons"]] ;
    UIImage *scaledDecImage =
    [UIImage imageWithCGImage:[decimalImg CGImage]
                        scale: (decimalImg.scale * 16.0)
                  orientation:(decimalImg.imageOrientation)];
    UITabBarItem *decimalTab = [[UITabBarItem alloc] initWithTitle: @"Decimal" image: scaledDecImage tag: 0];
    decimalCalc.tabBarItem = decimalTab;
    
    // hex tab
    UIImage *hexImg =[[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"hex" ofType: @"png" inDirectory: @"icons"]] ;
    UIImage *scaledHexImage =
    [UIImage imageWithCGImage:[hexImg CGImage]
                        scale:(hexImg.scale * 16.0)
                  orientation:(hexImg.imageOrientation)];
    UITabBarItem *hexTab = [[UITabBarItem alloc] initWithTitle: @"Hex" image: scaledHexImage tag: 1];
    hexCalc.tabBarItem = hexTab;
    
    // binary tab
    UIImage *binImg =[[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"binary" ofType: @"png" inDirectory: @"icons"]] ;
    UIImage *scaledBinImage =
    [UIImage imageWithCGImage:[binImg CGImage]
                        scale:(binImg.scale * 17.0)
                  orientation:(binImg.imageOrientation)];
    UITabBarItem *binTab = [[UITabBarItem alloc] initWithTitle: @"Binary" image: scaledBinImage tag: 2];
    binCalc.tabBarItem = binTab;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotate {
    return NO;
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
