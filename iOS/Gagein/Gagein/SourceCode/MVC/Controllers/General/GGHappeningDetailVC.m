//
//  GGHappeningDetailVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-24.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGHappeningDetailVC.h"
#import "GGHappening.h"
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
    GGHappening          *_currentDetail;
    GGHappeningDetailCell       *_happeningDetailCell;
    
    UIButton *_btnPrevUpdate;
    UIButton *_btnNextUpdate;
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
    
    // previous update button
    UIImage *upArrowEnabledImg = [UIImage imageNamed:@"upArrowEnabled"];
    UIImage *upArrowDisabledImg = [UIImage imageNamed:@"upArrowDisabled"];
    CGRect naviRc = self.navigationController.navigationBar.frame;
    CGRect prevBtnRc = CGRectMake(naviRc.size.width - upArrowEnabledImg.size.width * 2 - 10
                                  , (naviRc.size.height - upArrowEnabledImg.size.height) / 2 + 5
                                  , upArrowEnabledImg.size.width
                                  , upArrowEnabledImg.size.height);
    
    _btnPrevUpdate = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnPrevUpdate.frame = prevBtnRc;
    [_btnPrevUpdate setImage:upArrowEnabledImg forState:UIControlStateNormal];
    [_btnPrevUpdate setImage:upArrowDisabledImg forState:UIControlStateDisabled];
    [_btnPrevUpdate addTarget:self action:@selector(prevUpdateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // next update button
    UIImage *downArrowEnabledImg = [UIImage imageNamed:@"downArrowEnabled"];
    UIImage *downArrowDisabledImg = [UIImage imageNamed:@"downArrowDisabled"];
    _btnNextUpdate = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect nextBtnRc = CGRectMake(naviRc.size.width - downArrowEnabledImg.size.width - 10
                                  , (naviRc.size.height - downArrowEnabledImg.size.height) / 2 + 5
                                  , downArrowEnabledImg.size.width
                                  , downArrowEnabledImg.size.height);
    _btnNextUpdate.frame = nextBtnRc;
    [_btnNextUpdate setImage:downArrowEnabledImg forState:UIControlStateNormal];
    [_btnNextUpdate setImage:downArrowDisabledImg forState:UIControlStateDisabled];
    [_btnNextUpdate addTarget:self action:@selector(nextUpdateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    _happeningDetailCell = [GGHappeningDetailCell viewFromNibWithOwner:self];
    
    [self _callApiGetHappeningDetail];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar addSubview:_btnPrevUpdate];
    [self.navigationController.navigationBar addSubview:_btnNextUpdate];
    [self _updateNaviBtnState];
}

- (void)viewDidUnload {
    [self setTvDetail:nil];
    [self setViewBottomBar:nil];
    [self setSvContent:nil];
    [super viewDidUnload];
}

#pragma mark -navi buttons
-(void)prevUpdateAction:(id)sender
{
    if (_happeningIndex > 0) {
        _happeningIndex--;
        [self _callApiGetHappeningDetail];
        
        [self _updateNaviBtnState];
    }
}

-(void)nextUpdateAction:(id)sender
{
    if (_happeningIndex < _happenings.count - 1) {
        _happeningIndex++;
        [self _callApiGetHappeningDetail];
        
        [self _updateNaviBtnState];
    }
}

-(void)_updateNaviBtnState
{
    _btnPrevUpdate.enabled = (_happeningIndex > 0);
    _btnNextUpdate.enabled = (_happeningIndex < _happenings.count - 1);
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
    
    GGHappening *data = _happenings[_happeningIndex];
    
    [self showLoadingHUD];
    if (_isPeopleHappening)
    {
        id op = [GGSharedAPI getPeopleEventDetailWithID:data.ID callback:callback];
        [self registerOperation:op];
    }
    else
    {
        id op = [GGSharedAPI getCompanyEventDetailWithID:data.ID callback:callback];
        [self registerOperation:op];
    }
    
}

@end
