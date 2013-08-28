//
//  Team.h
//  dF
//
//  Created by Nick Esposito on 8/28/13.
//  Copyright (c) 2013 NickTitle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject

@property (nonatomic, assign) float unitHealth;
@property (nonatomic, assign) float unitSpeed;
@property (nonatomic, assign) float unitPower;
@property (nonatomic, assign) float unitRegenRate;
@property (nonatomic, assign) float unitSpawnRate;

+(Team *)defineTeamWithTeamString:(NSString*)ts;


@end
