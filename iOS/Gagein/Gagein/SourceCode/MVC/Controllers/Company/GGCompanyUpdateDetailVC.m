//
//  GGCompanyUpdateDetailVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyUpdateDetailVC.h"

@interface GGCompanyUpdateDetailVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;

@end

@implementation GGCompanyUpdateDetailVC

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
    
    [self _callApiGetCompanyUpdateDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setLblTitle:nil];
    [self setIvPhoto:nil];
    [super viewDidUnload];
}

#pragma mark - API calls
-(void)_callApiGetCompanyUpdateDetail
{
    [GGSharedAPI getCompanyUpdateDetailWithNewsID:self.newsID callback:^(id operation, id aResultObject, NSError *anError) {
        //
    }];
}

@end
