//
//  GGHappeningDetailVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-24.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGHappeningDetailVC.h"
#import "GGCompanyHappening.h"
#import "GGPersonCell.h"

@interface GGHappeningDetailVC ()
@property (weak, nonatomic) IBOutlet UITableView *tvDetail;
@property (weak, nonatomic) IBOutlet UIView *viewBottomBar;
@property (weak, nonatomic) IBOutlet UIScrollView *svContent;

@end

@implementation GGHappeningDetailVC
{
    GGCompanyHappening *_currentDetail;
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
    
    [self _callApiGetHappeningDetail];
}

#pragma mark - API calls
-(void)_callApiGetHappeningDetail
{
    GGCompanyHappening *data = _happenings[_currentIndex];
    [GGSharedAPI getCompanyEventDetailWithID:data.ID callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            _currentDetail = [parser parseCompanyEventDetail];
        }
    }];
}

- (void)viewDidUnload {
    [self setTvDetail:nil];
    [self setViewBottomBar:nil];
    [self setSvContent:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *updateCellId = @"GGPersonCell";
    GGPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:updateCellId];
    if (cell == nil) {
        cell = [GGPersonCell viewFromNibWithOwner:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.lblName.text = @"name";
    cell.lblTitle.text = @"web";
    cell.lblAddress.text = @"addr";
    
    return cell;
}

#pragma mark - table view delegate
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GGPersonCell HEIGHT];
}

@end
