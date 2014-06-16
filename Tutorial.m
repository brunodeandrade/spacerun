//
//  Tutorial.m
//  Space Run
//
//  Created by Henrique Santos on 16/06/14.
//  Copyright (c) 2014 Bruno Rodrigues de Andrade. All rights reserved.
//

#import "Tutorial.h"

@implementation Tutorial

-(id) initWithSize:(CGSize)size{
    if(self = [super initWithSize:size]){
        //Adiciona background a imagem
        
        self.backgroundColor = [SKColor blackColor];
        
        SKSpriteNode * tutorial = [SKSpriteNode spriteNodeWithImageNamed: @"imgTutorial"];
        tutorial.anchorPoint = CGPointZero;
        tutorial.position = CGPointMake(self.size.width/4,150);
        tutorial.name = @"tutorial";
        tutorial.alpha = 1;
        
        [self addChild:developers];
    }
    
}




@end
