//
//  StartMenu.m
//  johnnychen
//
//  Created by Johnny Chen on 8/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StartMenu.h"

@implementation StartMenu

//startGame is the method that gets called when button is pressed
- (void)startGame{
    CCScene *gameplay = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:gameplay withTransition:transition];
}

@end
