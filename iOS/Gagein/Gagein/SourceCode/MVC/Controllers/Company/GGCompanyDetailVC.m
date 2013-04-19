//
//  GGCompanyDetailVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyDetailVC.h"
#import "GGCompany.h"

#import "GGCompanyDetailOverviewCell.h"
#import "GGCompanyDetailHeaderView.h"

@interface GGCompanyDetailVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *ivLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblWebsite;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UIView *viewBaseInfo;

@end

@implementation GGCompanyDetailVC
{
    GGCompany   *_companyOverview;
    UITableView *_tvDetail;
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
    self.navigationItem.title = @"";
    
    _tvDetail = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tvDetail.delegate = self;
    _tvDetail.dataSource = self;
    _tvDetail.tableHeaderView = self.viewBaseInfo;
    _tvDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.viewBaseInfo.backgroundColor = GGSharedColor.ironGray;
    _tvDetail.backgroundColor = GGSharedColor.ironGray;
    [self.view addSubview:_tvDetail];
    
    [self _getOverView];
}

- (void)viewDidUnload {
    [self setIvLogo:nil];
    [self setLblName:nil];
    [self setLblWebsite:nil];
    [self setBtnFollow:nil];
    [self setScrollView:nil];
    [self setViewBaseInfo:nil];
    [super viewDidUnload];
}

#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 3;
    } else if (section == 3) {
        return 3;
    } else if (section == 4) {
        return 3;
    } else if (section == 5) {
        return 4;
    } 
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    if (section == 0) {
        GGCompanyDetailOverviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGCompanyDetailOverviewCell"];
        if (!cell) {
            cell = [GGCompanyDetailOverviewCell viewFromNibWithOwner:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.lblIndustry.text = @"Computer software";
        cell.lblDescription.text = @"asdjhaskdhakshdkashdkashdkjhaskjdhkhkahdalioeoiqoiewurqpourevskjghsakhfdakfldhfkasjfhdk";
        cell.lblAddress.text = @"Silicon Vally, CA";
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    cell.backgroundColor = GGSharedColor.white;
    return cell;
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    if (section == 0) {
        return [GGCompanyDetailOverviewCell HEIGHT];
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [GGCompanyDetailHeaderView HEIGHT];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GGCompanyDetailHeaderView *header = [GGCompanyDetailHeaderView viewFromNibWithOwner:self];
    
    if (section == 0) {
        header.lblTitle.text = @"OVERVIEW";
        header.lblAction.hidden = YES;
    } else if (section == 1) {
        header.lblTitle.text = @"UPDATES";
    } else if (section == 2) {
        header.lblTitle.text = @"HAPPENINGS";
    } else if (section == 3) {
        header.lblTitle.text = @"EMPLOYEES";
    } else if (section == 4) {
        header.lblTitle.text = @"SIMILAR COMPANIES";
    } else if (section == 5) {
        header.lblTitle.text = @"LINKED PROFILES";
    }
    
    return header;
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
    self.navigationItem.title = _companyOverview.name;
    self.lblWebsite.text = _companyOverview.website;
    [self _updateUiBtnFollow];
}

-(void)_updateUiBtnFollow
{
    if (_companyOverview.followed)
    {
        [self.btnFollow setTitle:@"following" forState:UIControlStateNormal];
    }
    else
    {
        [self.btnFollow setTitle:@"follow" forState:UIControlStateNormal];
    }
}

#pragma mark - actions
-(IBAction)followCompanyAction:(id)sender
{
    if (_companyOverview.followed)
    {
        // show action sheet
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"unfollow", nil];
        [sheet showFromTabBar:self.tabBarController.tabBar];
    }
    else
    {
        [GGSharedAPI followCompanyWithID:_companyOverview.ID callback:^(id operation, id aResultObject, NSError *anError) {
            
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.status == 1) {
                _companyOverview.followed = 1;
                [self _updateUiBtnFollow];
            }
            
        }];
    }
}

#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLog(@"action sheet index:%d", buttonIndex);
    if (buttonIndex == 0)
    {
        [GGSharedAPI unfollowCompanyWithID:_companyOverview.ID callback:^(id operation, id aResultObject, NSError *anError) {
            
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.status == 1) {
                _companyOverview.followed = 0;
                [self _updateUiBtnFollow];
            }
        }];
    }
}

@end
