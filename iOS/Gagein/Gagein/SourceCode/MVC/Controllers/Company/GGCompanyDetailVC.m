//
//  GGCompanyDetailVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGCompanyDetailVC.h"

#import "GGCompany.h"
#import "GGDataPage.h"
#import "GGCompanyUpdate.h"
#import "GGCompanyHappening.h"
#import "GGPerson.h"
#import "GGSocialProfile.h"

#import "GGCompanyDetailOverviewCell.h"
#import "GGCompanyDetailHeaderView.h"
#import "GGCompanyDetailUpdateCell.h"
#import "GGComDetailEmployeeCell.h"
#import "GGComDetailProfileCell.h"

#import "GGWebVC.h"
#import "GGUpdatesVC.h"
#import "GGHappeningsVC.h"
#import "GGCompanyEmployeesVC.h"
#import "GGSimilarCompaniesVC.h"
#import "GGComOverviewDetailVC.h"

typedef enum
{
    kGGSectionOverview = 0
    , kGGSectionUpdates
    , kGGSectionHappenings
    , kGGSectionEmployees
    , kGGSectionSimilarCompanies
    , kGGSectionLinkedProfiles
    , kGGSectionCount
}EGGComDetailSection;

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
    GGCompany           *_companyOverview;
    UITableView         *_tvDetail;
    
    NSMutableArray      *_updates;
    NSMutableArray      *_happenings;
    NSMutableArray      *_people;
    NSMutableArray      *_similarCompanies;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _updates = [NSMutableArray array];
        _happenings = [NSMutableArray array];
        _people = [NSMutableArray array];
        _similarCompanies = [NSMutableArray array];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.naviTitle = @"";
    self.lblName.text = @"";
    self.lblWebsite.text = @"";
    self.ivLogo.layer.borderWidth = 1.f;
    self.ivLogo.layer.borderColor = GGSharedColor.silver.CGColor;
    self.ivLogo.layer.cornerRadius = 3.f;
    
    //
    _tvDetail = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tvDetail.delegate = self;
    _tvDetail.dataSource = self;
    _tvDetail.tableHeaderView = self.viewBaseInfo;
    _tvDetail.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tvDetail.separatorColor = GGSharedColor.silver;
    self.viewBaseInfo.backgroundColor = GGSharedColor.ironGray;
    _tvDetail.backgroundColor = GGSharedColor.ironGray;
    [self.view addSubview:_tvDetail];
    
    UIView *tvBgView = [[UIView alloc] initWithFrame:CGRectZero];
    tvBgView.backgroundColor = GGSharedColor.silver;
    _tvDetail.backgroundView = tvBgView;
    
    //
    [self _callApiGetOverView];
    [self _callApiGetUpdates];
    [self _callApiGetHappenings];
    [self _callApiGetPeople];
    [self _callApiGetSimilarCompanies];
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
    return kGGSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kGGSectionOverview) {
        return 1;
    } else if (section == kGGSectionUpdates) {
        return _updates.count;
    } else if (section == kGGSectionHappenings) {
        return _happenings.count;
    } else if (section == kGGSectionEmployees) {
        return _people.count;
    } else if (section == kGGSectionSimilarCompanies) {
        return _similarCompanies.count;
    } else if (section == kGGSectionLinkedProfiles) {
        return _companyOverview.socialProfiles.count;
    } 
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    
    if (section == kGGSectionOverview) {
        GGCompanyDetailOverviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGCompanyDetailOverviewCell"];
        if (!cell) {
            cell = [GGCompanyDetailOverviewCell viewFromNibWithOwner:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.lblIndustry.text = _companyOverview.industries;
        cell.lblDescription.text = _companyOverview.description;
        cell.lblAddress.text = _companyOverview.address;
        
        return cell;
        
    } else if (section == kGGSectionUpdates) {  // update cell
        
        GGCompanyDetailUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGCompanyDetailUpdateCell"];
        if (!cell) {
            cell = [GGCompanyDetailUpdateCell viewFromNibWithOwner:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GGCompanyUpdate *data = _updates[row];
        
        cell.lblSource.text = data.fromSource;
        cell.lblInterval.text = [data intervalStringWithDate:data.date];//@"1d ago";
        cell.lblHeadLine.text = data.headline;
        
        return cell;
        
    } else if (section == kGGSectionHappenings) { // happening cell
        
        GGCompanyDetailUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGCompanyDetailUpdateCell"];
        if (!cell) {
            cell = [GGCompanyDetailUpdateCell viewFromNibWithOwner:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GGCompanyHappening *data = _happenings[row];
        
        cell.lblSource.text = data.sourceText;
        cell.lblInterval.text = [data intervalStringWithDate:data.timestamp];
        cell.lblHeadLine.text = data.headLineText;
        
        return cell;
        
    } else if (section == kGGSectionEmployees) {
        
        GGComDetailEmployeeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGComDetailEmployeeCell"];
        if (!cell) {
            cell = [GGComDetailEmployeeCell viewFromNibWithOwner:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GGPerson *data = _people[row];
        
        cell.lblTitle.text = data.name;
        cell.lblSubTitle.text = data.orgTitle;
        [cell.ivPhoto setImageWithURL:[NSURL URLWithString:data.photoPath] placeholderImage:GGSharedImagePool.placeholder];
        
        return cell;
        
    } else if (section == kGGSectionSimilarCompanies) {
        
        GGComDetailEmployeeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGComDetailEmployeeCell"];
        if (!cell) {
            cell = [GGComDetailEmployeeCell viewFromNibWithOwner:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GGCompany *data = _similarCompanies[row];
        
        cell.lblTitle.text = data.name;
        cell.lblSubTitle.text = data.website;
        [cell.ivPhoto setImageWithURL:[NSURL URLWithString:data.logoPath] placeholderImage:GGSharedImagePool.placeholder];
        
        return cell;
        
    } else if (section == kGGSectionLinkedProfiles) {
        
        GGComDetailProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGComDetailProfileCell"];
        if (!cell) {
            cell = [GGComDetailProfileCell viewFromNibWithOwner:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GGSocialProfile *data = _companyOverview.socialProfiles[row];
        
        cell.lblTitle.text = data.type;
        
        return cell;
    }

    return nil;
}



#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    
    if (section == kGGSectionOverview) {
       
        GGComOverviewDetailVC *vc = [[GGComOverviewDetailVC alloc] init];
        vc.overview = _companyOverview;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (section == kGGSectionUpdates) {

    } else if (section == kGGSectionHappenings) {

    } else if (section == kGGSectionEmployees) {

    } else if (section == kGGSectionSimilarCompanies) {
        
        GGCompany *data = _similarCompanies[row];
        GGCompanyDetailVC *vc = [[GGCompanyDetailVC alloc] init];
        vc.companyID = data.ID;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (section == kGGSectionLinkedProfiles) {
        
        GGSocialProfile *data = _companyOverview.socialProfiles[row];
        GGWebVC *vc = [[GGWebVC alloc] init];
        vc.urlStr = data.url;
        vc.naviTitle = self.naviTitle;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    
    if (section == kGGSectionOverview) {
        
        return [GGCompanyDetailOverviewCell HEIGHT];
        
    } else if (section == kGGSectionUpdates) {
        
        return [GGCompanyDetailUpdateCell HEIGHT];
        
    } else if (section == kGGSectionHappenings) {
        
        return [GGCompanyDetailUpdateCell HEIGHT];
        
    } else if (section == kGGSectionEmployees) {
    
        return [GGComDetailEmployeeCell HEIGHT];
        
    } else if (section == kGGSectionSimilarCompanies) {
        
        return [GGComDetailEmployeeCell HEIGHT];
        
    } else if (section == kGGSectionLinkedProfiles) {
        
        return [GGComDetailProfileCell HEIGHT];
        
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == kGGSectionUpdates && _updates.count <= 0) {
        
        return 0.f;
        
    } else if (section == kGGSectionHappenings && _happenings.count <= 0) {
        
        return 0.f;
        
    } else if (section == kGGSectionEmployees && _people.count <= 0) {
        
        return 0.f;
        
    } else if (section == kGGSectionSimilarCompanies && _similarCompanies.count <= 0) {
        
        return 0.f;
        
    } else if (section == kGGSectionLinkedProfiles && _companyOverview.socialProfiles.count <= 0) {
        
        return 0.f;
        
    }
    
    return [GGCompanyDetailHeaderView HEIGHT];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GGCompanyDetailHeaderView *header = [GGCompanyDetailHeaderView viewFromNibWithOwner:self];
    
    if (section == kGGSectionOverview) {
        
        header.lblTitle.text = @"OVERVIEW";
        header.lblAction.hidden = YES;
        
    } else if (section == kGGSectionUpdates) {
        
        header.lblTitle.text = @"UPDATES";
        //header.lblAction.hidden = (_updates.count <= 0);
        [header.lblAction addTarget:self action:@selector(_seeAllUpdatesAction:) forControlEvents:UIControlEventTouchUpInside];
        
    } else if (section == kGGSectionHappenings) {
        
        header.lblTitle.text = @"HAPPENINGS";
        //header.lblAction.hidden = (_happenings.count <= 0);
        [header.lblAction addTarget:self action:@selector(_seeAllHappeningsAction:) forControlEvents:UIControlEventTouchUpInside];
        
    } else if (section == kGGSectionEmployees) {
        
        header.lblTitle.text = @"EMPLOYEES";
        //header.lblAction.hidden = (_people.count <= 0);
        [header.lblAction addTarget:self action:@selector(_seeAllEmployeesAction:) forControlEvents:UIControlEventTouchUpInside];
        
    } else if (section == kGGSectionSimilarCompanies) {
        
        header.lblTitle.text = @"SIMILAR COMPANIES";
        //header.lblAction.hidden = (_similarCompanies.count <= 0);
        [header.lblAction addTarget:self action:@selector(_seeAllSimilarCompaniesAction:) forControlEvents:UIControlEventTouchUpInside];
        
    } else if (section == kGGSectionLinkedProfiles) {
        
        header.lblTitle.text = @"LINKED PROFILES";
        header.lblAction.hidden = YES;
    }
    
    return header;
}

#pragma mark - see all
-(void)_seeAllUpdatesAction:(id)sender
{
    GGUpdatesVC *vc = [[GGUpdatesVC alloc] init];
    vc.updates = _updates;
    vc.companyID = _companyID;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)_seeAllHappeningsAction:(id)sender
{
    GGHappeningsVC *vc = [[GGHappeningsVC alloc] init];
    vc.happenings = _happenings;
    vc.companyID = _companyID;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)_seeAllEmployeesAction:(id)sender
{
    GGCompanyEmployeesVC *vc = [[GGCompanyEmployeesVC alloc] init];
    vc.employees = _people;
    vc.companyID = _companyID;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)_seeAllSimilarCompaniesAction:(id)sender
{
    GGSimilarCompaniesVC *vc = [[GGSimilarCompaniesVC alloc] init];
    vc.similarCompanies = _similarCompanies;
    vc.companyID = _companyID;
    
    [self.navigationController pushViewController:vc animated:YES];
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
    [self.ivLogo setImageWithURL:url placeholderImage:GGSharedImagePool.placeholder];
    self.naviTitle = _companyOverview.name;
    self.lblWebsite.text = _companyOverview.website;
    [self _updateUiBtnFollow];
    
    [_tvDetail reloadData];
    //[_tvDetail reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    //[_tvDetail reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationAutomatic];
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
            else
            {
                [GGAlert alert:parser.message];
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

#pragma mark - API calls
-(void)_callApiGetOverView
{
    [self showLoadingHUD];
    [GGSharedAPI getCompanyOverviewWithID:_companyID needSocialProfile:YES callback:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        _companyOverview = [parser parseGetCompanyOverview];
        [self _updateUiOverview];
    }];
}

-(NSArray *)_getArray:(NSArray *)anArray maxCount:(NSUInteger)aIndex
{
    NSMutableArray *returnedArray = nil;
    
    if (anArray.count && aIndex)
    {
        int count = 0;
        returnedArray = [NSMutableArray array];
        for (id item in anArray)
        {
            [returnedArray addObject:item];
            count++;
            if (count > aIndex - 1)
            {
                break;
            }
        }
    }
    
    return returnedArray;
}

-(void)_callApiGetUpdates
{
    GGApiBlock callback = ^(id operation, id aResultObject, NSError* anError) {
        //DLog(@"%@", aResultObject);
        
        //[self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        GGDataPage *page = [parser parseGetCompanyUpdates];
        //DLog(@"%@", page);
        
        [_updates removeAllObjects];
        [_updates addObjectsFromArray:[self _getArray:page.items maxCount:3]];
        
        [_tvDetail reloadSections:[NSIndexSet indexSetWithIndex:kGGSectionUpdates] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    
    [GGSharedAPI getCompanyUpdatesWithCompanyID:_companyID newsID:0 pageFlag:kGGPageFlagFirstPage pageTime:0 relevance:kGGCompanyUpdateRelevanceNormal callback:callback];

}

-(void)_callApiGetHappenings
{
    GGApiBlock callback = ^(id operation, id aResultObject, NSError* anError) {
        //DLog(@"%@", aResultObject);
        
        //[self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        GGDataPage *page = [parser parseGetCompanyHappenings];
        //DLog(@"%@", page);
        
        [_happenings removeAllObjects];
        [_happenings addObjectsFromArray:[self _getArray:page.items maxCount:3]];
        
        [_tvDetail reloadSections:[NSIndexSet indexSetWithIndex:kGGSectionHappenings] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    
    [GGSharedAPI getHappeningsWithCompanyID:_companyID pageFlag:kGGPageFlagFirstPage pageTime:0 callback:callback];
}

-(void)_callApiGetPeople
{
    [GGSharedAPI getCompanyPeopleWithOrgID:_companyID pageNumber:0 callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            GGDataPage *page = [parser parseGetCompanyPeople];
            
            [_people removeAllObjects];
            [_people addObjectsFromArray:[self _getArray:page.items maxCount:3]];
            
            [_tvDetail reloadSections:[NSIndexSet indexSetWithIndex:kGGSectionEmployees] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

-(void)_callApiGetSimilarCompanies
{
    [GGSharedAPI getSimilarCompaniesWithOrgID:_companyID pageNumber:0 callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            GGDataPage *page = [parser parseGetSimilarCompanies];
            
            [_similarCompanies removeAllObjects];
            [_similarCompanies addObjectsFromArray:[self _getArray:page.items maxCount:3]];
            
            [_tvDetail reloadSections:[NSIndexSet indexSetWithIndex:kGGSectionSimilarCompanies] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

@end
