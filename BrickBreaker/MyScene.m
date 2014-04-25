//
//  MyScene.m
//  BrickBreaker
//
//  Created by Jordan White on 4/5/14.
//  Copyright (c) 2014 Option White. All rights reserved.
//

#import "MyScene.h"

@interface MyScene()

@property (nonatomic) SKSpriteNode *paddle;
@property (nonatomic) SKSpriteNode *brick;

@end

static const uint32_t ballCategory = 1;     // 00000000000000000000000000000001
static const uint32_t brickCategory = 2;    // 00000000000000000000000000000010
static const uint32_t paddleCategory = 4;   // 00000000000000000000000000000100
static const uint32_t edgeCategory = 8;     // 00000000000000000000000000001000



@implementation MyScene

- (void)addBall:(CGSize)size {
    //create a new sprite node from an image
    SKSpriteNode *ballNode = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    
    //create a center CGPoint for position
    CGPoint centerPoint = CGPointMake(size.width/2, size.height/2);
    
    //add a physics body
    ballNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ballNode.frame.size.width/2];
    ballNode.physicsBody.friction = 0; //friction has an effect when bodies are touching
    ballNode.physicsBody.linearDamping = 0; //over the surface (0-1)
    ballNode.physicsBody.restitution = 1.0f; //"bounciness" (0-1)    speed after collion/speed before collision
    
    //add the sprite node to the scene
    ballNode.position = centerPoint;
    [self addChild:ballNode];
    
    //creates the vector
    CGVector myVector = CGVectorMake(15, 15);
    
    //apply the vector to the physics body
    [ballNode.physicsBody applyImpulse:myVector];
}


-(void) addPlayer:(CGSize)size {
    //create paddle sprite
    self.paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
    //position the paddle
    self.paddle.position = CGPointMake(size.width/2, 100);
    //add a physics body
    self.paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.paddle.frame.size];
    //make it a static
    self.paddle.physicsBody.dynamic = NO;
    
    //add it to the scene
    [self addChild:self.paddle];
}

-(void) addBrick:(CGSize)size {
    
    for (int i=0; i<4; i++) {
        //create the brick sprite
        SKSpriteNode *brick = [SKSpriteNode spriteNodeWithImageNamed:@"brick"];
        
        //position the brick
        brick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.frame.size];
        brick.physicsBody.dynamic = NO;
        
        int xPos = size.width/5 * (i+1);
        int yPos = size.height - 50;
        brick.position = CGPointMake(xPos, yPos);
        
        //add it to the scene
        [self addChild:brick];
    }
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self]; //self - refers to the current screen
        CGPoint newPosition = CGPointMake(location.x, 100);
        
        //stop the paddle from going too far
        if (newPosition.x < self.paddle.size.width/2) {
            newPosition.x = self.paddle.size.width/2;
        }
        if (newPosition.x > self.size.width -(self.paddle.size.width/2)) {
            newPosition.x = self.size.width -(self.paddle.size.width/2);
        }
        self.paddle.position = newPosition;
    }
}


-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        //(UIColor *)colorWithRed:(CGFloat).2 green:(CGFloat).5 blue:(CGFloat).2 alpha:(CGFloat)0;
        self.backgroundColor = [SKColor colorWithRed:(CGFloat).6 green:(CGFloat).9 blue:(CGFloat).5 alpha:(CGFloat)0];
                                
        //add physics to the scene
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        //change gravity seting of the physics world
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        [self addBall:size];
        [self addPlayer:size];
        [self addBrick:size];
    }
    return self;
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
