//
//  Team.m
//  dF
//
//  Created by Nick Esposito on 8/28/13.
//  Copyright (c) 2013 NickTitle. All rights reserved.
//

#import "Team.h"
#import "Unit.h"
#import "Constants.h"

@implementation Team

@synthesize teamHealth;
@synthesize teamSpeed;
@synthesize teamPower;
@synthesize teamRegenRate;
@synthesize teamSpawnRate;

@synthesize unitArray;

+(Team *)defineTeamWithTeamString:(NSString *)tS {
    Team *t = [Team teamWithHealth:baseHealth speed:baseSpeed power:basePower regenRate:baseRegen spawnRate:baseSpawn];
    for (int i=0; i< [tS length]; i++) {
        [t modTeam:t withVal:[self valForHexStringChar:[tS characterAtIndex:i]] atPosition:i];
    }
    return t;
};

+(Team *)teamWithHealth:(float)health speed:(float)speed power:(float)power regenRate:(float)regenRate spawnRate:(float)spawnRate {
    
    Team *t = [[Team alloc] init];
    t.unitArray = [NSMutableArray new];
    t.teamHealth = health;
    t.teamSpeed = speed;
    t.teamPower = power;
    t.teamRegenRate = regenRate;
    t.teamSpawnRate = spawnRate;
    
    return t;
    
}

-(void)modTeam:(Team *)t withVal:(int)v atPosition:(int)p {
    //create uniform distribution from -8 to 8
    int vNorm = v-8;
    switch (p) {
        case 0:
            t.teamHealth += baseHealth/4*(vNorm/8.);
            break;
        case 1:
            t.teamSpeed += baseSpeed/4*(vNorm/8.);
            break;
        case 2:
            t.teamPower += basePower/10*(vNorm/8.);
            break;
        case 3:
            t.teamRegenRate += baseRegen/4*(vNorm/8.);
            break;
        case 4:
            t.teamSpawnRate += baseSpawn/10*(vNorm/8.);
            break;
        case 15:
            
            break;
        case 16:
            
            break;
        case 17:
            
            break;
        case 18:
            
            break;
        case 19:
            
            break;
        default:
            [t.unitArray addObject:[self createUnitFromVal:v]];
            break;
    }
}

-(Unit *)createUnitFromVal:(int)v {
    Unit *u = [Unit unitWithType:v/4 andQuality:v%4 ForTeam:self];
    return u;
}

+(int)valForHexStringChar:(char)c {
    char tempChar[2];
    tempChar[0] = c;
    tempChar[1] = 0;
    return strtol(tempChar, NULL, 16);
}

@end