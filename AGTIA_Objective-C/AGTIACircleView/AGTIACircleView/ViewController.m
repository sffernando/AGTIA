//
//  ViewController.m
//  AGTIACircleView
//
//  Created by fernando on 2017/2/3.
//  Copyright © 2017年 fernando. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic, strong) CircleView *cv;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.slider addTarget:self action:@selector(valuechanged:) forControlEvents:UIControlEventValueChanged];
    
    self.cv = [[CircleView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 320/2, self.view.frame.size.height/2 - 320/2, 320, 320)];
    [self.view addSubview:self.cv];
    
    //首次进入
    self.cv.circleLayer.progress = _slider.value;
}

-(void)valuechanged:(UISlider *)sender{
    
    self.cv.circleLayer.progress = sender.value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
