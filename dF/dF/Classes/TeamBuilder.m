//
//  TeamBuilder.m
//  dF
//
//  Created by Nick Esposito on 8/28/13.
//  Copyright (c) 2013 NickTitle. All rights reserved.
//

#import "TeamBuilder.h"
#import "Team.h"
#import "PreUnit.h"
#import "Constants.h"

@implementation TeamBuilder

+(void)makeTeamsFromQuestion:(NSString*)question {
    NSString *teamString = [self makeTeamStringFromRequest:question];
    NSLog(@"Original question:%@", question);
    NSLog(@"Teamstring:%@", teamString);
    
    [self createTeamsFromSource:teamString];
}

+(NSString *)makeTeamStringFromRequest:(NSString*)request {
    return [ShaMachine sha1RandSalt:request];
}

+(void)createTeamsFromSource:(NSString *)tS {
    NSString *teamAString = [tS substringToIndex:20];
    NSString *teamBString = [tS substringFromIndex:20];
    NSLog(@"\nTeam a:%@ \nTeam b:%@", teamAString, teamBString);
    
    Team *tA = [Team defineTeamWithTeamString:teamAString];
    Team *tB = [Team defineTeamWithTeamString:teamBString];

    [TeamBuilder describeTeam:tA name:@"The first team"];
    [TeamBuilder describeTeam:tB name:@"The other team"];
}

+(void)describeTeam:(Team *)t  name:(NSString *)teamName {
    NSString *healthS = (t.baseUnitHealth < baseHealth ? @"weaker" : @"tougher");
    NSString *speedS = (t.baseUnitSpeed < baseSpeed ? @"slower" : @"faster");
    NSString *powerS = (t.baseUnitPower < basePower ? @"less powerful" : @"more powerful");
    NSString *regenS = (t.baseUnitRegenRate < baseRegen ? @"more slowly" : @"more quickly");
    NSString *spawnS = (t.baseUnitSpawnRate < baseSpawn ? @"slower" : @"quicker");
    
    NSString *describeString = [NSString stringWithFormat:@"%@'s troops are generally %@, %@, and %@ than average. They regenerate %@ and spawn %@ than average.", teamName, healthS, speedS, powerS, regenS, spawnS];
    
    NSLog(@"%@",describeString);
    
    for (PreUnit *p in t.unitArray) {
        NSLog(@"There's a %@ on %@ who is particularly %@", p.unitType, teamName, p.unitQuality);
    }
}

@end
