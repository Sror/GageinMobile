//
//  GGCompanyDetailVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyDetailVC.h"
#import "GGCompany.h"

@interface GGCompanyDetailVC ()

@end

@implementation GGCompanyDetailVC
{
    GGCompany *_companyOverview;
}

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
    self.title = @"Company";
    
    [self _getOverView];
}

-(void)_getOverView
{
    [GGSharedAPI getCompanyOverviewWithID:_companyID needSocialProfile:YES callback:^(id operation, id aResultObject, NSError *anError) {
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        _companyOverview = [parser parseGetCompanyOverview];
        
    }];
}

@end
