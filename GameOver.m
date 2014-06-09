//
//  GameOver.m
//  Space Run
//
//  Created by Huallyd da Costa Smadi on 09/06/14.
//  Copyright (c) 2014 Bruno Rodrigues de Andrade. All rights reserved.
//

#import "GameOver.h"
#import "MyScene.h"

@implementation GameOver

//
//  GameOverScene.m
//  Space Run
//
//  Created by Huallyd da Costa Smadi on 09/06/14.
//  Copyright (c) 2014 Bruno Rodrigues de Andrade. All rights reserved.
//


- (id)initWithSize:(CGSize)size won:(BOOL)won
{
    if (self = [super initWithSize:size]) {
        SKSpriteNode *bg;
        bg = [SKSpriteNode
              spriteNodeWithImageNamed:@"GAME OVER.png"];
        //[self runAction:[SKAction sequence:@[
        //[SKAction waitForDuration:0.1],
        //[SKAction playSoundFileNamed:@"lose.wav"
        // waitForCompletion:NO]]]];
        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bg];
        
        // More here
        SKAction * wait = [SKAction waitForDuration:3.0];
        SKAction * block =
        [SKAction runBlock:^{
            MyScene * myScene =
            [[MyScene alloc] initWithSize:self.size];
            
            SKTransition *reveal =
            [SKTransition flipHorizontalWithDuration:0.5];
            
            [self.view presentScene:myScene transition: reveal];
        }];
        [self runAction:[SKAction sequence:@[wait, block]]];
        
    }
    return self;
}


@end
