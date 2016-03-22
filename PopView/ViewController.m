//
//  ViewController.m
//  PopView
//
//  Created by apple on 16/1/1.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong)UIView *popView;
@property(nonatomic,strong)UISwipeGestureRecognizer *recognizerUp;
@property(nonatomic,strong)UISwipeGestureRecognizer *recognizerDown;
@property(nonatomic,assign)BOOL isPopView;
@property(nonatomic,assign)int popCount;
@property(nonatomic,strong)UIPageControl *weatherControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    _isPopView = false;
    _popCount = 0;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 50, 50, 30)];
    button.backgroundColor = [UIColor grayColor];
    [button addTarget:self action:@selector(showPopView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _recognizerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showPopView)];
    _recognizerUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:_recognizerUp];
    
    _recognizerDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hidePopView)];
    _recognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:_recognizerDown];

    NSLog(@"");
    
}


-(void)showPopView
{
    _isPopView = true;
    _popCount++;
    
    if (_popCount == 1)
    {
        _popView = [[UIView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height + 20, 250, self.view.frame.size.height - 300)];
        _popView.backgroundColor = [UIColor whiteColor];
        _popView.alpha = 1;
        _popView.layer.cornerRadius = 15.0;
        [self.view addSubview:_popView];
        
        [self initPopScrollView];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _popView.center = CGPointMake(self.view.center.x, self.view.center.y - 30);
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _popView.center = CGPointMake(self.view.center.x, self.view.center.y);
                    
                } completion:^(BOOL finished) {
                    [self popViewAnimation:_popView];
                }];
            }
        }];

    }
    
    
}

-(void)hidePopView
{
    _isPopView = false;
    _popCount = 0;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _popView.center = CGPointMake(self.view.center.x, self.view.frame.size.height*2);
        
    } completion:^(BOOL finished) {
        if (finished) {
            [_popView removeFromSuperview];
        }
    }];

}

-(void)popViewAnimation:(UIView*)view
{
   [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
       
        _popView.transform = CGAffineTransformMakeRotation(2.0/360.0);
       if (!_isPopView)
       {
           _popView.center = CGPointMake(self.view.center.x-2, self.view.center.y + 2);

       }
       
    } completion:^(BOOL finished) {
        if (finished) {
            
            [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
                
                _popView.transform = CGAffineTransformMakeRotation(-1/360.0);
                _popView.center =CGPointMake(self.view.center.x+2, self.view.center.y);
                
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
                        _popView.transform = CGAffineTransformMakeRotation(0);
                        _popView.center = CGPointMake(self.view.center.x, self.view.center.y - 2);

                    } completion:^(BOOL finished) {
                        if (finished) {
                            [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
                                _popView.transform = CGAffineTransformMakeRotation(2.0/360.0);
                                _popView.center = CGPointMake(self.view.center.x-2, self.view.center.y + 2);
                                
                            } completion:^(BOOL finished) {
                                [self popViewAnimation:_popView];
                            }];
                        }

                    }];
                }
            }];
        }
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    if (page == 0) {
        _weatherControl.currentPage = 0;
    }
    else if (page == 1)
    {
        _weatherControl.currentPage = 1;
    }
    else if (page == 2)
    {
        _weatherControl.currentPage = 2;
    }
    else if (page == 3)
    {
        _weatherControl.currentPage = 3;
    }
}

-(void)initPopScrollView
{
    UIScrollView *weaScrView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 60, 260, _popView.frame.size.height - 80)];
    weaScrView.contentSize = CGSizeMake(1040, _popView.frame.size.height - 80);
    weaScrView.pagingEnabled = YES;
    weaScrView.showsHorizontalScrollIndicator = NO;
    weaScrView.showsVerticalScrollIndicator = NO;
    weaScrView.delegate = self;
    [_popView addSubview:weaScrView];
    
    _weatherControl = [[UIPageControl alloc]init];
    _weatherControl.center = CGPointMake(125, _popView.frame.size.height-20);
    _weatherControl.numberOfPages = 4;
    _weatherControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _weatherControl.currentPage = 0;
    [_popView addSubview:_weatherControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
