//
//  GameOver.m
//  Space Run
//
//  Created by Huallyd da Costa Smadi on 09/06/14.
//  Copyright (c) 2014 Bruno Rodrigues de Andrade. All rights reserved.
//

#import "GameOver.h"
#import "MyScene.h"
#import "Pontuacao.h"
#import "Persistence.h"
#import <FacebookSDK/FacebookSDK.h>


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
        
        self.backgroundColor = [SKColor blackColor];
        
        SKSpriteNode * bg = [SKSpriteNode spriteNodeWithImageNamed: @"game_over"];
        bg.anchorPoint = CGPointZero;
        bg.position = CGPointMake(self.size.width/10.0, self.size.height/1.8);
        bg.name = @"game_over";
        bg.alpha = 1;
        
        [self addChild:bg];
        
        [bg setScale:0.5];
        
        
        
        _score = [SKSpriteNode spriteNodeWithImageNamed:@"pont"];
        _score.anchorPoint = CGPointZero;
        _score.position = CGPointMake(self.size.width/3.0, self.size.height/2);
        _score.name = @"score";
        _score.alpha = 1;
        [_score setScale:0.8];
        
        
        [self addChild:_score];
        
        
        _bestScore = [SKSpriteNode spriteNodeWithImageNamed:@"best_score"];
        
        _bestScore.anchorPoint = CGPointZero;
        
        _bestScore.position = CGPointMake(self.size.width/2.95, self.size.height/2.4);
        
        _bestScore.name = @"bestScore";
        
        _bestScore.alpha = 1;
        
        [self addChild:_bestScore];
        
        
        _fb = [SKSpriteNode spriteNodeWithImageNamed:@"facebook"];
        _fb.anchorPoint = CGPointZero;
        _fb.position = CGPointMake(self.size.width/8.8, self.size.height/2.6);
        _fb.name = @"facebook";
        
        [self addChild:_fb];
        
    }
    return self;
}

- (void) escreveTexto{
    
    
    
    SKLabelNode *label2;
    
    
    
    label2 = [SKLabelNode labelNodeWithFontNamed:@"8bitoperator Regular"];
    
    int valor = [[self.userData objectForKey:@"score"] intValue];

    label2.text = [NSString stringWithFormat:@"%d", valor];
    label2.position = CGPointMake(self.size.width/2.5, self.size.height/2.2);
    label2.fontSize = 15.0;
    label2.color = [UIColor blackColor];
    label2.verticalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    label2.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [self addChild:label2];
    
    
    Persistence *ler = [[Persistence alloc] init];
    int valor1 = (int) [ler leRecord];
    
    SKLabelNode *label3;
    
    label3 = [SKLabelNode labelNodeWithFontNamed:@"8bitoperator Regular"];
    NSLog(@"Pontuacao : %d", (int) _pontuacao);
    label3.text = [NSString stringWithFormat:@"%d", valor1];
    label3.position = CGPointMake(self.size.width/2.8, self.size.height/2.6);
    label3.fontSize = 15.0;
    label3.color = [UIColor blackColor];
    label3.verticalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    label3.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [self addChild:label3];
    
}


-(void) didEvaluateActions{
    if(_foi == 0){
        [self escreveTexto];
        
        _foi = 1;
    }
}

- (void)shareWithFacebook{
    
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    
    
    
    params.link = [NSURL URLWithString:@"https://www.facebook.com/app_scoped_user_id/316658155177698/"];
    
    
    
    
    
    // If the Facebook app is installed and we can present the share dialog
    
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        [FBDialogs presentShareDialogWithLink:params.link
         
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          
                                          if(error) {
                                              
                                              // An error occurred, we need to handle the error
                                              
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              
                                              NSLog(@"Error publishing story: %@", error.description);
                                              
                                          } else {
                                              
                                              // Success
                                              
                                              NSLog(@"result %@, esse é meu resultado!", results);
                                              
                                          }
                                          
                                      }];
        
    } else {
        
        [FBDialogs presentShareDialogWithLink:params.link
         
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          
                                          if(error) {
                                              
                                          } else {
                                              
                                          }
                                          
                                      }];
        
    }
    
}





-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch * touch = [touches anyObject];
    
    CGPoint touchLocation = [touch locationInNode:self];
    
    SKNode * node = [self nodeAtPoint:touchLocation];
    
    SKScene * comecaJogo = [[MyScene alloc] initWithSize:self.size];
    
    comecaJogo.scaleMode = SKSceneScaleModeAspectFill;
    
    SKTransition *reveal = [SKTransition fadeWithDuration:1];
    
    [self.view presentScene:comecaJogo transition:reveal];
    
    if([node.name isEqualToString:@"facebook"]){
        
        [self shareWithFacebook];
        
    }
    
}





@end
