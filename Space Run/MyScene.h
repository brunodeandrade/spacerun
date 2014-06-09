//
//  MyScene.h
//  Space Run
//

//  Copyright (c) 2014 Bruno Rodrigues de Andrade. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene

@property NSTimeInterval lastUpdateTime;
@property NSTimeInterval  dt;
@property CGPoint velocity;
@property int velocidade;
@property SKAction * explosaoAnimation;
@property SKAction *alien;

@end
