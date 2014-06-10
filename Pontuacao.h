//
//  Pontuacao.h
//  Space Run
//
//  Created by Bruno Rodrigues de Andrade on 10/06/14.
//  Copyright (c) 2014 Bruno Rodrigues de Andrade. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static int scoreAtual;

@interface Pontuacao : SKScene

+(void) setScore:(float) score;
+(float) getScore;


@end
