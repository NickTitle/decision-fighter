//
//  TeamBuilder.m
//  dF
//
//  Created by Nick Esposito on 8/28/13.
//  Copyright (c) 2013 NickTitle. All rights reserved.
//

#import "TeamBuilder.h"
#import "Team.h"

@implementation TeamBuilder

+(void)makeTeamsFromQuestion:(NSString*)question {
    NSString *teamString = [self makeTeamStringFromRequest:question];
    NSLog(@"Teamstring:%@", teamString);
    
    [self describeTeamFromString:teamString];
}

+(NSString *)makeTeamStringFromRequest:(NSString*)request {
    return [ShaMachine sha1RandSalt:request];
}

+(void)describeTeamFromString:(NSString *)tS {
    NSString *teamAString = [tS substringToIndex:20];
    NSString *teamBString = [tS substringFromIndex:20];
    NSLog(@"\nTeam a:%@ \nTeam b:%@", teamAString, teamBString);
    
    Team *tA = [Team defineTeamWithTeamString:teamAString];
    Team *tB = [Team defineTeamWithTeamString:teamBString];

    NSLog(@"\nTeam A\nhealth:%f\nspeed:%f\npower:%f\nregen:%f\nspawnTime:%f", tA.unitHealth, tA.unitSpeed, tA.unitPower, tA.unitRegenRate, tA.unitSpawnRate);
    NSLog(@"\nTeam B\nhealth:%f\nspeed:%f\npower:%f\nregen:%f\nspawnTime:%f", tB.unitHealth, tB.unitSpeed, tB.unitPower, tB.unitRegenRate, tB.unitSpawnRate);
}

@end
