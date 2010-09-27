//
//  gmp_calcAppDelegate.m
//  gmp-calc
//
//  Created by Feldmaus on 18.09.10.
//  Copyright 2010 ischlecken.com. All rights reserved.
//

#import "gmp_calcAppDelegate.h"

@implementation gmp_calcAppDelegate

@synthesize window;
@synthesize operandA;
@synthesize operandB;
@synthesize operandC;
@synthesize operatorMatrix;

/**
 *
 */
-(void) dealloc
{ [calculator release];
  
  [super dealloc];
}

/**
 *
 */
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{ calculator      = [[Calculator alloc] init];
  validOperations = [[NSMutableArray alloc] init];
  calcOperation   = @selector( add );
  
  NSBundle* main = [NSBundle mainBundle];
  NSString* prefix = @"button.";
  
  NSArray* cells = [operatorMatrix cells];
  id       ctl   = nil;
  int      tag   = 0;
  
  for( ctl in cells )
  {
    NSLog(@"ctl.class=%@\n",[ctl class]);
    
    if( [ctl isKindOfClass: [NSButtonCell class]] ) 
    { NSButtonCell* c     = (NSButtonCell*)ctl;
      
      NSString*     title = [c title];
      
      NSLog(@"title=%@\n",title);  

      NSString* key = [prefix stringByAppendingString:title];
      
      [c setTitle: [main localizedStringForKey:key value:title table:@"gmp-calc"]];
      
      SEL op = NSSelectorFromString( title );
      
      if ( op!=nil && [calculator respondsToSelector:op] )
      { NSLog(@"add operation %@ at %d\n",title,tag);  

        [validOperations addObject:title];
        
        [c setTag:tag];
        
        tag++;        
      } // of if
      else
        [c setEnabled:false];
      
    }
  } // of for
  
}

/**
 *
 */
-(IBAction) calcResult:(id)sender
{ if( calcOperation!=nil ) 
  { NSString* opA = [operandA stringValue];
    NSString* opB = [operandB stringValue];

    [calculator setOperandA:opA];
    [calculator setOperandB:opB];
    [calculator performSelector:calcOperation];
    
    [operandC setStringValue: [calculator operandC]];
  } // of if
}

/**
 *
 */
-(IBAction) setOperation:(id)sender
{ int tag = [sender selectedTag];
  
  if( tag!=-1 )
  { NSString* opStr = [validOperations objectAtIndex:tag];
    SEL       op    = NSSelectorFromString( opStr );
    
    if ( op!=nil && [calculator respondsToSelector:op] )
      calcOperation = op;
    
    NSLog(@"setOperation(%@):%d\n",opStr,calcOperation);
    
    [self calcResult:sender];
  }
}
@end
