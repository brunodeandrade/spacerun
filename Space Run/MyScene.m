//
//  MyScene.m
//  Space Run
//
//  Created by Bruno Rodrigues de Andrade on 28/05/14.
//  Copyright (c) 2014 Bruno Rodrigues de Andrade. All rights reserved.

#import "MyScene.h"
#import <AVFoundation/AVFoundation.h>
#import "RetangleView.h"
#import "Pontuacao.h"
#import "GameOver.h"
#import "Persistence.h"

//Constante relativa ao movimento do background
static const float BG_POINTS_PER_SEC = 50;
//static const float ASTR_POINTS_PER_SEC = 480;
static const float ASTR_POINTS_PER_SEC = 400;
static const float GRAVIDADE = 15;


SKAction *astronautAnimation;
SKSpriteNode *astr;
SKSpriteNode *enemy;
SKSpriteNode *municao;
SKSpriteNode *hud;


NSMutableArray *balas;
CGPoint _velocity;
int pulou = 0;
int pulando = 0;
int caindo = 0;
int morreu = 0;
AVAudioPlayer *_backgroundMusicPlayer1;
float verificador = 0, x = 0;
int qtdInimigos = 0.5;
float _velocidadeMeteoro = 5;
SKNode *_playerLayerNode;
SKNode *_hudLayerNode;
SKLabelNode * label2;
SKLabelNode * label3;
float pontuacao = 0;
int contaTiros = 0;
int quantidadeTiros = 15;
Boolean pausado = NO;
int hitsAsteroid = 0;


@implementation MyScene


static inline CGPoint CGPointMultiplyScalar(const CGPoint a,const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}
-(float) setResolution: (float) numb{
    return (numb*self.size.height)/568;
}

-(void)showBanner{
    
    bannerView= [[GADBannerView alloc] initWithAdSize:kGADAdSizeFullBanner];
    bannerView.adUnitID = @"ca-app-pub-1022918531959852/2494797920";
    bannerView.rootViewController = self;
    [self.view addSubview: bannerView];
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:@"Simulator",@"Device", nil];
    [bannerView setFrame:CGRectMake(35,275, bannerView.bounds.size.width+50, bannerView.bounds.size.height)];
    [bannerView loadRequest:request];
}

//Metodo de inicializaçao, usado para adicionar sprites ao app(Atentar-se a ordem dos sprites)
-(id)initWithSize:(CGSize)size{
    if(self = [super initWithSize:size]){
        
        pontuacao = 0;
        _velocidadeMeteoro = 4;
        quantidadeTiros = 15;
        _velocidade = 80;
        morreu = 0;
        _dtMeteoro = 0;
        hitsAsteroid = 0;
        //Apresenta anuncios
        
        [self playBackgroundMusic:@"somFase1.mp3" volume:0.8];
        [self performSelector:@selector(showBanner) withObject:nil afterDelay:0.4];
        
        
        //Adiciona background a imagem
        for (int i = 0; i < 9; i++) {
            SKSpriteNode * bg = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"background%d",i]];
            bg.anchorPoint = CGPointZero;
            bg.position = CGPointMake(i * bg.size.width, 0);
            bg.name = @"bg";
            [bg setScale:1];
            [self addChild:bg];
        }
        
        
        //Adiciona o ground a imagem
        for (int i = 0; i < 9; i++) {
            SKSpriteNode * gd =
            [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"ground%d",i]];
            gd.anchorPoint = CGPointZero;
            [gd setScale:[self setResolution:0.32]];
            gd.position = CGPointMake(i * gd.size.width, [self setResolution:195]);
            gd.name = @"gd";
            [self addChild:gd];
        }
        
        NSLog(@"Width: %f",self.size.width);
        NSLog(@"Height: %f",self.size.height);
        
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
        
        astr.position = CGPointMake((self.size.width / 2) - 120, (self.size.height / 2)-[self setResolution:28]);
        
        astr.anchorPoint = CGPointMake(0.5, [self setResolution:0.5]);
     
        [astr setScale:[self setResolution:0.3]];
        
        //[self escreveTexto];
        
        hud = [SKSpriteNode spriteNodeWithImageNamed:@"barraPreta.jpg"];
        [self addChild:hud];
        hud.anchorPoint = CGPointZero;
        hud.position = CGPointMake(0, self.size.height - [self setResolution:205]);
        [hud setScale:[self setResolution:0.5]];
        
        
        
        [self escreveTexto];
        [self setupUI];
        
    }
    return self;
}

- (void) explosao : (SKSpriteNode *)ball{
    
    SKSpriteNode * explosao;
    
    
    // Chamada do sprit de colisão.
    explosao = [SKSpriteNode spriteNodeWithImageNamed:@"exp3_0"];
    explosao.position = CGPointMake(ball.position.x, ball.position.y);
    [self addChild:explosao];
    
    // Declaracao e instanciacao do array de sprits (animacao)
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:20];
    // 2
    for (int i = 0; i < 15; i++) {
        NSString *textureName = [NSString stringWithFormat:@"exp3_%d", i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    // 4
    _explosaoAnimation = [SKAction animateWithTextures:textures timePerFrame:0.02];
    [self playExplosao:@"explosao.wav" volume:0.7];
    SKAction *tiraVestigio = [SKAction runBlock:^{
        [explosao removeFromParent];
    }];
    [explosao runAction: [SKAction sequence:@[_explosaoAnimation,tiraVestigio]]];
}

- (void) explosaoMeteoro : (SKSpriteNode *)ball{
    
    SKSpriteNode * explosao;
    
    
    // Chamada do sprit de colisão.
    explosao = [SKSpriteNode spriteNodeWithImageNamed:@"expl0"];
    explosao.position = CGPointMake(ball.position.x, ball.position.y);
    [self addChild:explosao];
    
    // Declaracao e instanciacao do array de sprits (animacao)
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:28];
    // 2
    for (int i = 0; i < 28; i++) {
        NSString *textureName = [NSString stringWithFormat:@"expl%d", i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    // 4
    _explosaoAnimation = [SKAction animateWithTextures:textures timePerFrame:0.02];
    [self playExplosao:@"explosao.wav" volume:0.7];
    SKAction *tiraVestigio = [SKAction runBlock:^{
        [explosao removeFromParent];
    }];
    [explosao runAction: [SKAction sequence:@[_explosaoAnimation,tiraVestigio]]];
}

- (void) morteAstronauta : (SKSpriteNode *) astronauta{
    
    SKSpriteNode * morte;
    
    // Chamada do sprit de colisão.
    
    morte = [SKSpriteNode spriteNodeWithImageNamed:@"explosion0"];
    
    morte.position = CGPointMake(astronauta.position.x, astronauta.position.y);
    
    [self addChild:morte];
    
    
    
    // Declaracao e instanciacao do array de sprits (animacao)
    
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:20];
    
    // 2
    
    for (int i = 0; i < 2; i++) {
        
        NSString *textureName = [NSString stringWithFormat:@"explosion%d", i];
        
        
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        
        [textures addObject:texture];
        [bannerView removeFromSuperview];
    }
    
    // 4
    
    _morteAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    
    [self playExplosao:@"explosao.wav" volume:0.7];
    
    
    
    int pont = (int) pontuacao;
    
    GameOver *gameOver = [[GameOver alloc] initWithSize:self.size];
    
    Persistence *gravar = [[Persistence alloc] init];
    
    [gravar gravaRecord:pont];
    
    
    NSNumber *aNumber = [NSNumber numberWithFloat:pont];
    
    gameOver.userData = [NSMutableDictionary dictionary];
    
    [gameOver.userData setObject:aNumber forKey:@"score"];
    
    
    gameOver.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *reveal = [SKTransition fadeWithDuration:4];
    
    [morte runAction: [SKAction repeatAction:_morteAnimation count:1] completion:^{[morte removeFromParent]; [astronauta removeFromParent]; [self.view presentScene:gameOver transition:reveal]; [_backgroundMusicPlayer1 stop];}];

    
}



- (void) escreveTexto{
    
    label2 = [SKLabelNode labelNodeWithFontNamed:@"8bitoperator Regular"];
    label2.text = @"Score:";
    label2.position = CGPointMake(5,
                                 self.size.height - [self setResolution:205]);
    label2.fontSize = 10.0;
    label2.color = [UIColor blackColor];
    label2.verticalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    label2.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [self addChild:label2];
    
    
    label3 = [SKLabelNode labelNodeWithFontNamed:@"8bitoperator Regular"];
    label3.text = [NSString stringWithFormat:@"Ammo: %d",quantidadeTiros];
    label3.position = CGPointMake(120,
                                  self.size.height - [self setResolution:205]);
    label3.fontSize = 10.0;
    label3.color = [UIColor blackColor];
    label3.verticalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    label3.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [self addChild:label3];
    
    
    _pause = [SKSpriteNode spriteNodeWithImageNamed:@"pause"];
    _pause.anchorPoint = CGPointZero;
    _pause.position = CGPointMake(self.size.width/1.2, self.size.height/1.65);
    _pause.name = @"pause";
    [self addChild:_pause];
    
}


-(void) setupUI{
    
}


- (void)didEvaluateActions {

    [self checkCollisionsAstronauta:@"asteroid" andOther:astr];
    [self checkCollisionsAstronauta:@"alien" andOther:astr];
    [self checkCollisionsMunicao:@"municao" andOther:astr];
    NSMutableArray *balasTemp = [[NSMutableArray alloc] initWithArray:balas];
    for (SKSpriteNode * bala in balasTemp) {
        //[self checkCollisions:@"bala1" andOther:enemy];
        [self checkCollisions:@"alien" andOther:bala];
        [self checkCollisions:@"asteroid" andOther:bala];
    }
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



AVAudioPlayer *_somMunicao;
- (void)playMunicao:(NSString *)filename volume: (float) vol
{
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    _somMunicao = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    _somMunicao.numberOfLoops = 0;
    _somMunicao.volume = vol;
    [_somMunicao prepareToPlay];
    [_somMunicao play];
}




AVAudioPlayer *_somExplosao;
- (void)playExplosao:(NSString *)filename volume: (float) vol
{
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    _somExplosao = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    _somExplosao.numberOfLoops = 0;
    _somExplosao.volume = vol;
    [_somExplosao prepareToPlay];
    [_somExplosao play];
}


//Metodo responsavel por mover o background na tela
- (void)moveBg {
    [self enumerateChildNodesWithName:@"bg" usingBlock: ^(SKNode *node, BOOL *stop) {
        SKSpriteNode * bg = (SKSpriteNode *) node;
        CGPoint bgVelocity = CGPointMake(-BG_POINTS_PER_SEC, 0);
        CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity, _dt);
        bg.position = CGPointAdd(bg.position, amtToMove);
        
        if (bg.position.x <= -bg.size.width) {
            bg.position = CGPointMake(bg.position.x + bg.size.width*9,bg.position.y);
        }
    }];
    
}

- (void)spawnMunicao {
    municao = [SKSpriteNode spriteNodeWithImageNamed:@"tiro3"];
    municao.name = @"municao";
    [municao setScale:[self setResolution:0.2]];
    municao.position = CGPointMake(self.size.width + 100, [self decidePosicao]);
    [self addChild:municao];
    
    SKAction *actionMove = [SKAction moveToX:-municao.size.width/1 duration:2];
    SKAction *actionRemove = [SKAction removeFromParent];
    [municao runAction:
     [SKAction sequence:@[actionMove, actionRemove]]];
}



// Adiciona inimigos e obstaculos
- (void)spawnEnemy {
    
    static int x = 1;
    
    enemy = [SKSpriteNode spriteNodeWithImageNamed:@"asteroid"];
    enemy.name = @"asteroid";
    [enemy setScale:[self setResolution:0.3]];
    enemy.position = CGPointMake(self.size.width + (x%2== 0 ? 200 : 0 ) , [self decidePosicao]);
    [self addChild:enemy];
    x++;
    SKAction *actionMove = [SKAction moveToX:-enemy.size.width/1 duration:_velocidadeMeteoro-(x%2== 0 ? 1.5 : 0.5 )];
    SKAction *actionRemove = [SKAction removeFromParent];
    [enemy runAction:
     [SKAction sequence:@[actionMove, actionRemove]]];
    
}

- (void)spawnAlien {
    _alien = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"alien%d",arc4random()%2]];
    _alien.name = @"alien";
    [_alien setScale:[self setResolution:0.6]];
    _alien.position = CGPointMake(self.size.width,[self decidePosicao]); //ScalarRandomRange(enemy.size.height/5,
                                                           //                self.size.height-enemy.size.height/4));
    [self addChild:_alien];
    
    SKAction *actionMove = [SKAction moveToX:-_alien.size.width/1 duration:_velocidadeMeteoro-(1.5)];
    SKAction *actionRemove = [SKAction removeFromParent];
    [_alien runAction:
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
    int limitEmCima = (self.size.height / 2)- 28 + 100;
    CGPoint newPosition = astr.position;
    CGPoint newVelocity = _velocity;
    // 2
    CGPoint limite = CGPointMake(astr.position.x,limitEmCima);
    
    
    
    //Caiu o suficiente
    if(newPosition.y <= ((self.size.height / 2)- [self setResolution:28])  && newVelocity.y < 0){
        newVelocity.y = 0;
        newPosition.y = (self.size.height / 2)- [self setResolution:28];

        pulando = 0;
    }
    
    if(newVelocity.y < 0 || newPosition.y >= limite.y){
        newVelocity.y -= [self setResolution:GRAVIDADE]+ [self setResolution:10];
    }
    
    //Subindo
    if(newVelocity.y > 0){
        newVelocity.y -= [self setResolution:GRAVIDADE];
        pulando = 1;
        if(newVelocity.y<=0 || newPosition.y >= limite.y){
            newVelocity.y = -[self setResolution:GRAVIDADE];
        }
        
    }
    _velocity = newVelocity;
    astr.position = newPosition;
    
}


-(void) atira{
    
    SKAction *actionTiro;
    SKSpriteNode *tiro;
    

    
    tiro = [SKSpriteNode spriteNodeWithImageNamed:@"tiro_arma"];
    [self addChild:tiro];
    tiro.position = CGPointMake(astr.position.x*1.56, astr.position.y+[self setResolution:3]);
    tiro.anchorPoint = CGPointMake(0.5, [self setResolution:0.5]);
    //[tiro removeFromParent];
    //[tiro setScale:0.3];
    
    contaTiros++;
    SKSpriteNode *bala = [SKSpriteNode spriteNodeWithImageNamed:@"tiro1" ];
    [self addChild:bala];
    bala.position = CGPointMake(astr.position.x*1.56, astr.position.y+[self setResolution:3]);
    bala.anchorPoint = CGPointMake(0.5, [self setResolution:0.5]);
    bala.name = [NSString stringWithFormat:@"tiro%d",contaTiros];
    
    balas = [[NSMutableArray alloc]initWithArray:balas];
    
    [balas addObject:bala];
    
    
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

- (void) iniciar : (int) pause {
    
    
    
    if (pause == 1) {
        
        _play = [SKSpriteNode spriteNodeWithImageNamed:@"play2"];
        _play.anchorPoint = CGPointZero;
        _play.position = CGPointMake(self.size.width/2.8, self.size.height/2.6);
        _play.name = @"play2";
        [self addChild:_play];
        
    }
    
    else {
        [_play removeFromParent];
    }
    
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
    
    [self incrementaVelocidade];
    [self addObstaculo];
    
    
    [self pulaAstronauta:astr velocity:_velocity];
    [self caiAstronauta];
    
    
    label2.text = [NSString stringWithFormat:@"Score: %d",(int)pontuacao];
    
    if(morreu == 0)
        pontuacao++;
    
    label3.text = [NSString stringWithFormat:@"Ammo: %d",quantidadeTiros];
    
}

-(CGFloat)decidePosicao{
    static float cont = 1;
    
    
    if((int)cont % 2 == 0){
        float posicao = 250 + arc4random() % 5;
        cont = cont + 1;
        return [self setResolution:posicao];
        
    }else{
        float posicao = 270 + arc4random() % (int)(self.size.height-270);
        cont = cont + 1;
        return [self setResolution:posicao];
    }
    
}



-(void)addObstaculo{
    
    static int x = 1;
    
    if(x % 2 == 0){
        if(arc4random() % (_velocidade > 300 ? 40 : 50) == 2){
            [self spawnAlien];
        }
    }else{
        if(arc4random() % (_velocidade > 300 ? 80 : 90) == 2){
            
            [self spawnEnemy];
        }
    }
    
    if(quantidadeTiros == 0 ){
        if(arc4random() % 250 == 2){
            
            //if(_dtMeteoro == 0){
                [self spawnMunicao];
                
            //}else{
                
           // }
        }
    }
    
    x++;
}

-(void)incrementaVelocidade{
    
    verificador ++;
    static int x = 0;
    if(verificador >= x ){
        
        if (_velocidade<350) {
            _velocidade = _velocidade+15;
            
            if(x>80 && x<160){
                _velocidadeMeteoro = _velocidadeMeteoro - 0.20;
                
            }else if(_velocidade<250){
                _velocidadeMeteoro = _velocidadeMeteoro - 0.08;
            }else{
                _velocidadeMeteoro = _velocidadeMeteoro - 0.01;
            }
        }
        
        x = x+80;
    }
    
}

- (void)checkCollisions:(NSString *)objeto andOther : (SKSpriteNode *) outro {
    
    [self enumerateChildNodesWithName:objeto
    usingBlock:^(SKNode *node, BOOL *stop){
    SKSpriteNode *enemy = (SKSpriteNode *)node;
    CGRect smallerFrame = CGRectInset(enemy.frame, 0, 0);
        
    // se ocorrer a colisão, o obstaculo é removido, e ação de som da colisão.
    if (CGRectIntersectsRect(smallerFrame, outro.frame)) {
        
        if ([objeto isEqualToString:@"alien"]) {
            
        
        SKSpriteNode * bg = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"mais200"]];
        bg.anchorPoint = CGPointZero;
        bg.position = CGPointMake(enemy.position.x-15, enemy.position.y+ [self setResolution:5]);
        bg.name = @"bg";
        [bg setScale:[self setResolution:0.4]];
        [self addChild:bg];
        SKAction *acao = [SKAction fadeOutWithDuration:1];
        [bg runAction:acao];
        
            [enemy removeFromParent];
            [outro removeFromParent];
        
            pontuacao += 200;
            [self explosao : outro];
            [balas removeObject:outro];
            hitsAsteroid = 0;
        }
        else if ([objeto isEqualToString:@"asteroid"]){
            if(hitsAsteroid >= 2){
                [enemy removeFromParent];
                NSLog(@"Explodiu o asteroid");
                [self explosaoMeteoro : outro];
                [outro removeFromParent];
                [balas removeObject:outro];
                hitsAsteroid = 0;
            }
            else {
                [outro removeFromParent];
                [balas removeObject:outro];
                hitsAsteroid++;
                NSLog(@"Somou asteroid");
            }
        }
        }
    }];
}


- (void)checkCollisionsMunicao:(NSString *)objeto andOther : (SKSpriteNode *) outro {
    
    [self enumerateChildNodesWithName:objeto
                           usingBlock:^(SKNode *node, BOOL *stop){
                               SKSpriteNode *enemy = (SKSpriteNode *)node;
                               CGRect smallerFrame = CGRectInset(enemy.frame, 0, 0);
                               
                               // se ocorrer a colisão, o obstaculo é removido, e ação de som da colisão.
    if (CGRectIntersectsRect(smallerFrame, outro.frame)) {
        
        
        [self playMunicao:@"pegouBala.mp3" volume:1];
        [enemy removeFromParent];
        
        quantidadeTiros += 15;
        
        }
    }];
    
}

- (void)checkCollisionsAstronauta:(NSString *)objeto andOther : (SKSpriteNode *) outro {
    

    
    [self enumerateChildNodesWithName:objeto
                           usingBlock:^(SKNode *node, BOOL *stop){
    SKSpriteNode *enemy = (SKSpriteNode *)node;
    CGRect smallerFrame = CGRectInset(enemy.frame, 0, 0);
                               
  if (CGRectIntersectsRect(smallerFrame, outro.frame)) {
      morreu = 1;
      [self morteAstronauta:outro];
      [enemy removeFromParent];
                               }
                               
    }];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint ate = CGPointMake(astr.position.x, astr.position.y+1);
    CGPoint touchLocation = [touch locationInNode:self];
    SKNode * node = [self nodeAtPoint:touchLocation];

    
    if([node.name isEqualToString:@"pause"]){
        
        SKAction *aparece = [SKAction runBlock:^{ [self iniciar:1]; self.scene.view.paused = YES;
            pausado = YES; [_backgroundMusicPlayer1 stop];
            
        }];
        
        [_pause runAction:aparece];
    
    }
    
    else if ([node.name isEqualToString:@"play2"]){
        [self iniciar:2];
        
        
        [_backgroundMusicPlayer1 play];
        
        pausado = NO;
        self.scene.view.paused = NO;
        
    }
    if (![node.name isEqualToString:@"pause"] && ![node.name isEqualToString:@"play2"]) {
    
    if (pausado == NO) {
        
    if(!pulando && touchLocation.x > self.size.width/2)
        [self moveAteh:ate];
    if(touchLocation.x < self.size.width/2){
        if(quantidadeTiros > 0 ){
            [self atira];
            quantidadeTiros--;
            
        }
    }
    }
}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

}


@end
