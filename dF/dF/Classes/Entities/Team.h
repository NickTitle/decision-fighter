//
//  Team.h
//  dF
//
//  Created by Nick Esposito on 8/28/13.
//  Copyright (c) 2013 NickTitle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject

@property (nonatomic, assign) float teamHealth;
@property (nonatomic, assign) float teamSpeed;
@property (nonatomic, assign) float teamPower;
@property (nonatomic, assign) float teamRegenRate;
@property (nonatomic, assign) float teamSpawnRate;
@property (nonatomic, retain) NSMutableArray *unitArray;

+(Team *)defineTeamWithTeamString:(NSString*)ts;


@end
