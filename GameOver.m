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

-(id)initWithSize:(CGSize)size {

    if(self = [super initWithSize:size]){
        //Adiciona background a imagem
        
        
        SKSpriteNode * bg = [SKSpriteNode spriteNodeWithImageNamed: @"GAME OVER"];
        bg.anchorPoint = CGPointZero;
        bg.position = CGPointMake(self.size.width, self.size.height);
        bg.name = @"bg";
        
        
        
        [self addChild:bg];
        
        
        
        _score = [SKSpriteNode spriteNodeWithImageNamed:@"SCORE"];
        
        _score.anchorPoint = CGPointZero;
        
        _score.position = CGPointMake(self.size.width/3.0, self.size.height/2);
        
        _score.name = @"score";
        
        _score.alpha = 0;
        
        
        
        [self addChild:_score];
        
        
        
        _bestScore = [SKSpriteNode spriteNodeWithImageNamed:@"BEST SCORE"];
        
        _bestScore.anchorPoint = CGPointZero;
        
        _bestScore.position = CGPointMake(self.size.width/2.95, self.size.height/2.4);
        
        _bestScore.name = @"bestScore";
        
        _bestScore.alpha = 0;
        
        [self addChild:_bestScore];
    }
return  self;
}
    
@end
