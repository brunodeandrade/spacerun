//
//  MyScene.h
//  Space Run
//

//  Copyright (c) 2014 Bruno Rodrigues de Andrade. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GADBannerView.h"

@interface MyScene : SKScene{
    GADBannerView *bannerView;
    
}

@property NSTimeInterval lastUpdateTime;
@property NSTimeInterval  dt;
@property NSTimeInterval  dtMeteoro;
@property CGPoint velocity;
@property int velocidade;
@property SKAction * explosaoAnimation;
@property SKAction * morteAnimation;
@property SKSpriteNode *alien;
@property SKSpriteNode *play;
@property SKSpriteNode *pause;

-(void)showBanner;

@end
