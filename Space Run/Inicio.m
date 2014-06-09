//
//  Inicio.m
//  Space Run
//
//  Created by Bruno Rodrigues de Andrade on 03/06/14.
//  Copyright (c) 2014 Bruno Rodrigues de Andrade. All rights reserved.
//

#import "Inicio.h"
#import "MyScene.h"
#import <AVFoundation/AVFoundation.h>

@implementation Inicio
static const float BG_POINTS_PER_SEC = 30;
int foi = 0;
SKAction *somInicio;
SKSpriteNode *musica;
AVAudioPlayer *_backgroundMusicPlayer;

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
SKSpriteNode *play;

-(id)initWithSize:(CGSize)size{
    if(self = [super initWithSize:size]){
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
        
        [self playBackgroundMusic:@"som_inicio_menor.mp3"];
        
        sp = [SKSpriteNode spriteNodeWithImageNamed:@"Space"];
        sp.anchorPoint = CGPointZero;
        sp.position = CGPointMake(self.size.width/3.4, self.size.height/2);
        sp.name = @"sp";
        sp.alpha = 0;
        [self addChild:sp];
        [sp setScale:0.4];
        
        play = [SKSpriteNode spriteNodeWithImageNamed:@"play"];
        play.anchorPoint = CGPointZero;
        play.position = CGPointMake(self.size.width/2.95, self.size.height/2.4);
        play.name = @"play";
        play.alpha = 0;
        [self addChild:play];
        [play setScale:0.4];
        
        [self apareceLetra:sp duracao:1];
        [self apareceLetra:play duracao:3];
        
    }
    return self;
}


- (void)playBackgroundMusic:(NSString *)filename
{
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    _backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    _backgroundMusicPlayer.numberOfLoops = -1;
    _backgroundMusicPlayer.volume = 0.8;
    _backgroundMusicPlayer.delegate = self;
    [_backgroundMusicPlayer prepareToPlay];
    [_backgroundMusicPlayer play];
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


-(void) apareceLetra:(SKSpriteNode *) sprite duracao:(float) duracao{
    //actionTiro = [SKAction moveToX:astr.position.x*4 duration:0.5];
    //sprite.position = CGPointMake(self.size.width/3.4, self.size.height/2);
    SKAction *espera = [SKAction waitForDuration:duracao];
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
    
        foi = 1;
//    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
        
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    
    // 2
    //[comecaJogo setScale:0.4];
    
    
    
    //if fire button touched, bring the rain
    if ([node.name isEqualToString:@"play"]) {
        SKScene * comecaJogo = [[MyScene alloc] initWithSize:self.size];
        comecaJogo.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *reveal = [SKTransition fadeWithDuration:3];
        [self.view presentScene:comecaJogo transition:reveal];
        [_backgroundMusicPlayer stop];
    }
    
    
    
    
    
}



@end
