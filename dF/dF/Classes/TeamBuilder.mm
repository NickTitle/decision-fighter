//
//  TeamBuilder.m
//  dF
//
//  Created by Nick Esposito on 8/28/13.
//  Copyright (c) 2013 NickTitle. All rights reserved.
//

#import "TeamBuilder.h"
#import "Team.h"
#import "Unit.h"
#import "Constants.h"

@implementation TeamBuilder

+(NSArray *)makeTeamsFromQuestion:(NSString*)question{
    NSString *teamString = [self makeTeamStringFromRequest:question];
    NSLog(@"Original question:%@", question);
    NSLog(@"Teamstring:%@", teamString);
    
    return [self createTeamsFromSource:teamString];
}

+(NSString *)makeTeamStringFromRequest:(NSString*)request {
    return [ShaMachine sha1DateSalt:request];
}

+(NSArray *)createTeamsFromSource:(NSString *)tS{
    NSString *teamAString = [tS substringToIndex:20];
    NSString *teamBString = [tS substringFromIndex:20];
    NSLog(@"\nTeam a:%@ \nTeam b:%@", teamAString, teamBString);
    
    Team *tA = [Team defineTeamWithTeamString:teamAString];
    tA.teamArrayIndex = 0;
    Team *tB = [Team defineTeamWithTeamString:teamBString];
    tB.teamArrayIndex = 1;

    [TeamBuilder describeTeam:tA name:@"The first team"];
    [TeamBuilder describeTeam:tB name:@"The other team"];
    
    return @[tA, tB];
}

+(void)describeTeam:(Team *)t  name:(NSString *)teamName {
    NSString *healthS = (t.teamHealth < baseHealth ? @"weaker" : @"tougher");
    NSString *speedS = (t.teamSpeed < baseSpeed ? @"slower" : @"faster");
    NSString *powerS = (t.teamPower < basePower ? @"less powerful" : @"more powerful");
    NSString *regenS = (t.teamRegenRate < baseRegen ? @"more slowly" : @"more quickly");
    NSString *spawnS = (t.teamSpawnRate < baseSpawn ? @"slower" : @"quicker");
    
    NSString *describeString = [NSString stringWithFormat:@"%@'s troops are generally %@, %@, and %@ than average. They regenerate %@ and spawn %@ than average.", teamName, healthS, speedS, powerS, regenS, spawnS];
    
    NSLog(@"%@",describeString);
    
    for (Unit *u in t.unitArray) {
        NSLog(@"There's a %@ on %@ who is particularly %@", [u unitTypeString], teamName, [u unitQualityString]);
    }

}

@end
