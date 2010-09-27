//
//  gmp_calcAppDelegate.h
//  gmp-calc
//
//  Created by Feldmaus on 18.09.10.
//  Copyright 2010 ischlecken.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Calculator.h"

@interface gmp_calcAppDelegate : NSObject <NSApplicationDelegate> 
{
  NSWindow*       window;
  NSMatrix*       operatorMatrix;
  
  Calculator*     calculator;
  SEL             calcOperation;
  NSMutableArray* validOperations;
}

@property (assign) IBOutlet NSWindow*    window;

@property (assign) IBOutlet NSTextField* operandA;
@property (assign) IBOutlet NSTextField* operandB;
@property (assign) IBOutlet NSTextField* operandC;

@property (assign) IBOutlet NSMatrix*    operatorMatrix;

-(IBAction) setOperation:(id)sender;
-(IBAction) calcResult:(id)sender;

@end
