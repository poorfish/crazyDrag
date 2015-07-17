//
//  ViewController.m
//  CrazyDrag
//
//  Created by poorfish on 7/14/15.
//  Copyright (c) 2015 poorfish. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "AboutViewController.h"

@interface ViewController (){
    
    int currentValue;
    int targetValue;
    int score;
    int round;
    
}
- (IBAction)showAlert:(id)sender;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *targetLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *roundLabel;
@property (nonatomic, strong)AVAudioPlayer *audioPlayer;

- (IBAction)sliderMove:(UISlider*)sender;
- (IBAction)startOver:(id)sender;
- (IBAction)showInfo:(id)sender;

@end

@implementation ViewController
@synthesize slider;
@synthesize targetLabel;
@synthesize scoreLabel;
@synthesize roundLabel;
@synthesize audioPlayer;

- (void)playBackgroundMusic{
    NSString *musicPath = [[NSBundle mainBundle]pathForResource:@"no" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:musicPath];
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = -1;
    if (audioPlayer == nil) {
        NSString *errorInfo = [NSString stringWithString:[error description]];
        NSLog(@"the error is %@",errorInfo);
    } else {
        [audioPlayer play];
    }
}

- (void)updateLabels{
    self.targetLabel.text = [NSString stringWithFormat:@"%d",targetValue];
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    self.roundLabel.text = [NSString stringWithFormat:@"%d", round];
}

- (void)startNewRound{
    round += 1;
    targetValue = 1 + (arc4random()%100);
    currentValue = 1 + (arc4random()%100);
    self.slider.value = currentValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self playBackgroundMusic];
    [self startNewGame];
    [self updateLabels];
    currentValue = self.slider.value;
    targetValue = 1 + (arc4random() % 100);
    
    UIImage *thumbImageNormal = [UIImage imageNamed:@"SliderThumb-Normal"];
    [self.slider setThumbImage:thumbImageNormal forState:UIControlStateNormal];
    UIImage *thumbImageHighlighted = [UIImage imageNamed:@"SliderThumb-Highlighted"];
    [self.slider setThumbImage:thumbImageHighlighted forState:UIControlStateHighlighted];
    
    UIImage *trackLeftImage = [[UIImage imageNamed:@"SliderTrackLeft"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    [self.slider setMinimumTrackImage:trackLeftImage forState:UIControlStateNormal];
    
    UIImage *trackRightImage = [[UIImage imageNamed:@"SliderTrackRight"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    [self.slider setMaximumTrackImage:trackRightImage forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self startNewRound];
    [self updateLabels];
}

- (void)startNewGame {
    score = 0;
    round = 0;
    [self startNewRound];
}

- (IBAction)showAlert:(id)sender {
    int difference = abs(currentValue - targetValue);
    int points = 100 - difference;
    score += points;
    
    NSString *title;
    
    if (difference==0) {
        title = @"你太NB了！";
        points += 100;
    } else if(difference<5){
        if (difference == 1) {
            points += 50;
        }
        title = @"太棒了，只差一点！";
    } else if (difference<10){
        title = @"好吧，还算勉强";
    } else {
        title = @"加油哦！";
    }
    
    NSString *message = [NSString stringWithFormat:@"当前数值是：%d，目标数值是：%d \n 得分：%d",currentValue,targetValue,points];
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"知道了"otherButtonTitles:nil, nil]show];
}

- (IBAction)sliderMove:(UISlider*)sender {
    //UISlider *slider = (UISlider*)sender;
    currentValue = lroundf(sender.value);
    //NSLog(@"当前数值是：%f", slider.value);
}

- (IBAction)startOver:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self startNewGame];
    [self updateLabels];
    
    [self.view.layer addAnimation:transition forKey:nil];
}

- (IBAction)showInfo:(id)sender {
    AboutViewController *controller = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}
@end
