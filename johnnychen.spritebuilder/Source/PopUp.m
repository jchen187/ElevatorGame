//
//  PopUp.m
//  johnnychen
//
//  Created by Johnny Chen on 7/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PopUp.h"
#import "MainScene.h"

@implementation PopUp{
    CCLabelTTF *_label;
    UISwipeGestureRecognizer *swipeRight;
    NSDictionary *plistContent;
}

- (void)didLoadFromCCB{
//    swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
//    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
//    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeRight];
//
    NSURL *file = [[NSBundle mainBundle] URLForResource:@"Tutorial Stuff" withExtension:@"plist"];
    plistContent = [NSDictionary dictionaryWithContentsOfURL:file];
    [self showPopUp:PlayerActionSwipeLeft];
}

- (void)showPopUp:(int)number{
//    NSString *tag = [plistContent objectForKey:@"3"];
    
    _label.string = [self showTextFromPlayerAction:number];

    
}

- (NSString *)showTextFromPlayerAction:(PlayerAction)playerAction {
    switch (playerAction) {
        case 0:
            
        case 1:
            return @"Swipe Right Now!!";
            break;
            
        case 2:
            return @"Swipe Left Now!!";
            break;
            
        case 3:
            //return @"When in Doubt, Just Double Tap";
            return @"When Bar is Full, Just Teleport";
            break;
            
        case 4:
            return @"Hit Elevator Button";
            
        default:
            break;
    }
    return @"";
}
//- (void)swipeRight{
//    NSLog(@"you swiped right");
//    //i did this in the mainscene but it doesnt work in mainscene
//    self.main.paused = FALSE;
//    [self removeFromParent];
//    
//    [[[CCDirector sharedDirector] view] removeGestureRecognizer:swipeRight];
//    //you need to remove gesture recognizer or it will recognize that you swipe right
//}

@end
