//
//  MyScene.m
//  Space Run
//
//  Created by Bruno Rodrigues de Andrade on 28/05/14.
//  Copyright (c) 2014 Bruno Rodrigues de Andrade. All rights reserved.

#import "MyScene.h"

//Constante relativa ao movimento do background
static const float BG_POINTS_PER_SEC = 50;
static const float ASTR_POINTS_PER_SEC = 50;
SKAction *astronautAnimation;
SKSpriteNode *astr;
int pulou = 0;
int pulando = 0;
int caindo = 0;

@implementation MyScene

static inline CGPoint CGPointMultiplyScalar(const CGPoint a,const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

//Metodo de inicializaçao, usado para adicionar sprites ao app(Atentar-se a ordem dos sprites)
-(id)initWithSize:(CGSize)size{
    if(self = [super initWithSize:size]){
        //Adiciona background a imagem
        for (int i = 0; i < 2; i++) {
            SKSpriteNode * bg = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
            bg.anchorPoint = CGPointZero;
            bg.position = CGPointMake(i * bg.size.width, 0);
            bg.name = @"bg";
            [bg setScale:0.8];
            [self addChild:bg];
        }
        
        //Adiciona o ground a imagem
        for (int i = 0; i < 9; i++) {
            SKSpriteNode * gd =
            [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"ground%d",i]];
            gd.anchorPoint = CGPointZero;
            [gd setScale:0.32];
            gd.position = CGPointMake(i * gd.size.width, 195);
            gd.name = @"gd";
            [self addChild:gd];
        }
        
        
        astr = [SKSpriteNode spriteNodeWithImageNamed:@"astr_runing0"];
        
        [self addChild:astr];
        NSMutableArray *textures = [NSMutableArray arrayWithCapacity:10];
        
        for (int i = 1; i < 9; i++) {
            NSString *textureName = [NSString stringWithFormat:@"astr1_runing%d", i];
            SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
            [textures addObject:texture];
        }
        
        astronautAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
        [astr runAction:[SKAction repeatActionForever:astronautAnimation]];
        
        /*Descobre o tamanho*/
        
        CGSize mySize = astr.size;
        
        NSLog(@"Size: %@",NSStringFromCGSize(mySize));
        
        astr.position = CGPointMake(self.size.width / 2, (self.size.height / 2)-28);
        
        astr.anchorPoint = CGPointMake(0.5, 0.5);
     
        [astr setScale:0.3];
        
    }
    return self;
}

//Metodo responsavel por mover o background na tela
- (void)moveBg {
    [self enumerateChildNodesWithName:@"bg" usingBlock: ^(SKNode *node, BOOL *stop) {
        SKSpriteNode * bg = (SKSpriteNode *) node;
        CGPoint bgVelocity = CGPointMake(-ASTR_POINTS_PER_SEC, 0);
        CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity, _dt);
        bg.position = CGPointAdd(bg.position, amtToMove);
        
        if (bg.position.x <= -bg.size.width) {
            bg.position = CGPointMake(bg.position.x + bg.size.width*2,bg.position.y);
        }
    }];
    
}

-(void) pulaAstronauta{
    [self enumerateChildNodesWithName:@"astr1_runing0" usingBlock: ^(SKNode *node, BOOL *stop) {
        SKSpriteNode * bg = (SKSpriteNode *) node;
        CGPoint bgVelocity = CGPointMake(-BG_POINTS_PER_SEC, 0);
        CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity, _dt);
        bg.position = CGPointAdd(bg.position, amtToMove);
        
        if (bg.position.x <= -bg.size.width) {
            bg.position = CGPointMake(bg.position.x + bg.size.width*2,bg.position.y);
        }
    }];
    
}
//Adiciona obstaculos ao jogo
-(void)addObstaculo{
    SKSpriteNode * ball =
    [SKSpriteNode spriteNodeWithImageNamed:@"meteoro"];
    ball.anchorPoint = CGPointZero;
    [ball setScale:0.2];
    ball.name = @"meteoro";
    ball.position = CGPointMake(ball.size.width+(arc4random() % 600)+70, 102);
    [self addChild:ball];
}

//Move o solo no jogo, em tempo diferente ao do background
-(void)moveGround{
    
    [self enumerateChildNodesWithName:@"gd" usingBlock: ^(SKNode *node, BOOL *stop) {
        SKSpriteNode * gd = (SKSpriteNode *) node;
        CGPoint gdVelocity = CGPointMake(-75+_velocidade, 0);
        CGPoint amtToMove = CGPointMultiplyScalar(gdVelocity, _dt);
        gd.position = CGPointAdd(gd.position, amtToMove);
        
        if (gd.position.x <= -gd.size.width) {
            gd.position = CGPointMake(gd.position.x + gd.size.width*9,gd.position.y);
        }
    }];
}

//Movimenta o meteoro junto ao Ground
-(void)moveMeteoro{
    [self enumerateChildNodesWithName:@"meteoro" usingBlock: ^(SKNode *node, BOOL *stop) {
        SKSpriteNode * mt = (SKSpriteNode *) node;
        CGPoint mtVelocity = CGPointMake(-75+_velocidade, 0);
        CGPoint amtToMove = CGPointMultiplyScalar(mtVelocity, _dt);
        mt.position = CGPointAdd(mt.position, amtToMove);
        
        if (mt.position.x <= -mt.size.width) {
            mt.position = CGPointMake(mt.position.x + mt.size.width*2,mt.position.y);
        }
    }];
}

//Metodo responsavel por executar mudanças a cada frame passado
-(void)update:(NSTimeInterval)currentTime{
    
    //Movimenta o background a cada frame
    [self moveBg];
    //Movimenta o meteoro
    [self moveMeteoro];
    //Movimenta o solo
    [self moveGround];
    
    //Calcula o tempo percorrido por frame
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    } else {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    NSLog(@"%0.2f milliseconds since last update", _dt * 1000);
    
    
    if(pulou && pulando <= 10){
        
        //[self pulaAstronauta];
        astr.position = CGPointMake(astr.position.x, astr.position.y+pulando+2);
        pulando++;
        caindo = pulando;
    }
    else if (pulando >=10 && caindo >0) {
        astr.position = CGPointMake(astr.position.x, astr.position.y-caindo);
        caindo--;
    }
    else if (caindo == 0){
        pulando = 0;
        pulou=0;
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    pulou = 1;
    //[self moveZombieToward:touchLocation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    //[self moveZombieToward:touchLocation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    //[self moveZombieToward:touchLocation];
}


@end
