//
//  GGCustomAgentVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-9.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCustomAgentVC.h"
#import "GGKeywordExampleCell.h"
#import "GGAgent.h"

@interface GGCustomAgentVC ()
@property (weak, nonatomic) IBOutlet UITextField *fdName;
//@property (weak, nonatomic) IBOutlet UITextField *fdKeywords;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet GGKeywordExampleCell *keywordExampleView;
@property (weak, nonatomic) IBOutlet UIScrollView *viewScroll;
@property (weak, nonatomic) IBOutlet UITextView *texvKeywords;

@end

@implementation GGCustomAgentVC
//{
//    GGKeywordExampleCell        *_keywordExampleView;
//}

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
    self.view.backgroundColor = GGSharedColor.silver;
    
    CGRect keywordRc = _keywordExampleView.frame;
    [_keywordExampleView removeFromSuperview];
    _keywordExampleView = [GGKeywordExampleCell viewFromNibWithOwner:self];
    _keywordExampleView.frame = keywordRc;
    [self.viewScroll addSubview:_keywordExampleView];
    float maxScrollY = CGRectGetMaxY(_keywordExampleView.frame);
    self.viewScroll.contentSize = CGSizeMake(self.viewScroll.contentSize.width, maxScrollY);
    self.viewScroll.showsVerticalScrollIndicator = NO;
    
    if (_agent) {
        [_btnAdd setTitle:@"Edit" forState:UIControlStateNormal];
        self.naviTitle = @"Edit Custom Agent";
        self.fdName.text = _agent.name;
        self.texvKeywords.text = _agent.keywords;
    } else {
        self.naviTitle = @"Add Custom Agent";
    }
    
}


- (void)viewDidUnload {
    [self setFdName:nil];
    //[self setFdKeywords:nil];
    [self setBtnAdd:nil];
    [self setKeywordExampleView:nil];
    [self setViewScroll:nil];
    [self setTexvKeywords:nil];
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
    else if (self.texvKeywords.text.length <= 0)
    {
        [GGAlert alert:@"You need to enter a keywords for the agent."];
    }
    else
    {
        
        if (_agent)
        {
            [GGSharedAPI updateCustomAgentWithID:_agent.ID name:self.fdName.text keywords:self.texvKeywords.text callback:^(id operation,
                                                                                                                         id aResultObject, NSError *anError) {
                
                GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                if (parser.isOK)
                {
                    //[GGAlert alert:@"Success!"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [GGAlert alert:parser.message];
                }
            }];
        }
        else
        {
            [GGSharedAPI addCustomAgentWithName:self.fdName.text keywords:self.texvKeywords.text callback:^(id operation, id aResultObject, NSError *anError) {
                
                GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
                if (parser.isOK)
                {
                    //[GGAlert alert:@"Success!"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [GGAlert alert:parser.message];
                }
                
            }];
        }
    }
}

@end
