//
//  ViewController.m
//  CrazyDrag
//
//  Created by poorfish on 7/14/15.
//  Copyright (c) 2015 poorfish. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    
    int currentValue;
    int targetValue;
    
}
- (IBAction)showAlert:(id)sender;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *targetLabel;

- (IBAction)sliderMove:(UISlider*)sender;
@end

@implementation ViewController
@synthesize slider;
@synthesize targetLabel;

- (void)updateLabels{
    self.targetLabel.text = [NSString stringWithFormat:@"%d",targetValue];
}

- (void)startNewRound{
    targetValue = 1 + (arc4random()%100);
    currentValue = 50;
    self.slider.value = currentValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startNewRound];
    [self updateLabels];
    currentValue = self.slider.value;
    targetValue = 1 + (arc4random() % 100);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAlert:(id)sender {
    int difference;
    if (currentValue > targetValue) {
        difference = currentValue - targetValue;
    } else if(targetValue > currentValue) {
        difference = targetValue - currentValue;
    } else {
        difference = 0;
    }
    NSString *message = [NSString stringWithFormat:@"当前数值是：%d，目标数值是：%d \n 差了：%d",currentValue,targetValue,difference];
    [[[UIAlertView alloc]initWithTitle:@"您好，苍老师" message:message delegate:nil cancelButtonTitle:@"我来帮转一次，你懂的"otherButtonTitles:nil, nil]show];
    [self startNewRound];
    [self updateLabels];
}

- (IBAction)sliderMove:(UISlider*)sender {
    //UISlider *slider = (UISlider*)sender;
    currentValue = lroundf(sender.value);
    //NSLog(@"当前数值是：%f", slider.value);
}
@end
