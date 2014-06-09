//
//  Persistence.m
//  Space Run
//
//  Created by Henrique Santos on 09/06/14.
//  Copyright (c) 2014 Bruno Rodrigues de Andrade. All rights reserved.
//

#import "Persistence.h"

@implementation Persistence

-(void)gravaRecord:(float)pontos{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"record.txt"];
    NSString *score = [NSString stringWithFormat:@"%.2f",pontos];
    NSLog(@"Gravando %.2f",pontos);
    
    float pontuacao = pontuacao = [self leRecord];
    
    if (pontos > pontuacao){
        [score writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
    }
}



-(float) leRecord{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"record.txt"];
    NSString *record = [NSString stringWithContentsOfFile: filePath encoding:NSUTF8StringEncoding error:NULL];
    
    return [record floatValue];
    
}

@end
