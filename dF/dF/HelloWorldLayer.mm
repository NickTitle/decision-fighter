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

CGSize wSize;

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
            [self addChild:u];
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
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
    [self updateSoldiers];
	world->Step(dt, velocityIterations, positionIterations);	
}

-(void)updateSoldiers {
    for (Team *t in teamsArray) {
        for (Unit *u in t.unitArray) {
            [self stepUnit:u];
        }
    }
}

-(void)stepUnit:(Unit *)u {
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
        if ((unitType != uTNoType)  && (uIQ.unitType != unitType))
            continue;
        float checkDist = ccpDistance(unit.position, uIQ.position);
        if ((checkDist < dist) && (checkDist < 100))
            dist = checkDist;
            uTR = uIQ;
    }
    return uTR;
}

-(float) pointPairToBearingDegreesStart:(CGPoint)startingPoint end:(CGPoint)endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees * M_PI/180;
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
