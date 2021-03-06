//
//  Anemone.m
//  ProtoMesh2
//
//  Created by Efflam on 24/05/11.
//  Copyright 2011 Plouf. All rights reserved.
//

#import "Anemone.h"
#import "globals.h"
#import "SimpleAudioEngine.h"

@implementation Anemone

@synthesize body;
@synthesize bodyDef;
@synthesize shapeDef;
@synthesize fixtureDef;
@synthesize sprite;
@synthesize eaten;

-(void)dealloc
{
    delete shapeDef;
    delete bodyDef;
    delete fixtureDef;
    [sprite release];
    [super dealloc];
}

+(id)anemoneAtPosition:(CGPoint)aPosition andRotation:(float)aRotation
{
    return [[[Anemone alloc] initAtPosition:aPosition andRotation:aRotation] autorelease];
}

- (id)initAtPosition:(CGPoint)aPosition andRotation:(float)aRotation
{
	self = [super init];
    if(self)
    {
		[self setBodyDef:new b2BodyDef];
        [self bodyDef]->type = b2_staticBody;
		[self setShapeDef:new b2PolygonShape];
        float offsetX =  sinf(aRotation-M_PI) * 90.0f;
        float offsetY =  - cosf(aRotation-M_PI) * 90.0f;
        self.bodyDef->position.Set(SCREEN_TO_WORLD(aPosition.x +offsetX) , SCREEN_TO_WORLD(aPosition.y + offsetY));
        self.bodyDef->angle = aRotation;
               // boxDef.filter.categoryBits=2;
        self.shapeDef->SetAsBox(SCREEN_TO_WORLD(20.0f), SCREEN_TO_WORLD(90.0f));
        [self setFixtureDef:new b2FixtureDef];
        

        eaten = NO;
	}
	return self;
}


- (void)actorDidAppear 
{	
	[super actorDidAppear];
	[self bodyDef]->userData =  self;
	[self setBody:[self world]->CreateBody([self bodyDef])];
	[self fixtureDef]->shape = [self shapeDef];
    //self.fixtureDef->filter.categoryBits = 0x0002;
    self.fixtureDef->filter.maskBits = 0x0004;
    [self body]->CreateFixture([self fixtureDef]);
    self.sprite = [AnemoneAnimated node];
    [self.sprite setPosition:ccp(WORLD_TO_SCREEN(self.body->GetPosition().x),WORLD_TO_SCREEN(self.body->GetPosition().y ))];
    float angleInDeg = -1 * CC_RADIANS_TO_DEGREES(self.body->GetAngle());
    [[self sprite] setRotation: angleInDeg];
	[[self scene] addChild:[self sprite]];
	
}


- (void)actorWillDisappear 
{
    [super actorWillDisappear];
//	[self body]->SetUserData(nil);
	if(self.body) [self world]->DestroyBody([self body]);
	[self setBody:nil];
	[[self scene] removeChild:[self sprite] cleanup:NO];
    [self setSprite:nil];
	
}

-(void)ate
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"miam.caf"];
    [self.sprite ate];
    eaten = YES;
}



- (void)worldDidStep 
{
	[super worldDidStep];
    if(eaten && self.body)
    {
        self.world->DestroyBody(self.body);
        self.body = nil;
    }
}
@end
