//
//  GGPersonDetailVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-26.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGPersonDetailVC.h"

@interface GGPersonDetailVC ()

@end

@implementation GGPersonDetailVC

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
    
    [self _callApiGetPersonOverview];
}

#pragma mark - API calls
-(void)_callApiGetPersonOverview
{
    [GGSharedAPI getPersonOverviewWithID:_personID callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser * parser = [GGApiParser parserWithApiData:aResultObject];
    }];
}

@end
