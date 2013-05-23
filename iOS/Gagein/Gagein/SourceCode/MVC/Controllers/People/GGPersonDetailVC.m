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
    self.ivPhoto.layer.borderWidth = 1.f;
    self.ivPhoto.layer.borderColor = GGSharedColor.silver.CGColor;
    self.ivPhoto.layer.cornerRadius = 3.f;
    
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
    [self.view addSubview:_tvDetail];
    
    UIView *tvBgView = [[UIView alloc] initWithFrame:CGRectZero];
    tvBgView.backgroundColor = GGSharedColor.silver;
    _tvDetail.backgroundView = tvBgView;
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _updates.count;
    } else if (section == 1) {
        return _personOverview.socialProfiles.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    
    if (section == 0) {
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
        
    } else if (section == 1) {
        
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
    
    if (section == 0) {
        
        
        
    } else if (section == 1) {
        
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
    
    if (section == 0) {
        
        return [GGCompanyDetailUpdateCell HEIGHT];
        
    } else if (section == 1) {
        
        return [GGComDetailProfileCell HEIGHT];
        
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && _updates.count <= 0) {
        
        return 0.f;
        
    } else if (section == 1 && _personOverview.socialProfiles.count <= 0) {
        
        return 0.f;
        
    }
    
    return [GGCompanyDetailHeaderView HEIGHT];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GGCompanyDetailHeaderView *header = [GGCompanyDetailHeaderView viewFromNibWithOwner:self];
    
    if (section == 0) {
        
        header.lblTitle.text = @"UPDATES";
        [header.lblAction addTarget:self action:@selector(_seeAllHappeningsAction:) forControlEvents:UIControlEventTouchUpInside];
        
    } else if (section == 1) {
        
        header.lblTitle.text = @"LINKED PROFILES";
        header.lblAction.hidden = YES;
        
    }
    
    return header;
}

-(void)_seeAllHappeningsAction:(id)sender
{
    GGHappeningsVC *vc = [[GGHappeningsVC alloc] init];
    vc.happenings = _updates;
    vc.isPersonHappenings = YES;
    vc.personID = _personID;
    
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
        [self.btnFollow setTitle:@"following" forState:UIControlStateNormal];
        self.btnFollow.selected = YES;
    }
    else
    {
        [self.btnFollow setTitle:@"follow" forState:UIControlStateNormal];
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
        [GGSharedAPI followPersonWithID:_personID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.status == 1) {
                _personOverview.followed = YES;
                [self _updateUiBtnFollow];
            }
            else
            {
                [GGAlert alertWithApiMessage:parser.message];
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
        [GGSharedAPI unfollowPersonWithID:_personID callback:^(id operation, id aResultObject, NSError *anError) {
            GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
            if (parser.status == 1) {
                _personOverview.followed = NO;
                [self _updateUiBtnFollow];
            }
        }];
    }
}

#pragma mark - API calls
-(void)_callApiGetPersonOverview
{
    [self showLoadingHUD];
    [GGSharedAPI getPersonOverviewWithID:_personID callback:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        _personOverview = [parser parseGetPersonOverview];
        [self _updateUiOverview];
    }];
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
    
    [GGSharedAPI getHappeningsWithPersonID:_personID eventID:0 pageFlag:kGGPageFlagFirstPage pageTime:0 callback:callback];
}

@end
