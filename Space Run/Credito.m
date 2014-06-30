//
//  Credito.m
//  Space Run
//
//  Created by Bruno Rodrigues de Andrade on 11/06/14.
//  Copyright (c) 2014 Bruno Rodrigues de Andrade. All rights reserved.
//

#import "Credito.h"
#import "Inicio.h"
#import <AVFoundation/AVFoundation.h>

SKSpriteNode * developers;
AVAudioPlayer *backgroundMusicPlayer1;



@implementation Credito


-(id) initWithSize:(CGSize)size{
    if(self = [super initWithSize:size]){
        //Adiciona background a imagem
        
        self.backgroundColor = [SKColor blackColor];
        [self playBackgroundMusic:@"som_inicio_menor.mp3"];
        
        SKSpriteNode * developers = [SKSpriteNode spriteNodeWithImageNamed: @"developers"];
        developers.anchorPoint = CGPointZero;
        developers.position = CGPointMake(self.size.width/4,100);
        developers.name = @"developers";
        developers.alpha = 1;
        
        [self addChild:developers];
        
        [developers setScale:0.3];
        
        SKSpriteNode * tudo = [SKSpriteNode spriteNodeWithImageNamed: @"tudo_desenvolvedores"];
        tudo.anchorPoint = CGPointZero;
        tudo.position = CGPointMake(self.size.width/15,50);
        tudo.name = @"desenvolvedores";
        tudo.alpha = 1;
        [self addChild:tudo];
        [tudo setScale:0.3];
        
        
        SKSpriteNode * sounds = [SKSpriteNode spriteNodeWithImageNamed: @"sound-effects"];
        sounds.anchorPoint = CGPointZero;
        sounds.position = CGPointMake(self.size.width/5,50);
        sounds.name = @"sounds";
        sounds.alpha = 1;
        [self addChild:sounds];
        [sounds setScale:0.3];
        
        
        SKSpriteNode * musicos1 = [SKSpriteNode spriteNodeWithImageNamed: @"musicos1"];
        musicos1.anchorPoint = CGPointZero;
        musicos1.position = CGPointMake(self.size.width/5,50);
        musicos1.name = @"musicos1";
        musicos1.alpha = 1;
        [self addChild:musicos1];
        [musicos1 setScale:0.3];
        
        
        SKSpriteNode * musicos2 = [SKSpriteNode spriteNodeWithImageNamed: @"musicos2"];
        musicos2.anchorPoint = CGPointZero;
        musicos2.position = CGPointMake(0,50);
        musicos2.name = @"musicos2";
        musicos2.alpha = 1;
        [self addChild:musicos2];
        [musicos2 setScale:0.27];
        
        
        SKSpriteNode *sp = [SKSpriteNode spriteNodeWithImageNamed:@"Space"];
        sp.anchorPoint = CGPointZero;
        sp.position = CGPointMake(self.size.width/3.4, 50);
        sp.name = @"Space";
        sp.alpha = 1;
        [self addChild:sp];
        [sp setScale:0.4];
        
        
        SKAction *moveImagem = [SKAction moveToY:self.size.height+10 duration:13];
        SKAction *wait = [SKAction waitForDuration:2];
        SKAction *sequence = [SKAction sequence:@[wait,moveImagem]];
        [developers runAction:moveImagem];
        
        [tudo runAction:sequence completion:^{
            [tudo removeFromParent];
        }];
        
        
        SKAction *moveImagem1 = [SKAction moveToY:self.size.height+10 duration:13];
        SKAction *wait1 = [SKAction waitForDuration:4];
        SKAction *sequence1 = [SKAction sequence:@[wait1,moveImagem1]];

        
        [sounds runAction:sequence1 completion:^{
            [sounds removeFromParent];
        }];
        
        
        
        SKAction *moveImagem2 = [SKAction moveToY:self.size.height+10 duration:13];
        SKAction *wait2 = [SKAction waitForDuration:7];
        SKAction *sequence2 = [SKAction sequence:@[wait2,moveImagem2]];
        
        
        [musicos1 runAction:sequence2 completion:^{
            [musicos1 removeFromParent];
        }];
        
        
        SKAction *moveImagem3 = [SKAction moveToY:self.size.height+10 duration:13];
        SKAction *wait3 = [SKAction waitForDuration:9];
        SKAction *sequence3 = [SKAction sequence:@[wait3,moveImagem3]];
        
        
        [musicos2 runAction:sequence3 completion:^{
            [musicos2 removeFromParent];
        }];
        
        
        
        
        
        
        SKAction *moveEspaco = [SKAction moveToY:self.size.height/2 duration:5];
        SKAction *wait4 = [SKAction waitForDuration:12];
        SKAction *sequence4 = [SKAction sequence:@[wait4,moveEspaco]];
        
        [sp runAction:sequence4];
        
        
        
        
    }
    return  self;

}

- (void)playBackgroundMusic:(NSString *)filename
{
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    backgroundMusicPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    backgroundMusicPlayer1.numberOfLoops = -1;
    backgroundMusicPlayer1.volume = 0.8;
    //backgroundMusicPlayer1.delegate = self;
    [backgroundMusicPlayer1 prepareToPlay];
    [backgroundMusicPlayer1 play];
}





-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    
    if ([node.name isEqualToString:@"Space"]) {
        SKScene * comecaJogo = [[Inicio alloc] initWithSize:self.size];
        comecaJogo.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *reveal = [SKTransition fadeWithDuration:3];
        [self.view presentScene:comecaJogo transition:reveal];
        [backgroundMusicPlayer1 stop];
    }
}




@end
