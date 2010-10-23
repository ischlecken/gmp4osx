//
//  FirstViewController.m
//  icalc
//
//  Created by Feldmaus on 23.10.10.
//  Copyright ischlecken.com 2010. All rights reserved.
//

#import "FirstViewController.h"


@implementation FirstViewController

@synthesize operandA;
@synthesize operandB;
@synthesize operandC;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{ [super viewDidLoad];
  
  calculator      = [[Calculator alloc] init];
  validOperations = [[NSMutableArray alloc] init];
  calcOperation   = @selector( add );
  
  NSBundle* main = [NSBundle mainBundle];
  NSString* prefix = @"button.";
  
  NSArray* cells = [[self view]subviews];
  id       ctl   = nil;
  int      tag   = 0;
  
  for( ctl in cells )
  {
    NSLog(@"ctl.class=%@\n",[ctl class]);
    
    if( [ctl isKindOfClass: [UIButton class]] ) 
    { UIButton* c     = (UIButton*)ctl;
      NSString* title = [c currentTitle];
      
      NSLog(@"title=%@\n",title);  
      
      NSString* key = [prefix stringByAppendingString:title];
      
      [c setTitle: [main localizedStringForKey:key value:title table:@"icalc"] forState:UIControlStateNormal];
      
      SEL op = NSSelectorFromString( title );
      
      if ( op!=nil && [calculator respondsToSelector:op] )
      { NSLog(@"add operation %@ at %d\n",title,tag);  
        
        [validOperations addObject:title];
        
        [c setTag:tag];
        
        tag++;        
      } // of if
      else
        [c setEnabled:false];
    } // of if
  } // of for  
} // of viewDidLoad()


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return YES;
}


- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
  [calculator release];
  [super dealloc];
}

/**
 *
 */
-(IBAction) calcResult:(id)sender
{ if( calcOperation!=nil ) 
  { NSString* opA = [operandA text];
    NSString* opB = [operandB text];
  
    [calculator setOperandA:opA];
    [calculator setOperandB:opB];
    [calculator performSelector:calcOperation];
  
    [operandC setText: [calculator operandC]];
  } // of if
}

/**
 *
 */
-(IBAction) setOperation:(id)sender
{ int tag = [sender tag];
  
  if( tag!=-1 )
  { NSString* opStr = [validOperations objectAtIndex:tag];
    SEL       op    = NSSelectorFromString( opStr );
    
    if ( op!=nil && [calculator respondsToSelector:op] )
      calcOperation = op;
    
    NSLog(@"setOperation(%@):%d\n",opStr,calcOperation);
    
    [self calcResult:sender];
  }
}

- (BOOL)textFieldShouldReturn:(UITextField *)doneButtonPressed 
{
	NSLog(@"Keyboard Done Pressed");
	
	[doneButtonPressed resignFirstResponder];
  
  [self calcResult:doneButtonPressed];
  
	return YES;
}

@end
