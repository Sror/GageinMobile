//
//  GGProfileEditTimeZoneVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-27.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGProfileEditTimeZoneVC.h"
#import "GGUserProfile.h"
#import "GGGroupedCell.h"
#import "GGTimeZone.h"

@interface GGProfileEditTimeZoneVC ()
@property (weak, nonatomic) IBOutlet UITableView *tvTimeZone;

@end

@implementation GGProfileEditTimeZoneVC
{
    NSArray *_timezones;
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
    self.view.backgroundColor = GGSharedColor.silver;
    self.naviTitle = @"TimeZone";
    _tvTimeZone.backgroundColor = GGSharedColor.silver;
    _tvTimeZone.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tvTimeZone.rowHeight = [GGGroupedCell HEIGHT];
    
    _timezones = [GGUtils timezones];
    [_tvTimeZone reloadData];
}


- (void)viewDidUnload {
    [self setTvTimeZone:nil];
    [super viewDidUnload];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _timezones.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    static NSString *cellID = @"GGGroupedCell";
    GGGroupedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [GGGroupedCell viewFromNibWithOwner:self];
        [cell showSubTitle:YES];
        //[cell showDisclosure];
    }

    GGTimeZone *data = _timezones[row];
    
    cell.lblTitle.text = data.name;
    cell.lblSubTitle.text = data.gmt;
    cell.tag = row;
    
    cell.style = [GGUtils styleForArrayCount:_timezones.count atIndex:indexPath.row];
    
    cell.checked = [_userProfile.timezone isEqualToString:data.idStr];

    return cell;
}

#pragma mark - table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//#pragma TODO: all API to change the timezone
    GGTimeZone *data = _timezones[indexPath.row];
    
    [self showLoadingHUD];
    id op = [GGSharedAPI changeProfileWithTimezone:data.idStr callback:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            _userProfile.timezone = data.idStr;
            _userProfile.timezoneGMT = data.gmt;
            _userProfile.timezoneName = data.name;

            [_tvTimeZone reloadData];
        }
    }];
    
    [self registerOperation:op];
}

#pragma mark -
#pragma mark -
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    [_tvTimeZone centerMeHorizontallyChangeMyWidth:IPAD_CONTENT_WIDTH];
}

@end
