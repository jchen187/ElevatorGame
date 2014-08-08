//
//  ProgressBar.m
//  johnnychen
//
//  Created by Johnny Chen on 8/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ProgressBar.h"
//#define SW ([[UIScreen mainScreen] bounds].size.width)
//#define SH ([[UIScreen mainScreen] bounds].size.height)
#define SW ([[CCDirector sharedDirector] viewSize].width)
#define SH ([[CCDirector sharedDirector] viewSize].height)

@implementation ProgressBar {
    CCSprite *_tBar;
    CCSprite *_bBar;
}


- (instancetype)initWithString:(NSString *)string {
    if (self) {
        self = (ProgressBar *)[CCBReader load:@"ProgressBar"];
        self.isFull = FALSE;
    }
    return self;
}


- (void)didLoadFromCCB {
    self.position = ccp(30,SH - 80);
    _tBar.scaleX = 0;
}

- (void)reset{
    _tBar.scaleX = 0;
    self.isFull = FALSE;
    self.didStartAnimation = FALSE;
    [[self animationManager] runAnimationsForSequenceNamed:@"Default"];
}

-(void)increase {
    if(_tBar.scaleX >= 0.5){
        self.isFull = TRUE;
    }
    else {
        _tBar.scaleX += 0.002;
        self.isFull = FALSE;
    }
}

- (void)blinkWhenFull{
    if (self.isFull == TRUE){
        if (self.didStartAnimation == FALSE){
            self.didStartAnimation = TRUE;
            [[self animationManager] runAnimationsForSequenceNamed:@"Full"];
        }
    }
}

@end
