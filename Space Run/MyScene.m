//
//  MyScene.m
//  Space Run
//
//  Created by Bruno Rodrigues de Andrade on 28/05/14.
//  Copyright (c) 2014 Bruno Rodrigues de Andrade. All rights reserved.

#import "MyScene.h"
#import <AVFoundation/AVFoundation.h>

//Constante relativa ao movimento do background
static const float BG_POINTS_PER_SEC = 50;
static const float ASTR_POINTS_PER_SEC = 480;
static const float GRAVIDADE = 20;


SKAction *astronautAnimation;
SKSpriteNode *astr;
SKSpriteNode *tiro;
SKSpriteNode *bala;
CGPoint _velocity;
int pulou = 0;
int pulando = 0;
int caindo = 0;
AVAudioPlayer *_backgroundMusicPlayer1;
float verificador = 0, x = 0;
int qtdInimigos = 0.5;
float _velocidadeMeteoro = 6;


@implementation MyScene




static inline CGPoint CGPointMultiplyScalar(const CGPoint a,const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}


#define ARC4RANDOM_MAX      0x100000000
static inline CGFloat ScalarRandomRange(CGFloat min, CGFloat max)
{
    return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min);
}

//Metodo de inicializaçao, usado para adicionar sprites ao app(Atentar-se a ordem dos sprites)
-(id)initWithSize:(CGSize)size{
    if(self = [super initWithSize:size]){
        
        
        [self playBackgroundMusic:@"somFase1.mp3" volume:0.8];
        
        
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
        
        
        
        [self runAction:[SKAction repeatActionForever:
        [SKAction sequence:@[[SKAction performSelector:@selector(spawnEnemy) onTarget:self],[SKAction waitForDuration:2.0]]]]];
//        
//        _enemyCollisionSound =
//        [SKAction playSoundFileNamed:@"hitCatLady.wav"
//                   waitForCompletion:NO];
        
        //[self escreveTexto];
    }
    return self;
}


- (void) escreveTexto{
    
    SKLabelNode * label = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    label.text = @"opaaa";
    label.position = CGPointMake(self.size.width/2,
                                 (self.size.height)/2);
    label.fontSize = 20.0;
    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [self addChild:label];
    
    
}


- (void)didEvaluateActions {
    [self checkCollisions:@"asteroid" andOther:astr];
    [self checkCollisions:@"alien" andOther:astr];
    [self checkCollisions:@"alien" andOther:astr];
    [self checkCollisions:@"asteroid" andOther:bala];
    [self checkCollisions:@"alien" andOther:bala];
}



- (void)playBackgroundMusic:(NSString *)filename volume: (float) vol
{
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    _backgroundMusicPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    _backgroundMusicPlayer1.numberOfLoops = -1;
    _backgroundMusicPlayer1.volume = vol;
    //_backgroundMusicPlayer1.delegate = self;
    [_backgroundMusicPlayer1 prepareToPlay];
    [_backgroundMusicPlayer1 play];
}

AVAudioPlayer *_somTiro;
- (void)playTiro:(NSString *)filename volume: (float) vol
{
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    _somTiro = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    _somTiro.numberOfLoops = 0;
    _somTiro.volume = vol;
    [_somTiro prepareToPlay];
    [_somTiro play];
}





//Metodo responsavel por mover o background na tela
- (void)moveBg {
    [self enumerateChildNodesWithName:@"bg" usingBlock: ^(SKNode *node, BOOL *stop) {
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
//-(void)addObstaculo{
//    SKSpriteNode * ball =
//    [SKSpriteNode spriteNodeWithImageNamed:@"meteoro"];
//    ball.anchorPoint = CGPointZero;
//    [ball setScale:0.2];
//    ball.name = @"meteoro";
//    ball.position = CGPointMake(ball.size.width+(arc4random() % 600)+70, 102);
//    [self addChild:ball];
//}


// Adiciona inimigos e obstaculos


- (void)spawnEnemy {
    SKSpriteNode *enemy = [SKSpriteNode spriteNodeWithImageNamed:@"asteroid"];
    enemy.name = @"asteroid";
    [enemy setScale:0.4];
    enemy.position = CGPointMake(enemy.size.width + 300, ScalarRandomRange(enemy.size.height/5,
                                                                           self.size.height-enemy.size.height/4));
    [self addChild:enemy];
    
    SKAction *actionMove = [SKAction moveToX:-enemy.size.width/1 duration:_velocidadeMeteoro];
    SKAction *actionRemove = [SKAction removeFromParent];
    [enemy runAction:
     [SKAction sequence:@[actionMove, actionRemove]]];
    
}

- (void)spawnAlien {
    SKSpriteNode *enemy = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"alien%d",arc4random()%2]];
    enemy.name = @"alien";
    [enemy setScale:0.8];
    enemy.position = CGPointMake(enemy.size.width + 300, ScalarRandomRange(enemy.size.height/5,
                                                                           self.size.height-enemy.size.height/4));
    [self addChild:enemy];
    
    SKAction *actionMove = [SKAction moveToX:-enemy.size.width/1 duration:_velocidadeMeteoro-(0.4)];
    SKAction *actionRemove = [SKAction removeFromParent];
    [enemy runAction:
     [SKAction sequence:@[actionMove, actionRemove]]];
    
}

//Move o solo no jogo, em tempo diferente ao do background
-(void)moveGround{
    
    [self enumerateChildNodesWithName:@"gd" usingBlock: ^(SKNode *node, BOOL *stop) {
        SKSpriteNode * gd = (SKSpriteNode *) node;
        CGPoint gdVelocity = CGPointMake(-(90+_velocidade), 0);
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


-(void) pulaAstronauta:(SKSpriteNode *)sprite velocity:(CGPoint)velocity{
    // 1
    CGPoint amountToMove = CGPointMake(velocity.x * _dt, velocity.y * _dt);
    //NSLog(@"Amount to move: %@", NSStringFromCGPoint(amountToMove));
    // 2
    sprite.position =
    CGPointMake(sprite.position.x + amountToMove.x,
                sprite.position.y + amountToMove.y);
    
}

- (void)moveAteh:(CGPoint)location {
    CGPoint offset = CGPointMake(location.x - astr.position.x, astr.position.y);
    CGFloat length =
    sqrtf(offset.x * offset.x + offset.y * offset.y);
    
    CGPoint direction = CGPointMake(offset.x / length, offset.y / length);
    _velocity =
    CGPointMake(direction.x * ASTR_POINTS_PER_SEC,
                direction.y * ASTR_POINTS_PER_SEC);
}

- (void)caiAstronauta {
    int limitEmCima = (self.size.height / 2)-28 + 100;
    CGPoint newPosition = astr.position;
    CGPoint newVelocity = _velocity;
    // 2
    CGPoint limite = CGPointMake(astr.position.x,limitEmCima);
    
    
    
    //Caiu o suficiente
    if(newPosition.y <= (self.size.height / 2)-28  && newVelocity.y < 0){
        newVelocity.y = 0;
        newPosition.y = (self.size.height / 2)-28;

        pulando = 0;
    }
    
    if(newVelocity.y < 0 || newPosition.y >= limite.y){
        newVelocity.y -= GRAVIDADE;
    }
    
    //Subindo
    if(newVelocity.y > 0){
        newVelocity.y -= GRAVIDADE;
        pulando = 1;
        if(newVelocity.y<=0){
            newVelocity.y = -GRAVIDADE;
        }
        
    }
    _velocity = newVelocity;
    astr.position = newPosition;
    
}


-(void) atira{
    
    SKAction *actionTiro;
    
    tiro = [SKSpriteNode spriteNodeWithImageNamed:@"tiro_arma"];
    [self addChild:tiro];
    tiro.position = CGPointMake(astr.position.x*1.4, astr.position.y);
    tiro.anchorPoint = CGPointMake(0.5, 0.5);
    //[tiro removeFromParent];
    //[tiro setScale:0.3];
    
    bala = [SKSpriteNode spriteNodeWithImageNamed:@"tiro1" ];
    [self addChild:bala];
    bala.position = CGPointMake(astr.position.x*1.5, astr.position.y);
    bala.anchorPoint = CGPointMake(0.5, 0.5);
    
    
    
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:10];
    
    NSString *textureName = @"tiro_arma";
    SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
    [textures addObject:texture];
    
    textureName = @"nada";
    texture = [SKTexture textureWithImageNamed:textureName];
    [textures addObject:texture];
    actionTiro = [SKAction animateWithTextures:textures timePerFrame:0.05];
    
    //actionTiro = [SKAction moveToX:astr.position.x*4 duration:0.5];
    [tiro runAction:[SKAction repeatAction:actionTiro count:1]];
    
    
    actionTiro = [SKAction moveToX:self.size.width*1.2 duration:0.5];
    [bala runAction:[SKAction repeatAction:actionTiro count:1] completion:^{
        [bala removeFromParent];
        [tiro removeFromParent];
    }];
    
    /*SKAction *somTiro = [SKAction playSoundFileNamed:@"tiro.wav"
                                      waitForCompletion:NO];

    [self runAction:somTiro];*/
    [self playTiro:@"tiro.wav" volume:0.15];
    
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
    
    //Defini velocidade do ground
    verificador ++;
    if(verificador >= x ){
        
        if (_velocidade<350) {
            _velocidade = _velocidade+15;
            NSLog(@"%d",_velocidade);
            
            if(x>80 && x<160){
                _velocidadeMeteoro = _velocidadeMeteoro - 0.43;
                
            }else if(_velocidade<250){
                _velocidadeMeteoro = _velocidadeMeteoro - 0.25;
            }else{
                _velocidadeMeteoro = _velocidadeMeteoro - 0.09;
            }
            [self spawnAlien];
            
        }else{
            [self spawnAlien];
            NSLog(@"entra");
            
        }
        
        x = x+80;
    }
    
    if(arc4random()% 300 == 2){
        [self spawnEnemy];
    }
    
    [self pulaAstronauta:astr velocity:_velocity];
    
    [self caiAstronauta];
    
}

- (void)checkCollisions:(NSString *)objeto andOther : (SKSpriteNode *) outro {
    
    [self enumerateChildNodesWithName:objeto
    usingBlock:^(SKNode *node, BOOL *stop){
    SKSpriteNode *enemy = (SKSpriteNode *)node;
    CGRect smallerFrame = CGRectInset(enemy.frame, 10, 10);
        
    // se ocorrer a colisão, o obstaculo é removido, e ação de som da colisão.
    if (CGRectIntersectsRect(smallerFrame, outro.frame)) {
                                   
//    // Chamada do sprit de colisão.
//    _explosao = [SKSpriteNode spriteNodeWithImageNamed:@"exp3_0"];
//    _explosao.position = CGPointMake(100, 100);
//   [self addChild:_explosao];
//                                   
//    // Declaracao e instanciacao do array de sprits (animacao)
//    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:20];
//    // 2
//    for (int i = 0; i < 15; i++) {
//        NSString *textureName = [NSString stringWithFormat:@"exp3_%d", i];
//        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
//        [textures addObject:texture];
//    }
        
                                   
//                                   // 4
//    _explosaoAnimation = [SKAction animateWithTextures:textures timePerFrame:0.5];
        
                                   
                                   
                                   
    NSLog(@"COLIDIU");
                                   
   [enemy removeFromParent];
                                   
   //[self runAction:_enemyCollisionSound];
                                   
    }
    }];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint ate = CGPointMake(astr.position.x, astr.position.y+1);
    CGPoint touchLocation = [touch locationInNode:self];
    //pulou = 1;
    if(!pulando && touchLocation.x > self.size.width/2)
        [self moveAteh:ate];
    if(touchLocation.x < self.size.width/2){
        [self atira];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //UITouch *touch = [touches anyObject];
    
    //[self moveZombieToward:touchLocation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //UITouch *touch = [touches anyObject];
    //CGPoint touchLocation = [touch locationInNode:self];
    //[self moveZombieToward:touchLocation];
}


@end
