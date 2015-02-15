//
//  RSGradualView.m
//  buttonDemo
//
//  Created by RedScor Yuan on 2015/2/14.
//  Copyright (c) 2015年 RedScor Yuan. All rights reserved.
//

#import "RSGradualView.h"

@interface RSGradualView ()
{
    UIView *maskView;
    CGFloat imgWidth;
    CGFloat imgHeight;
}

@property (nonatomic, strong) NSArray *imgsArray;

@end

@implementation RSGradualView

- (instancetype)initWithFrame:(CGRect)frame
                    normalImg:(NSString *)normalImg
                  selectedImg:(NSString *)selectedImg
                     delegate:(id<RSGradualViewDelegate>)delegate;

{
    self = [super initWithFrame:frame];
    
    self.image = [UIImage imageNamed:normalImg];
    self.highlightedImage = [UIImage imageNamed:selectedImg];
    self.delegate = delegate;
    [self view_setup];
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self view_setup];
}

- (void)view_setup {
    self.userInteractionEnabled = YES;
    [self initGradualImages];
    [self addGesture];
    self.duration = 0.5;
    self.clipsToBounds = YES;
}

- (void)addGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tap];
}

- (void)initGradualImages
{

    imgWidth = self.image.size.width;
    imgHeight = self.image.size.height;
    
    self.imgsArray = [NSArray arrayWithObjects:self.image,self.highlightedImage, nil];
    
    for (NSInteger i = 0; i < [_imgsArray count]; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imgWidth, imgHeight)];
        imgView.image = [_imgsArray objectAtIndex:i];
        imgView.tag = 100+i;
        imgView.clipsToBounds = YES;

        if (i == 1) {
            maskView = [[UIView alloc]initWithFrame:CGRectZero];
            maskView.backgroundColor = [UIColor clearColor];
            maskView.clipsToBounds = YES;
            [self addSubview:maskView];
            [maskView addSubview:imgView];
        }else {
            [self addSubview:imgView];
        }
        
    }

    if (self.gradualType == GradualViewHorizontal) {
        maskView.frame = CGRectMake(0, 0, self.selected ? imgWidth : 0 , imgHeight);
    }else {
        maskView.frame = CGRectMake(0, 0,  imgWidth , imgHeight);
        maskView.alpha = self.selected ? 1.0 : 0.0;
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, imgWidth, imgHeight);

}

- (void)tapView:(UITapGestureRecognizer *)gesture
{
    maskView.alpha = 1.0;

    if (self.gradualType == GradualViewHorizontal) {
        maskView.frame = CGRectMake(0, 0, self.selected ? imgWidth : 0 , imgHeight);
    }else {
        CGAffineTransform transformScale = self.selected ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.0001f, 0.0001f);
        maskView.transform = transformScale;
    }
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:1.0 animations:^{
        if (self.gradualType == GradualViewHorizontal) {
            maskView.frame = CGRectMake(0, 0, self.selected ? 0 : imgWidth, imgHeight);
        }else {
            maskView.transform = self.selected ? CGAffineTransformMakeScale(0.0001f, 0.0001f) : CGAffineTransformIdentity;
        }

    }completion:^(BOOL finished) {
        self.selected = !self.selected;
        [self shakeView:self];

        if ([self.delegate respondsToSelector:@selector(clickGradualView:selected:)])
        {
            [self.delegate clickGradualView:self selected:self.selected];
        }
        self.userInteractionEnabled = YES;
    }];
}

- (void)completelAction:(BOOL)action
{
    self.selected = action;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self initGradualImages];
}

- (void)shakeView:(UIView *)view {
    CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    shake.values = [NSArray arrayWithObjects:
                    [NSNumber numberWithFloat:0.8],
                    [NSNumber numberWithFloat:1.5],
                    [NSNumber numberWithFloat:0.9],
                    [NSNumber numberWithFloat:1.2],
                    [NSNumber numberWithFloat:1],
                    nil];
    
    shake.duration = self.duration;
    
    [view.layer addAnimation:shake forKey:@"viewShake"];
}

@end
