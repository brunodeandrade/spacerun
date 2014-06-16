//
//  Tutorial.m
//  Space Run
//
//  Created by Henrique Santos on 16/06/14.
//  Copyright (c) 2014 Bruno Rodrigues de Andrade. All rights reserved.
//

#import "Tutorial.h"
#import "Inicio.h"

@implementation Tutorial

-(id) initWithSize:(CGSize)size{
    if(self = [super initWithSize:size]){
        //Adiciona background a imagem
        
        self.backgroundColor = [SKColor blackColor];
        
        SKSpriteNode * tutorial = [SKSpriteNode spriteNodeWithImageNamed: @"imgTutorial"];
        tutorial.anchorPoint = CGPointZero;
        tutorial.position = CGPointMake(self.size.width/50,self.size.height/3);
        tutorial.name = @"tutorial";
        tutorial.alpha = 1;
        [tutorial setScale:0.272];
        [self addChild:tutorial];
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"tutorial"]) {
        SKScene * comecaJogo = [[Inicio alloc] initWithSize:self.size];
        comecaJogo.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *reveal = [SKTransition fadeWithDuration:3];
        [self.view presentScene:comecaJogo transition:reveal];
    }
}



@end
