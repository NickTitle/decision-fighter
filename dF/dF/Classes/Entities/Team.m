//
//  Team.m
//  dF
//
//  Created by Nick Esposito on 8/28/13.
//  Copyright (c) 2013 NickTitle. All rights reserved.
//

#import "Team.h"
#import "Constants.h"

@implementation Team

@synthesize unitHealth;
@synthesize unitSpeed;
@synthesize unitPower;
@synthesize unitRegenRate;
@synthesize unitSpawnRate;

+(Team *)defineTeamWithTeamString:(NSString *)tS {
    Team *t = [Team teamWithHealth:baseHealth speed:baseSpeed power:basePower regenRate:baseRegen spawnRate:baseSpawn];
    for (int i=0; i< [tS length]; i++) {
        [t modTeam:t withVal:[self valForHexStringChar:[tS characterAtIndex:i]] atPosition:i];
    }
    return t;
};

+(Team *)teamWithHealth:(float)health speed:(float)speed power:(float)power regenRate:(float)regenRate spawnRate:(float)spawnRate {
    
    Team *t = [[Team alloc] init];
    t.unitHealth = health;
    t.unitSpeed = speed;
    t.unitPower = power;
    t.unitRegenRate = regenRate;
    t.unitSpawnRate = spawnRate;
    return t;
}

-(void)modTeam:(Team *)t withVal:(int)v atPosition:(int)p {
    //create uniform distribution from -8 to 8
    v -= 8;
    switch (p) {
        case 0:
            t.unitHealth += baseHealth/4*(v/8.);
            break;
        case 1:
            t.unitSpeed += baseSpeed/4*(v/8.);
            break;
        case 2:
            t.unitPower += basePower/10*(v/8.);
            break;
        case 3:
            t.unitRegenRate += baseRegen/4*(v/8.);
            break;
        case 4:
            t.unitSpawnRate += baseSpawn/10*(v/8.);
            break;
        default:
//            NSLog(@"No properties set for this yet");
            break;
    }
}

+(int)valForHexStringChar:(char)c {
    char tempChar[2];
    tempChar[0] = c;
    tempChar[1] = 0;
    return strtol(tempChar, NULL, 16);
}

@end