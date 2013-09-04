//
//  TeamBuilder.h
//  dF
//
//  Created by Nick Esposito on 8/28/13.
//  Copyright (c) 2013 NickTitle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShaMachine.h"
#import "b2World.h"

@interface TeamBuilder : NSObject

+(NSArray *)makeTeamsFromQuestion:(NSString*)question inWorld:(b2World *)world;

@end
