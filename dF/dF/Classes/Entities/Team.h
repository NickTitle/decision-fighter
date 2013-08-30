//
//  Team.h
//  dF
//
//  Created by Nick Esposito on 8/28/13.
//  Copyright (c) 2013 NickTitle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject

@property (nonatomic, assign) float baseUnitHealth;
@property (nonatomic, assign) float baseUnitSpeed;
@property (nonatomic, assign) float baseUnitPower;
@property (nonatomic, assign) float baseUnitRegenRate;
@property (nonatomic, assign) float baseUnitSpawnRate;
@property (nonatomic, retain) NSMutableArray *unitArray;

+(Team *)defineTeamWithTeamString:(NSString*)ts;


@end
