//
//  CoinView.m
//  DecisionMaking
//
//  Created by rimi on 15/9/29.
//  Copyright © 2015年 HugheX. All rights reserved.
//

#import "CoinView.h"

@implementation CoinView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"1dollar_01"];
        self.contentMode = UIViewContentModeScaleToFill;
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)beginAnimate{
    
}

@end
