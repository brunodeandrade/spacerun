//
//  Setup.m
//  Space Run
//
//  Created by Bruno Rodrigues de Andrade on 06/06/14.
//  Copyright (c) 2014 Bruno Rodrigues de Andrade. All rights reserved.
//

#import "Setup.h"

@implementation Setup

-(SKSpriteNode *) setupAstronauta:(SKSpriteNode *) astr{
    
    SKAction *astronautAnimation;
    
    astr = [SKSpriteNode spriteNodeWithImageNamed:@"astrruning0"];
    
    [self addChild:astr];
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:10];
    
    for (int i = 1; i < 9; i++) {
        NSString *textureName = [NSString stringWithFormat:@"astr1runing%d", i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    
    astronautAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    [astr runAction:[SKAction repeatActionForever:astronautAnimation]];
    
    /*Descobre o tamanho*/
    
    CGSize mySize = astr.size;
    
    NSLog(@"Size: %@",NSStringFromCGSize(mySize));
    
    astr.position = CGPointMake((self.size.width / 2) - 120, (self.size.height / 2)-28);
    
    astr.anchorPoint = CGPointMake(0.5, 0.5);
    
    [astr setScale:0.3];
    
    return astr;
}

@end
