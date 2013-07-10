//
//  GGPersonDetailVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-26.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGPersonDetailVC.h"

#import "GGPerson.h"
#import "GGCompanyDetailUpdateCell.h"
#import "GGHappening.h"
#import "GGComDetailProfileCell.h"
#import "GGSocialProfile.h"
#import "GGWebVC.h"
#import "GGCompanyDetailHeaderView.h"
#import "GGHappeningsVC.h"
#import "GGDataPage.h"
#import "GGHappeningDetailVC.h"
#import "GGComDetailEmployeeCell.h"
#import "GGCompanyDetailVC.h"
#import "GGEmployerComsVC.h"

//
typedef enum
{
    kGGSectionUpdates = 0
    , kGGSectionPrevCompanies
    , kGGSectionSocialProfiles
    , kGGSectionCount
}EGGPersonDetailSection;



//
@interface GGPersonDetailVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *svContent;
@property (weak, nonatomic) IBOutlet UIView *viewBaseInfo;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;

@end

@implementation GGPersonDetailVC
{
    GGPerson    *_personOverview;
    
    UITableView         *_tvDetail;
    
    NSMutableArray      *_updates;  // people updates is actually happenings
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _updates = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.naviTitle = @"";
    self.lblTitle.text = @"";
    self.lblAddress.text = @"";
    [_ivPhoto applyEffectCircleSilverBorder];
    
    [self.btnFollow setBackgroundImage:[[UIImage imageNamed:@"btnYellowBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 20, 10)] forState:UIControlStateNormal];
    
    [self.btnFollow setBackgroundImage:[[UIImage imageNamed:@"grayBtnBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 30, 10)] forState:UIControlStateSelected];
    
    //
    _tvDetail = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tvDetail.delegate = self;
    _tvDetail.dataSource = self;
    _tvDetail.tableHeaderView = self.viewBaseInfo;
    _tvDetail.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tvDetail.separatorColor = GGSharedColor.silver;
    self.viewBaseInfo.backgroundColor = GGSharedColor.ironGray;
    _tvDetail.backgroundColor = GGSharedColor.ironGray;
    
    _tvDetail.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tvDetail];
    
    UIView *tvBgView = [[UIView alloc] initWithFrame:CGRectZero];
    tvBgView.backgroundColor = GGSharedColor.silver;
    _tvDetail.backgroundView = tvBgView;
    
    _tvDetail.showsVerticalScrollIndicator = NO;
    
    [self _callApiGetPersonOverview];
    [self _callApiGetHappenings];
}



- (void)viewDidUnload {
    [self setSvContent:nil];
    [self setViewBaseInfo:nil];
    [self setIvPhoto:nil];
    [self setBtnFollow:nil];
    [self setLblTitle:nil];
    [self setLblAddress:nil];
    [super viewDidUnload];
}

#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kGGSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kGGSectionUpdates) {
        return _updates.count;
    }
    else if (section == kGGSectionPrevCompanies) {
        return _personOverview.prevCompanies.count;
    }
    else if (section == kGGSectionSocialProfiles) {
        return _personOverview.socialProfiles.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    
    if (section == kGGSectionUpdates) {
        GGCompanyDetailUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGCompanyDetailUpdateCell"];
        if (!cell) {
            cell = [GGCompanyDetailUpdateCell viewFromNibWithOwner:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GGHappening *data = _updates[row];
        
        cell.lblSource.text = data.sourceText;
        cell.lblInterval.text = [data intervalStringWithDate:data.timestamp];
        cell.lblHeadLine.text = data.headLineText;
        
        return cell;
        
    }
    else if (section == kGGSectionPrevCompanies) {
        
        GGComDetailEmployeeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGComDetailEmployeeCell"];
        if (!cell) {
            cell = [GGComDetailEmployeeCell viewFromNibWithOwner:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GGCompany *data = _personOverview.prevCompanies[row];
        
        cell.lblTitle.text = data.name;
        cell.lblSubTitle.text = data.website;
        [cell.ivPhoto setImageWithURL:[NSURL URLWithString:data.logoPath] placeholderImage:GGSharedImagePool.placeholder];
        
        [cell grayoutTitle:!data.enabled];
        
        return cell;
        
    }
    else if (section == kGGSectionSocialProfiles) {
        
        GGComDetailProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGComDetailProfileCell"];
        if (!cell) {
            cell = [GGComDetailProfileCell viewFromNibWithOwner:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GGSocialProfile *data = _personOverview.socialProfiles[row];
        
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
    
    if (section == kGGSectionUpdates) {
        
        GGHappeningDetailVC *vc = [[GGHappeningDetailVC alloc] init];
        vc.happenings = _updates;
        vc.happeningIndex = row;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (section == kGGSectionPrevCompanies) {
        
        GGCompany *data = _personOverview.prevCompanies[row];
        if (data.enabled)
        {
            [self enterCompanyDetailWithID:data.ID];
        }
    }
    else if (section == kGGSectionSocialProfiles) {
        
        GGSocialProfile *data = _personOverview.socialProfiles[row];
        GGWebVC *vc = [[GGWebVC alloc] init];
        vc.urlStr = data.url;
        vc.naviTitle = self.naviTitle;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    
    if (section == kGGSectionUpdates) {
        
        return [GGCompanyDetailUpdateCell HEIGHT];
        
    }
    else if (section == kGGSectionPrevCompanies) {
        return [GGComDetailEmployeeCell HEIGHT];
    }
    else if (section == kGGSectionSocialProfiles) {
        
        return [GGComDetailProfileCell HEIGHT];
        
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == kGGSectionUpdates && _updates.count <= 0) {
        
        return 0.f;
        
    }
    else if (section == kGGSectionPrevCompanies && _personOverview.prevCompanies.count <= 0)
    {
        return 0.f;
    }
    else if (section == kGGSectionSocialProfiles && _personOverview.socialProfiles.count <= 0) {
        
        return 0.f;
        
    }
    
    return [GGCompanyDetailHeaderView HEIGHT];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GGCompanyDetailHeaderView *header = [GGCompanyDetailHeaderView viewFromNibWithOwner:self];
    
    if (section == kGGSectionUpdates) {
        
        header.lblTitle.text = @"UPDATES";
        [header.lblAction addTarget:self action:@selector(_seeAllHappeningsAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if (section == kGGSectionPrevCompanies) {
        header.lblTitle.text = @"PREVIOUS COMPANIES";
        [header.lblAction addTarget:self action:@selector(_seeAllPrevCompaniesAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (section == kGGSectionSocialProfiles) {
        
        header.lblTitle.text = @"LINKED PROFILES";
        header.lblAction.hidden = YES;
        
    }
    
    return header;
}
#pragma mark table callback END -

-(void)_seeAllHappeningsAction:(id)sender
{
    GGHappeningsVC *vc = [[GGHappeningsVC alloc] init];
    vc.happenings = _updates;
    vc.isPersonHappenings = YES;
    vc.personID = _personID;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)_seeAllPrevCompaniesAction:(id)sender
{
    GGEmployerComsVC *vc = [[GGEmployerComsVC alloc] init];
    vc.companies = _personOverview.prevCompanies;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UI update
-(void)_updateUiOverview
{
    NSURL *url = [NSURL URLWithString:_personOverview.photoPath];

    [self.ivPhoto setImageWithURL:url placeholderImage:GGSharedImagePool.placeholder];
    self.naviTitle = _personOverview.name;
    self.lblTitle.text = _personOverview.orgTitle;
    self.lblAddress.text = _personOverview.address;
    
    [self _updateUiBtnFollow];
    
    [_tvDetail reloadData];
}

-(void)_updateUiBtnFollow
{
    if (_personOverview.followed)
    {
        [self.btnFollow setTitle:@"Following" forState:UIControlStateNormal];
        self.btnFollow.selected = YES;
    }
    else
    {
        [self.btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
        self.btnFollow.selected = NO;
    }
}

#pragma mark - actions
-(IBAction)followPersonAction:(id)sender
{
    if (_personOverview.followed)
    {
        // show action sheet
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"unfollow", nil];
        [sheet showFromTabBar:self.tabBarController.tabBar];
    }
    else
    {
        id op = [GGSharedAPI followPersonWithID:_personID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                _personOverview.followed = YES;
                
                [self postNotification:GG_NOTIFY_PERSON_FOLLOW_CHANGED];
                
                [self _updateUiBtnFollow];
            }
            else
            {
                [GGAlert alertWithApiParser:parser];
            }
        }];
        
        [self registerOperation:op];
    }
}

#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLog(@"action sheet index:%d", buttonIndex);
    if (buttonIndex == 0)
    {
        id op = [GGSharedAPI unfollowPersonWithID:_personID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.isOK)
            {
                _personOverview.followed = NO;
                
                [self postNotification:GG_NOTIFY_PERSON_FOLLOW_CHANGED];
                
                [self _updateUiBtnFollow];
            }
        }];
        
        [self registerOperation:op];
    }
}

#pragma mark - API calls
-(void)_callApiGetPersonOverview
{
    [self showLoadingHUD];
    id op = [GGSharedAPI getPersonOverviewWithID:_personID callback:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        _personOverview = [parser parseGetPersonOverview];
        
        DLog(@"%@", _personOverview.prevCompanies);
        for (GGCompany *company in _personOverview.prevCompanies) {
            DLog(@"%@", company);
        }
        
        [self _updateUiOverview];
    }];
    
    [self registerOperation:op];
}

-(void)_callApiGetHappenings
{
    GGApiBlock callback = ^(id operation, id aResultObject, NSError* anError) {

        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            GGDataPage *page = [parser parseGetCompanyHappenings];
            
            [_updates removeAllObjects];
            [_updates addObjectsFromArray:[GGUtils arrayWithArray:page.items maxCount:3]];
            
            [_tvDetail reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    };
    
    id op = [GGSharedAPI getHappeningsWithPersonID:_personID eventID:0 pageFlag:kGGPageFlagFirstPage pageTime:0 callback:callback];
    [self registerOperation:op];
}

#pragma mark - orientation changed
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    [self _adjustSelfFrameForIpadWithOrient:toInterfaceOrientation];
    
    [_tvDetail centerMeHorizontallyChangeMyWidth:IPAD_CONTENT_WIDTH];
}

-(void)_adjustSelfFrameForIpadWithOrient:(UIInterfaceOrientation)anOrient
{
    if (ISIPADDEVICE)
    {
        CGRect theFrame = [GGLayout frameWithOrientation:anOrient rect:[GGLayout screenFrame]];
        theFrame.size.height -= [GGLayout statusHeight] + [GGLayout navibarFrame].size.height + [GGLayout tabbarFrame].size.height;
        
        self.view.frame = theFrame;
    }
}

@end
