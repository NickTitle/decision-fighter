//
//  BaseUnit.m
//  dF
//
//  Created by Nick Esposito on 9/2/13.
//  Copyright (c) 2013 NickTitle. All rights reserved.
//

#import "Unit.h"
#import "Team.h"

@implementation Unit

@synthesize unitType, unitQuality;
@synthesize unitSpeed, unitHealth, unitPower, unitRegen;

+(Unit *)unitWithType:(int)typeVal andQuality:(int)qualVal ForTeam:(Team *)team {
    Unit *u = [Unit new];
    u.unitType = typeVal;
    u.unitQuality = qualVal;
    u.unitSpeed = baseSpeed * (team.teamSpeed/baseSpeed);
    u.unitHealth = baseHealth * (team.teamHealth/baseHealth);
    u.unitPower = basePower * (team.teamPower/basePower);
    u.unitRegen = baseRegen * (team.teamRegenRate/baseRegen);
    
    u = [Unit modUnit:u forType:typeVal andQuality:qualVal];
    
    return u;
}

+(Unit*)modUnit:(Unit *)unit forType:(int)typeVal andQuality:(int)qualVal {
    
    // mods based on type
    switch (typeVal) {
        case uTRunner:
            unit.unitSpeed *= 1.4;
            unit.unitHealth *= .8;
            unit.unitPower *= .8;
            break;
        case uTSoldier:
            unit.unitPower *= 1.2;
            unit.unitRegen *= .8;
            break;
        case uTHeavy:
            unit.unitSpeed *= .7;
            unit.unitHealth *= 1.3;
            unit.unitPower *= 1.3;
            unit.unitRegen *= .7;
            break;
        case uTMedic:
            unit.unitHealth *= 1.2;
            unit.unitRegen *= 1.2;
            unit.unitPower *= .6;
            break;
    }
    
    //Do mods based on unique characteristic
    switch (qualVal) {
        case qualFast:
            unit.unitSpeed *= 1.2;
            break;
        case qualTough:
            unit.unitHealth *= 1.2;
            break;
        case qualStrong:
            unit.unitPower *= 1.2;
            break;
        case qualHealthy:
            unit.unitRegen *= 1.2;
            break;
    }
    
    return unit;
}

-(NSString *)unitTypeString {
    NSString *ret;
    switch (self.unitType) {
        case uTRunner:
            ret = @"Runner";
            break;
        case uTSoldier:
            ret = @"Soldier";
            break;
        case uTHeavy:
            ret = @"Heavy";
            break;
        case uTMedic:
            ret = @"Medic";
            break;
    }
    return ret;
}

-(NSString *)unitQualityString {
    NSString *ret;
    switch (self.unitQuality) {
        case qualFast:
            ret = @"fast (high speed)";
            break;
        case qualTough:
            ret = @"tough (high health)";
            break;
        case qualStrong:
            ret = @"strong (high power)";
            break;
        case qualHealthy:
            ret = @"healthy (quick regen)";
            break;
    }
    return ret;
}

@end