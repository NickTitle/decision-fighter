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
@property (nonatomic, assign) float unitHealth;
@property (nonatomic, assign) float unitPower;
@property (nonatomic, assign) float unitRegen;

@property (nonatomic, retain) CCLabelTTF *descLabel;

enum unitType {
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

+(Unit *)unitWithType:(int)typeVal andQuality:(int)qualVal ForTeam:(Team *)team;
-(void)placeUnitInWorldAtPoint:(CGPoint)p inWorld:(b2World *)w;

-(NSString *)unitTypeString;
-(NSString *)unitQualityString;

@end
