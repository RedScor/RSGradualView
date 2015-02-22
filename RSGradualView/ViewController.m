//
//  ViewController.m
//  RSGradualView
//
//  Created by RedScor Yuan on 2015/2/15.
//  Copyright (c) 2015年 RedScor Yuan. All rights reserved.
//

#import "ViewController.h"
#import "RSGradualView.h"

@interface ViewController ()<RSGradualViewDelegate>

@property (weak, nonatomic) IBOutlet RSGradualView *gradualViewXib;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RSGradualView *gradualView = [[RSGradualView alloc]initWithFrame:CGRectMake(200, 200, 0, 0)
                                                           normalImg:@"icon_like1_normal.png"
                                                         selectedImg:@"icon_like1_activity.png"
                                                            delegate:self];
    
    gradualView.tag = 99;
    gradualView.gradualType = GradualViewHorizontal;
    gradualView.selected = YES;
    [self.view addSubview:gradualView];
    
}

- (void)clickGradualView:(RSGradualView *)gradualView selected:(BOOL)selected
{
    UIViewController *destCtrl = [[UIViewController alloc]init];
    if (gradualView.tag == 100) {
        //from xib / storyBoard
        destCtrl.view.backgroundColor = [UIColor redColor];
        destCtrl.title = @"from UI";
    }else if (gradualView.tag == 99) {
        destCtrl.view.backgroundColor = [UIColor yellowColor];
        destCtrl.title = @"from init";
    }

//    [self.navigationController performSelector:@selector(pushViewController:animated:) withObject:destCtrl afterDelay:1.0];
}
- (IBAction)resetStatus:(id)sender {
    
    RSGradualView *gradualView = (RSGradualView *)[self.view viewWithTag:99];
    BOOL select = gradualView.selected;
    [gradualView completelAction:!select];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
