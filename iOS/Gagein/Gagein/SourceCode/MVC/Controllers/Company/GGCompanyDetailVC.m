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

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *ivLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblWebsite;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;

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

- (void)viewDidUnload {
    [self setIvLogo:nil];
    [self setLblName:nil];
    [self setLblWebsite:nil];
    [self setBtnFollow:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

#pragma mark - API calls
-(void)_getOverView
{
    [GGSharedAPI getCompanyOverviewWithID:_companyID needSocialProfile:YES callback:^(id operation, id aResultObject, NSError *anError) {
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        _companyOverview = [parser parseGetCompanyOverview];
        [self _updateUiOverview];
    }];
}

#pragma mark - UI update
-(void)_updateUiOverview
{
    NSURL *url = [NSURL URLWithString:_companyOverview.logoPath];
//    NSURL *url = [NSURL URLWithString:@"http://gageincn.dyndns.org:3031/images/buzDefaultLogoBig.png"];
//    [self.ivLogo setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//        DLog(@"%@", image);
//        //[self.ivLogo removeFromSuperview];
//        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
//        [self.view addSubview:iv];
//    }];
    [self.ivLogo setImageWithURL:url placeholderImage:nil];
    self.lblName.text = _companyOverview.name;
    self.lblWebsite.text = _companyOverview.website;
}
@end
