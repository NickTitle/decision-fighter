//
//  Team.h
//  dF
//
//  Created by Nick Esposito on 8/28/13.
//  Copyright (c) 2013 NickTitle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface Team : NSObject

@property (nonatomic, assign) float teamHealth;
@property (nonatomic, assign) float teamSpeed;
@property (nonatomic, assign) float teamPower;
@property (nonatomic, assign) float teamRegenRate;
@property (nonatomic, assign) float teamSpawnRate;
@property (nonatomic, retain) NSMutableArray *unitArray;
@property (nonatomic, assign) b2World *world;

+(Team *)defineTeamWithTeamString:(NSString*)ts inWorld:(b2World *)w;


@end
