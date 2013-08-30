//
//  Team.m
//  dF
//
//  Created by Nick Esposito on 8/28/13.
//  Copyright (c) 2013 NickTitle. All rights reserved.
//

#import "Team.h"
#import "PreUnit.h"
#import "Constants.h"

@implementation Team

@synthesize baseUnitHealth;
@synthesize baseUnitSpeed;
@synthesize baseUnitPower;
@synthesize baseUnitRegenRate;
@synthesize baseUnitSpawnRate;

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
    t.baseUnitHealth = health;
    t.baseUnitSpeed = speed;
    t.baseUnitPower = power;
    t.baseUnitRegenRate = regenRate;
    t.baseUnitSpawnRate = spawnRate;
    return t;
}

-(void)modTeam:(Team *)t withVal:(int)v atPosition:(int)p {
    //create uniform distribution from -8 to 8
    int vNorm = v-8;
    switch (p) {
        case 0:
            t.baseUnitHealth += baseHealth/4*(vNorm/8.);
            break;
        case 1:
            t.baseUnitSpeed += baseSpeed/4*(vNorm/8.);
            break;
        case 2:
            t.baseUnitPower += basePower/10*(vNorm/8.);
            break;
        case 3:
            t.baseUnitRegenRate += baseRegen/4*(vNorm/8.);
            break;
        case 4:
            t.baseUnitSpawnRate += baseSpawn/10*(vNorm/8.);
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

-(PreUnit*)createUnitFromVal:(int)v {
    PreUnit *p = [PreUnit new];
    NSString *tS; //typestring
    NSString *qS; //qualitystring
    
    switch (v/4) {
        case 0:
            tS = @"runner";
            break;
        case 1:
            tS = @"soldier";
            break;
        case 2:
            tS = @"heavy";
            break;
        case 3:
            tS = @"medic";
            break;
    }
    
    switch (v%4) {
        case 0:
            qS = @"fast";
            break;
        case 1:
            qS = @"tough";
            break;
        case 2:
            qS = @"strong";
            break;
        case 3:
            qS = @"spirited";
            break;
    }
    
    p.unitType = tS;
    p.unitQuality = qS;
    
    return p;
}

+(int)valForHexStringChar:(char)c {
    char tempChar[2];
    tempChar[0] = c;
    tempChar[1] = 0;
    return strtol(tempChar, NULL, 16);
}

@end