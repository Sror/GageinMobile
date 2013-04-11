//
//  GGCustomAgentVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-9.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCustomAgentVC.h"

@interface GGCustomAgentVC ()
@property (weak, nonatomic) IBOutlet UITextField *fdName;
@property (weak, nonatomic) IBOutlet UITextField *fdKeywords;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

@end

@implementation GGCustomAgentVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidUnload {
    [self setFdName:nil];
    [self setFdKeywords:nil];
    [self setBtnAdd:nil];
    [super viewDidUnload];
}

#pragma mark - actions
-(IBAction)addCustomAgentAction:(id)sender
{
    [self _callAddCustomAgent];
}

#pragma mark - API calls
-(void)_callAddCustomAgent
{
    if (self.fdName.text.length <= 0)
    {
        [GGAlert alert:@"You need to enter a name for the agent."];
    }
    else if (self.fdKeywords.text.length <= 0)
    {
        [GGAlert alert:@"You need to enter a keywords for the agent."];
    }
    else
    {
        [GGSharedAPI addCustomAgentWithName:self.fdName.text keywords:self.fdKeywords.text callback:^(id operation, id aResultObject, NSError *anError) {
            
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                [GGAlert alert:@"Success!"];
            }
            else
            {
                [GGAlert alert:parser.message];
            }
            
        }];
    }
}

@end
