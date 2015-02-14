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
    [self initGradualImages];
    [self addGesture];
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    [self initGradualImages];
    [self addGesture];
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
            maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 22)];
            maskView.backgroundColor = [UIColor clearColor];
            maskView.clipsToBounds = YES;
            [self addSubview:maskView];
            [maskView addSubview:imgView];
        }else {
            [self addSubview:imgView];
        }
        
    }

    maskView.frame = CGRectMake(0, 0, self.selected ? imgWidth : 0 , imgHeight);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, imgWidth, imgHeight);

}

- (void)tapView:(UITapGestureRecognizer *)gesture
{

    maskView.frame = CGRectMake(0, 0, self.selected ? imgWidth : 0, imgHeight);

    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:1.0 animations:^{
        maskView.frame = CGRectMake(0, 0, self.selected ? 0 : imgWidth, imgHeight);

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
    
    shake.duration = 0.5;
    
    [view.layer addAnimation:shake forKey:@"viewShake"];
}

@end