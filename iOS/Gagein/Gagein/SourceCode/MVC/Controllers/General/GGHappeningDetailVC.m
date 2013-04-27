//
//  GGHappeningDetailVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-24.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGHappeningDetailVC.h"
#import "GGCompanyHappening.h"
#import "GGCustomBriefCell.h"
#import "GGHappeningDetailCell.h"
#import "GGCompanyDetailVC.h"
#import "GGPersonDetailVC.h"

@interface GGHappeningDetailVC ()
@property (weak, nonatomic) IBOutlet UITableView *tvDetail;
@property (weak, nonatomic) IBOutlet UIView *viewBottomBar;
@property (weak, nonatomic) IBOutlet UIScrollView *svContent;

@end

@implementation GGHappeningDetailVC
{
    GGCompanyHappening          *_currentDetail;
    GGHappeningDetailCell       *_happeningDetailCell;
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
    self.naviTitle = @"Happening";
    self.svContent.frame = [self viewportAdjsted];
    self.tvDetail.backgroundColor = GGSharedColor.silver;
    
    //
    _happeningDetailCell = [GGHappeningDetailCell viewFromNibWithOwner:self];
    
    [self _callApiGetHappeningDetail];
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [self pushBackButtonFront];
//}

- (void)viewDidUnload {
    [self setTvDetail:nil];
    [self setViewBottomBar:nil];
    [self setSvContent:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = 1;
    if (_currentDetail.person.ID) {
        count++;
    }
    if (_currentDetail.company.ID) {
        count++;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (row == 0)
    {
        _happeningDetailCell.lblSource.text = _currentDetail.sourceText;
        _happeningDetailCell.lblHeadline.text = _currentDetail.headLineText;
        _happeningDetailCell.lblInterval.text = [_currentDetail intervalStringWithDate:_currentDetail.timestamp];
        
        switch (_currentDetail.type)
        {
            case kGGHappeningCompanyPersonJionDetail:
            {
                [_happeningDetailCell showChangeView:YES];
                [_happeningDetailCell showChangeLeftImage:YES];
                [_happeningDetailCell showChangeRightImage:YES];
            }
                break;
                
            default:
                break;
        }
        
        return _happeningDetailCell;
        
    } else {
        
        static NSString *updateCellId = @"GGPersonCell";
        GGCustomBriefCell *cell = [tableView dequeueReusableCellWithIdentifier:updateCellId];
        if (cell == nil) {
            cell = [GGCustomBriefCell viewFromNibWithOwner:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (row == 1 && _currentDetail.person) { // if person exists, show person
            
            cell.lblName.text = _currentDetail.person.name;
            cell.lblTitle.text = _currentDetail.freshJobTitle;
            cell.lblAddress.text = @"address";
            cell.type = kGGCustomBriefCellPerson;
            
        }  else { // this index represent comany
            
            cell.lblName.text = _currentDetail.company.name;
            cell.lblTitle.text = @"website";
            cell.lblAddress.text = @"address";
            cell.type = kGGCustomBriefCellCompany;
            
        }
        
        return cell;
        
    }
    
    return nil;
}

#pragma mark - table view delegate
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (row == 0)
    {
        return _happeningDetailCell.height;
    }
    
    return [GGCustomBriefCell HEIGHT];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (row > 0)
    {
        GGCustomBriefCell *cell = (GGCustomBriefCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (cell.type == kGGCustomBriefCellCompany)
        {
            GGCompanyDetailVC *vc = [[GGCompanyDetailVC alloc] init];
            vc.companyID = _currentDetail.company.ID;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            GGPersonDetailVC *vc = [[GGPersonDetailVC alloc] init];
            vc.personID = _currentDetail.person.ID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


#pragma mark - API calls
-(void)_callApiGetHappeningDetail
{
    GGApiBlock callback = ^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            _currentDetail = [parser parseCompanyEventDetail];
        }
        
        [_tvDetail reloadData];
    };
    
    GGCompanyHappening *data = _happenings[_currentIndex];
    
    [self showLoadingHUD];
    if (_isPeopleHappening)
    {
        [GGSharedAPI getPeopleEventDetailWithID:data.ID callback:callback];
    }
    else
    {
        [GGSharedAPI getCompanyEventDetailWithID:data.ID callback:callback];
    }
    
}

@end
