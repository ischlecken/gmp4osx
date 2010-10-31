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
  NSTextField*    operandA;
  NSTextField*    operandB;
  NSTextField*    operandC;
  
  Calculator*     calculator;
  SEL             calcOperation;
  NSMutableArray* validOperations;
}

@property (retain) IBOutlet NSWindow*    window;

@property (retain) IBOutlet NSTextField* operandA;
@property (retain) IBOutlet NSTextField* operandB;
@property (retain) IBOutlet NSTextField* operandC;

@property (retain) IBOutlet NSMatrix*    operatorMatrix;

-(IBAction) setOperation:(id)sender;
-(IBAction) calcResult:(id)sender;

@end
