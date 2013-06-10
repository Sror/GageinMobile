//
//  GGSelectFuncAreasVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-9.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGSelectFuncAreasVC.h"
#import "GGDataPage.h"
#import "GGFunctionalArea.h"
#import "GGMember.h"
#import "GGAppDelegate.h"
#import "GGGroupedCell.h"
#import "GGConfigLabel.h"

@interface GGSelectFuncAreasVC ()
@property (weak, nonatomic) IBOutlet UITableView *viewTable;
@property (weak, nonatomic) IBOutlet UIView *viewSetupLower;
@property (weak, nonatomic) IBOutlet UIView *viewSetupUpper;
@property (weak, nonatomic) IBOutlet UIButton *btnDoneStep;

@end

@implementation GGSelectFuncAreasVC
{
    NSMutableArray *_functionalAreas;
    BOOL            _isSelectionChanged;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _functionalAreas = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.naviTitle = @"Start Your Gagein";
    self.view.backgroundColor = GGSharedColor.silver;
    self.viewTable.backgroundColor = GGSharedColor.clear;
    
    [_btnDoneStep setBackgroundImage:GGSharedImagePool.bgBtnOrange forState:UIControlStateNormal];
    _viewSetupLower.backgroundColor = GGSharedColor.silver;
    _viewSetupLower.layer.shadowOffset = CGSizeMake(-2, 0);
    _viewSetupLower.layer.shadowRadius = 4;
    _viewSetupLower.layer.shadowOpacity = .3f;
    
    //if (NO)
    if (!_isFromRegistration)
    {
        self.naviTitle = @"Choose Functional Areas";
        
        // add done button
        self.navigationItem.rightBarButtonItem = [GGUtils naviButtonItemWithTitle:@"Done" target:self selector:@selector(doneAction:)];
        
        // hide setup tip
        self.viewSetupLower.hidden = self.viewSetupUpper.hidden = YES;
        
        // addjust layout
//        float tvGap = 20;
//        self.viewTable.frame = [GGUtils setH:self.view.frame.size.height - tvGap * 2 rect:[GGUtils setY:tvGap rect:self.viewTable.frame]];
    }
    
    [self _getAreasData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideBackButton];
}

#pragma mark - internal
-(NSArray *)_selectedAreaIDs
{
    NSMutableArray *selectedAreaIDs = [NSMutableArray array];
    
    for (GGFunctionalArea *area in _functionalAreas) {
        if (area.checked) {
            [selectedAreaIDs addObject:[NSNumber numberWithLongLong:area.ID]];
        }
    }
    
    return selectedAreaIDs;
}

#pragma mark - actions
-(IBAction)doneStepAction:(id)sender
{
    id op = [GGSharedAPI selectFunctionalAreas:[self _selectedAreaIDs] callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            // go home
            [self dismissViewControllerAnimated:NO completion:nil];
            [GGSharedDelegate popNaviToRoot];
            [GGSharedDelegate showTabIndex:0];
            [self postNotification:GG_NOTIFY_LOG_IN]; // step is done,and notify for the completion
        }
        else
        {
            [GGAlert alertWithApiParser:parser];
        }
    }];
    
    [self registerOperation:op];
}

-(IBAction)doneAction:(id)sender
{
    if (!_isSelectionChanged)
    {
        [self naviBackAction:nil];
        return;
    }
    
    id op = [GGSharedAPI selectFunctionalAreas:[self _selectedAreaIDs] callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            [GGAlert alertWithMessage:@"Succeeded!"];
        }
        else
        {
            [GGAlert alertWithApiParser:parser];
        }
        
        [self naviBackAction:nil];
    }];
    
    [self registerOperation:op];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _functionalAreas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    //int section = indexPath.section;
    
    static NSString *cellID = @"GGGroupedCell";
    GGGroupedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [GGGroupedCell viewFromNibWithOwner:self];
        [cell showSubTitle:NO];
    }
    
    GGFunctionalArea *data = _functionalAreas[row];
    cell.lblTitle.text = data.name;
    cell.style = [GGUtils styleForArrayCount:_functionalAreas.count atIndex:row];
    
    cell.checked = data.checked;
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGFunctionalArea *areaData = _functionalAreas[indexPath.row];
    areaData.checked = !areaData.checked;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    _isSelectionChanged = YES;
    
    self.btnDoneStep.hidden = ([self _selectedAreaIDs].count <= 0);
}

- (void)viewDidUnload {
    [self setViewTable:nil];
    [self setViewSetupLower:nil];
    [self setViewSetupUpper:nil];
    [self setBtnDoneStep:nil];
    [super viewDidUnload];
}


#pragma mark - API calls
-(void)_getAreasData
{
    id op = [GGSharedAPI getFunctionalAreas:^(id operation, id aResultObject, NSError *anError) {
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.status == 1)
        {
            GGDataPage *page = [parser parseGetFunctionalAreas];
            _functionalAreas = [page.items mutableCopy];
            [self.viewTable reloadData];
        }
        
    }];
    
    [self registerOperation:op];
}

#pragma mark -
-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    [_viewTable centerMeHorizontallyChangeMyWidth:IPAD_CONTENT_WIDTH];
}

@end
