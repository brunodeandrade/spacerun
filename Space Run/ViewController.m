//
//  ViewController.m
//  Space Run
//
//  Created by Bruno Rodrigues de Andrade on 28/05/14.
//  Copyright (c) 2014 Bruno Rodrigues de Andrade. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "Inicio.h"


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    
    NSLog(@"Opaaaaaaa");
    
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [Inicio sceneWithSize:skView.bounds.size];
    //scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    if(!skView.scene){
        NSLog(@"Sai do Inicio");
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        //Criar e configurar cena
        //SKScene *scene = [Inicio sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
        
    }
    
}
//Codigos adicionados--inicio--

-(BOOL)prefersStatusBarHidden{
    return YES;
}

//Fim--fim--



- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
