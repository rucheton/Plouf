//
//  PauseMenu.m
//  ProtoMesh2
//
//  Created by Clément RUCHETON on 28/05/11.
//  Copyright 2011 Plouf. All rights reserved.
//

#import "PauseMenu.h"


@implementation PauseMenu
@synthesize soundButton,menu,soundOn;

-(void)dealloc
{
    [soundButton release];
    [menu release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        
        [self setAnchorPoint:ccp(0,0)];
        
        self.soundOn = YES;
        
        CCSpriteFrameCache *frames = [CCSpriteFrameCache sharedSpriteFrameCache];
                
        CCSprite *background = [CCSprite spriteWithSpriteFrame:[frames spriteFrameByName:@"backgroundMenu.png"]];
        [background setOpacity:.7];
        
        CCSprite *niveau        = [CCSprite spriteWithSpriteFrame:[frames spriteFrameByName:@"levelButton.png"]];
        CCSprite *recommencer   = [CCSprite spriteWithSpriteFrame:[frames spriteFrameByName:@"restartButton.png"]];
        CCSprite *son           = [CCSprite spriteWithSpriteFrame:[frames spriteFrameByName:@"soundOnButton.png"]];
        CCSprite *continuer     = [CCSprite spriteWithSpriteFrame:[frames spriteFrameByName:@"continueButton.png"]];
        
        CCMenuItemImage *levelButton = [CCMenuItemImage itemFromNormalSprite:niveau 
                                                              selectedSprite:nil 
                                                                     target:self 
                                                                   selector:@selector(levelButtonHandler)];
        
        CCMenuItemImage *restartButton = [CCMenuItemImage itemFromNormalSprite:recommencer 
                                                              selectedSprite:nil 
                                                                     target:self 
                                                                   selector:@selector(restartHandler)];
        
        self.soundButton = [CCMenuItemImage itemFromNormalSprite:son 
                                                  selectedSprite:nil 
                                                          target:self 
                                                        selector:@selector(soundHandler)];
        
        CCMenuItemImage *continueButton = [CCMenuItemImage itemFromNormalSprite:continuer 
                                                              selectedSprite:nil 
                                                                     target:self 
                                                                   selector:@selector(continueHandler)];
        
        self.menu = [CCMenu menuWithItems:levelButton,restartButton,soundButton,continueButton, nil];
        [menu alignItemsHorizontally];
        [menu setIsTouchEnabled:NO];
        
        [self addChild:background];
        [self addChild:menu];
    }
    return self;
}

-(void)levelButtonHandler
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"levelButtonTouched" object:self userInfo:nil];
}

-(void)restartHandler
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"restartButtonTouched" object:self userInfo:nil];
}

-(void)pause:(BOOL)p
{
    if(p)
    {
        [self runAction:[CCFadeIn actionWithDuration:.5]];
        [menu setIsTouchEnabled:YES];
    }
    else
    {
        [self runAction:[CCFadeOut actionWithDuration:.5]];
        [menu setIsTouchEnabled:NO];
    }
}

-(void)soundHandler
{
    CCSpriteFrameCache *frames = [CCSpriteFrameCache sharedSpriteFrameCache];
    if(soundOn)
    {
        [soundButton setNormalImage:[CCSprite spriteWithSpriteFrame:[frames spriteFrameByName:@"soundOffButton.png"]]];
        self.soundOn = NO;
    }
    else
    {
        [soundButton setNormalImage:[CCSprite spriteWithSpriteFrame:[frames spriteFrameByName:@"soundOnButton.png"]]];
        self.soundOn = YES;
    }
}

-(void)continueHandler
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"continueButtonTouched" object:self userInfo:nil];
}

@end