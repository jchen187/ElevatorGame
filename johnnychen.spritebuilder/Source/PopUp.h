//
//  PopUp.h
//  johnnychen
//
//  Created by Johnny Chen on 7/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

//PlayerAction is what all the enums start with
typedef NS_ENUM(NSInteger, PlayerAction) {
    PlayerActionRandom,
    PlayerActionSwipeRight,
    PlayerActionSwipeLeft,
    PlayerActionDoubleTap,
    PlayerActionTouchButton
};

@class MainScene;

@interface PopUp : CCNode

//- (void)swipeRight;
@property (nonatomic, weak) MainScene *main;

//@property (nonatomic, assign) int tutNum;

-(void)showPopUp:(int)number;

@end
