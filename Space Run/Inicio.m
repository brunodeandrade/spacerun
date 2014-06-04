//
//  Inicio.m
//  Space Run
//
//  Created by Bruno Rodrigues de Andrade on 03/06/14.
//  Copyright (c) 2014 Bruno Rodrigues de Andrade. All rights reserved.
//

#import "Inicio.h"
#import "MyScene.h"

@implementation Inicio
static const float BG_POINTS_PER_SEC = 30;
int foi = 0;

static inline CGPoint CGPointMultiplyScalar(const CGPoint a,const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

CGPoint _velocity;
SKSpriteNode *sp;

-(id)initWithSize:(CGSize)size{
    if(self = [super initWithSize:size]){
        NSLog(@"Tamanho inicio: %@",NSStringFromCGSize(self.size));
       self.backgroundColor = [SKColor whiteColor];
        
        //Adiciona background a imagem
        for (int i = 0; i < 2; i++) {
            SKSpriteNode * bg = [SKSpriteNode spriteNodeWithImageNamed:@"espaco_back"];
            bg.anchorPoint = CGPointZero;
            bg.position = CGPointMake(0, (i*bg.size.height));
            bg.name = @"bg";
            [self addChild:bg];
            
            [bg setScale:0.5];
        }
        
        
        
        
        
        sp = [SKSpriteNode spriteNodeWithImageNamed:@"Space"];
        sp.anchorPoint = CGPointZero;
        sp.position = CGPointMake(self.size.width/3.4, self.size.height/2);
        sp.name = @"sp";
        sp.alpha = 0;
        [self addChild:sp];
        [sp setScale:0.4];
        
        
        
    }
    return self;
}



- (void)moveBg {
    
    [self enumerateChildNodesWithName:@"bg" usingBlock: ^(SKNode *node, BOOL *stop) {
        SKSpriteNode * bg = (SKSpriteNode *) node;
        CGPoint bgVelocity = CGPointMake(0, -BG_POINTS_PER_SEC);
        CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity, _dt);
        bg.position = CGPointAdd(bg.position, amtToMove);
        if (bg.position.y <= -bg.size.height) {
            bg.position = CGPointMake(bg.position.x,bg.position.y + bg.size.height*2);
        }
    }];
    
    
}


-(void) apareceLetra:(SKSpriteNode *) sprite{
    //actionTiro = [SKAction moveToX:astr.position.x*4 duration:0.5];
    //sprite.position = CGPointMake(self.size.width/3.4, self.size.height/2);
    SKAction *espera = [SKAction waitForDuration:1];
    SKAction *fadeIn = [SKAction fadeInWithDuration:3];
    [sprite runAction:[SKAction sequence:@[espera,fadeIn]]];
}



-(void)update:(NSTimeInterval)currentTime{
    
    //Movimenta o background a cada frame
    [self moveBg];
       //Calcula o tempo percorrido por frame
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    } else {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    //if (foi == 0) {
        [self apareceLetra:sp];
        foi = 1;
//    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // 1
    SKScene * comecaJogo = [[MyScene alloc] initWithSize:self.size];
    // 2
    //[comecaJogo setScale:0.4];
    comecaJogo.scaleMode = SKSceneScaleModeAspectFill;
    
    SKTransition *reveal = [SKTransition fadeWithDuration:3];
    // 3
    [self.view presentScene:comecaJogo transition:reveal];
}



@end
