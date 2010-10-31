//
//  FirstViewController.h
//  icalc
//
//  Created by Feldmaus on 23.10.10.
//  Copyright ischlecken.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Calculator.h"

@interface FirstViewController : UIViewController 
{
  Calculator*     calculator;
  SEL             calcOperation;
  NSMutableArray* validOperations;
  
  UITextField*    operandA;
  UITextField*    operandB;
  UITextField*    operandC;
  
}

@property (nonatomic, retain) IBOutlet UITextField* operandA;
@property (nonatomic, retain) IBOutlet UITextField* operandB;
@property (nonatomic, retain) IBOutlet UITextField* operandC;

-(IBAction) setOperation:(id)sender;
-(IBAction) calcResult:(id)sender;

@end
