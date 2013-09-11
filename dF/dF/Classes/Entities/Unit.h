//
//  BaseUnit.h
//  dF
//
//  Created by Nick Esposito on 9/2/13.
//  Copyright (c) 2013 NickTitle. All rights reserved.
//

#import "CCPhysicsSprite.h"
#import "Box2D.h"
#import "cocos2d.h"
#import "Constants.h"

@class Team;

@interface Unit : CCPhysicsSprite

@property(nonatomic, assign) int unitType;
@property(nonatomic, assign) int unitQuality;

@property (nonatomic, assign) float unitSpeed;
@property (nonatomic, assign) float unitMaxHealth;
@property (nonatomic, assign) float unitHealth;
@property (nonatomic, assign) float unitPower;
@property (nonatomic, assign) float unitRegen;
@property (nonatomic, assign) Team *unitTeam;

@property (nonatomic, assign) int unitState;
@property (nonatomic, assign) b2Vec2 targetVel;
@property (nonatomic, assign) CGPoint targetPoint;
@property (nonatomic, assign) int targetCountdown;
@property (nonatomic, assign) Unit *targetUnit;

@property (nonatomic, retain) CCLabelTTF *descLabel;

enum unitType {
    uTNoType = -1,
    uTRunner = 0,
    uTSoldier,
    uTHeavy,
    uTMedic
};

enum unitQuality {
    qualFast = 0,
    qualTough,
    qualStrong,
    qualHealthy
};

enum unitState {
    uSSearching = 0,
    uSAttacking = 1,
    uSRunning = 2,
    uSAssisting = 3
};

+(Unit *)unitWithType:(int)typeVal andQuality:(int)qualVal ForTeam:(Team *)team;
-(void)placeUnitInWorldAtPoint:(CGPoint)p inWorld:(b2World *)w;

-(NSString *)unitTypeString;
-(NSString *)unitQualityString;

@end
