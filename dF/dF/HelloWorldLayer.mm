//
//  HelloWorldLayer.mm
//  dF
//
//  Created by Nick Esposito on 8/27/13.
//  Copyright NickTitle 2013. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"

// Not included in "cocos2d.h"
#import "CCPhysicsSprite.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "TeamBuilder.h"
#import "Team.h"
#import "Unit.h"
#import "SimpleContactListener.h"

enum {
	kTagParentNode = 1,
};


#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()
-(void) initPhysics;
-(void) addNewSpriteAtPosition:(CGPoint)p;
-(void) createMenu;
@end

@implementation HelloWorldLayer

@synthesize teamsArray;

NSMutableArray *allUnitsArray;
NSMutableArray *targetsArray;
SimpleContactListener *_contactListener;

CGSize wSize;
BOOL skip = 0;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
		
		self.touchEnabled = YES;
		self.accelerometerEnabled = YES;
		wSize = [[CCDirector sharedDirector] winSize];
		// init physics
		[self initPhysics];
		
		[self scheduleUpdate];
	}
    
    self.teamsArray = [TeamBuilder makeTeamsFromQuestion:@"Am I wearing blue underwear"];
    allUnitsArray = [NSMutableArray new];
    targetsArray = [NSMutableArray new];
    [self placeTeams];
	return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		location = [[CCDirector sharedDirector] convertToGL: location];
	}
}

-(void)placeTeams {
    for (int i=0; i<teamsArray.count; i++) {
        Team *tIQ = teamsArray[i];
        for (Unit *u in tIQ.unitArray) {
            int widthMod = (i ==0) ? 0 : 3*wSize.width/4;
            [u placeUnitInWorldAtPoint:ccp(arc4random_uniform(wSize.width/4)+widthMod,arc4random_uniform(wSize.height)) inWorld:world];
            u.b2Body->SetLinearVelocity(b2Vec2(arc4random_uniform(100)-50, arc4random_uniform(100)-50));
            [self addChild:u];
            [allUnitsArray addObject:u];
            u.descLabel.string = [NSString stringWithFormat:@"%@%i",u.descLabel.string, [teamsArray indexOfObject:tIQ]];
        }
    }
}

-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	[super dealloc];
}	

-(void) createMenu {
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
	
	// Reset Button
	CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
		[[CCDirector sharedDirector] replaceScene: [HelloWorldLayer scene]];
	}];

	// to avoid a retain-cycle with the menuitem and blocks
	__block id copy_self = self;

	// Achievement Menu Item using blocks
	CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
		
		
		GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
		achivementViewController.achievementDelegate = copy_self;
		
		AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
		
		[[app navController] presentModalViewController:achivementViewController animated:YES];
		
		[achivementViewController release];
	}];
	
	// Leaderboard Menu Item using blocks
	CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
		
		
		GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
		leaderboardViewController.leaderboardDelegate = copy_self;
		
		AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
		
		[[app navController] presentModalViewController:leaderboardViewController animated:YES];
		
		[leaderboardViewController release];
	}];
	
	CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, reset, nil];
	
	[menu alignItemsVertically];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, size.height/2)];
	
	
	[self addChild: menu z:-1];	
}

-(void) initPhysics {
	
	b2Vec2 gravity;
//	gravity.Set(0.0f, -10.0f);
    gravity.Set(0.0f, 0.0f);
	world = new b2World(gravity);
    _contactListener = new SimpleContactListener(self);
    world->SetContactListener(_contactListener);
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);		
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;		
	
	// bottom
	
	groundBox.Set(b2Vec2(0,0), b2Vec2(wSize.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,wSize.height/PTM_RATIO), b2Vec2(wSize.width/PTM_RATIO,wSize.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,wSize.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(wSize.width/PTM_RATIO,wSize.height/PTM_RATIO), b2Vec2(wSize.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
}

-(void) draw {
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();	
	
	kmGLPopMatrix();
}

-(void) addNewSpriteAtPosition:(CGPoint)p {
	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);
	

	CCNode *parent = [self getChildByTag:kTagParentNode];
	
	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
	//just randomly picking one of the images
	int idx = (CCRANDOM_0_1() > .5 ? 0:1);
	int idy = (CCRANDOM_0_1() > .5 ? 0:1);
	CCPhysicsSprite *sprite = [CCPhysicsSprite spriteWithTexture:spriteTexture_ rect:CGRectMake(32 * idx,32 * idy,32,32)];
	[parent addChild:sprite];
	
	[sprite setPTMRatio:PTM_RATIO];
	[sprite setB2Body:body];
	[sprite setPosition: ccp( p.x, p.y)];

}

-(void) update: (ccTime) dt {
	//http://gafferongames.com/game-physics/fix-your-timestep/

    int32 velocityIterations = 8;
	int32 positionIterations = 3;
    
    float maximumStep = 0.08;
    float progress = 0.0;
    while (progress < dt)
    {
        float step = min((dt-progress), maximumStep);
        world->Step(dt, velocityIterations, positionIterations);
        progress += step;
    }
    
    [self updateSoldiers];
	world->Step(dt, velocityIterations, positionIterations);	
}

-(void)updateSoldiers {
    skip = !skip;
    if (skip)
        return;
    for (Team *t in teamsArray) {
        for (Unit *u in t.unitArray) {
            [self stepUnit:u];
        }
    }
}

-(void)stepUnit:(Unit *)u {
    if (u.targetCountdown <= 0) {
        [self setStateForUnit:u];
        u.targetCountdown = arc4random_uniform(100)+50;
        return;
    }
    u.targetCountdown -= 1;
    
    b2Vec2 uVec = u.b2Body->GetLinearVelocity();
    b2Vec2 tV = b2Vec2(0.,0.);
    
    float targetAngle = [self pointPairToBearingDegreesStart:u.position end:u.targetPoint];
    float dist = ccpDistance(u.position, u.targetPoint);
    if (dist > u.scale*PTM_RATIO) {
        tV.x = cos(targetAngle)*u.unitSpeed;
        tV.y = sin(targetAngle)*u.unitSpeed;
    }
    else {
        u.b2Body->SetLinearVelocity(tV);
        u.b2Body->SetAngularVelocity(0.f);
        return;
    }

    
    NSDictionary *neighborsAndInvaders = [self getNeighborsAndSpaceInvadersForUnit:u];
    
    CGPoint invaderCOM = [self centerOfMassForArrayOfUnits:neighborsAndInvaders[@"spaceInvaders"]];
    
    float runAngle = [self pointPairToBearingDegreesStart:u.position end:invaderCOM];
    
    b2Vec2 runVec = b2Vec2(u.unitSpeed/2.*cosf(runAngle), u.unitSpeed/2.*sinf(runAngle));
    
    tV.x = (tV.x  - runVec.x);
    tV.y = (tV.y  - runVec.y);
    u.targetVel = tV;
    uVec.x = (uVec.x + u.targetVel.x)/2;
    uVec.y = (uVec.y + u.targetVel.y)/2;
    
    u.b2Body->SetLinearVelocity(uVec);
    if (uVec.x != 0 || uVec.y != 0) {
        u.b2Body->SetTransform(u.b2Body->GetPosition(), [self pointPairToBearingDegreesStart:ccp(0,0) end:ccp(tV.x, tV.y)]);
    }
    
}

-(void)setStateForUnit:(Unit *)u {
    if(u.unitHealth < u.unitMaxHealth/2) {
        u.unitState = uSRunning;
        return;
    }
    if (u.unitState == uSAttacking) {
        [targetsArray removeObject:u.targetUnit];
        u.unitState = uSSearching;
    }
    if (u.unitState == uSSearching) {
    }
    [self getTargetForUnit:u];
}

-(CGPoint)getTargetForUnit:(Unit *)u {
    Unit *target = nil;
    switch (u.unitType) {
        case uTRunner:
            target = [self nearestUnitOfType:uTHeavy toUnit:u sameTeam:FALSE];
            break;
        case uTSoldier:
            target = [self nearestUnitOfType:uTSoldier toUnit:u sameTeam:FALSE];
            break;
        case uTHeavy:
            target = [self nearestUnitOfType:uTNoType toUnit:u sameTeam:FALSE];
            break;
        case uTMedic:
            target = [self nearestUnitOfType:uTNoType toUnit:u sameTeam:TRUE];
            break;
    }
    
    if (target) {
        u.targetUnit = target;
        u.targetPoint = target.position;
        [targetsArray addObject:target];
        u.unitState = uSAttacking;
    }
    else {
        u.targetPoint = ccp(arc4random_uniform(wSize.width), arc4random_uniform(wSize.height));
    }

    return u.targetPoint;
}

-(void)oldStepUnit:(Unit *)u {
    Unit *target = nil;
    switch (u.unitType) {
        case uTRunner:
            target = [self nearestUnitOfType:uTHeavy toUnit:u sameTeam:FALSE];
            break;
        case uTSoldier:
            target = [self nearestUnitOfType:uTSoldier toUnit:u sameTeam:FALSE];
            break;
        case uTHeavy:
            target = [self nearestUnitOfType:uTNoType toUnit:u sameTeam:FALSE];
            break;
        case uTMedic:
            target = [self nearestUnitOfType:uTNoType toUnit:u sameTeam:TRUE];
            break;
    }
    if (u.unitHealth < u.unitMaxHealth/2) {
        target = [self nearestUnitOfType:uTMedic toUnit:u sameTeam:TRUE];
    }
    
    float targetAngle;
    
    if (target == nil) {
        targetAngle = [self pointPairToBearingDegreesStart:u.position end:ccp(wSize.width/2, wSize.height/2)];
    }
    else {
        targetAngle = [self pointPairToBearingDegreesStart:u.position end:target.position];
    }

    float newXVel = cos(targetAngle)*u.unitSpeed;
    float newYVel = sin(targetAngle)*u.unitSpeed;

    b2Body *b = u.b2Body;
    b2Vec2 vel = b->GetLinearVelocity();

    float impulseX = (vel.x + newXVel)/4;
    float impulseY = (vel.y + newYVel)/4;

    b->SetLinearVelocity(b2Vec2(impulseX, impulseY));
}

-(Unit *)nearestUnitOfType:(int)unitType toUnit:(Unit *)unit sameTeam:(BOOL)sameTeamBool {
    Team *tIQ;
    int sameTeamIndex = unit.unitTeam.teamArrayIndex;
    int otherTeamIndex;
    if (sameTeamBool) {
        tIQ = [teamsArray objectAtIndex:sameTeamIndex];
    }
    else {
        otherTeamIndex = (sameTeamIndex == 0) ? 1 : 0;
        tIQ = [teamsArray objectAtIndex:otherTeamIndex];
    }
    float dist = 9999.;
    Unit *uTR = nil; //unit to return
    for (Unit *uIQ in tIQ.unitArray) {
        if (((unitType != uTNoType)  && (uIQ.unitType != unitType)) || [targetsArray containsObject:uIQ])
            continue;
        float checkDist = ccpDistance(unit.position, uIQ.position);
        if ((checkDist < dist) && (checkDist < 100))
            dist = checkDist;
            uTR = uIQ;
    }
    return uTR;
}

-(NSDictionary *)getNeighborsAndSpaceInvadersForUnit:(Unit *)unit {
    NSMutableArray *neighbors = [NSMutableArray new];
    NSMutableArray *spaceInvaders = [NSMutableArray new];
    
    for (Unit *u in unit.unitTeam.unitArray) {
        float uD = ccpDistance(unit.position, u.position);
        if (uD < 64) {
            [spaceInvaders addObject:u];
        }
        if (uD < 128) {
            [neighbors addObject:u];
        }
    }
    return @{@"neighbors": neighbors, @"spaceInvaders": spaceInvaders};
}

-(CGPoint)centerOfMassForArrayOfUnits:(NSMutableArray *)arr{
    float cOMX;
    float cOMY;
    for (Unit *u in arr) {
        cOMX += u.position.x;
        cOMY += u.position.y;
    }
    cOMX /= [arr count];
    cOMY /= [arr count];
    
    return ccp(cOMX, cOMY);
}

-(b2Vec2)relativeVelocityForArrayOfUnits:(NSMutableArray *)arr {
    b2Vec2 relVel = b2Vec2(0.,0.);
    for (Unit *u in arr) {
        relVel += u.b2Body->GetLinearVelocity();
    }
    relVel.x /= [arr count];
    relVel.y /= [arr count];
    
    return relVel;
}

-(float) pointPairToBearingDegreesStart:(CGPoint)startingPoint end:(CGPoint)endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees * M_PI/180.;
}

-(void)beginContact:(b2Contact *)contact {
    NSLog(@"Contact");
    
}

-(void)endContact:(b2Contact *)contact {
    
    
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

@end
