//
//  RSGradualView.h
//  buttonDemo
//
//  Created by RedScor Yuan on 2015/2/14.
//  Copyright (c) 2015年 RedScor Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSGradualView;
@protocol RSGradualViewDelegate <NSObject>

- (void)clickGradualView:(RSGradualView *)gradualView selected:(BOOL)selected;

@end

@interface RSGradualView : UIImageView
@property (nonatomic, weak) IBOutlet id<RSGradualViewDelegate>delegate;
@property (nonatomic, assign) BOOL selected;


- (instancetype)initWithFrame:(CGRect)frame
                    normalImg:(NSString *)normalImg
                  selectedImg:(NSString *)selectedImg
                     delegate:(id<RSGradualViewDelegate>)delegate;

- (void)completelAction:(BOOL)action;

@end
