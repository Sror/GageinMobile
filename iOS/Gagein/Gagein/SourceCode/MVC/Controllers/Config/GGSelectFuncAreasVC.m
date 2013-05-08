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

@interface GGSelectFuncAreasVC ()
@property (weak, nonatomic) IBOutlet UITableView *viewTable;
@property (weak, nonatomic) IBOutlet UIView *viewSetupLower;
@property (weak, nonatomic) IBOutlet UIView *viewSetupUpper;
@property (weak, nonatomic) IBOutlet UIButton *btnDoneStep;

@end

@implementation GGSelectFuncAreasVC
{
    NSMutableArray *_functionalAreas;
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
    self.title = @"Start Your Gagein";
    self.navigationItem.hidesBackButton = YES;
    
    if (!_isFromRegistration)
    {
        self.title = @"Choose Functional Areas";
        // add done button
//        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction:)];
        self.navigationItem.rightBarButtonItem = [GGUtils naviButtonItemWithTitle:@"Done" target:self selector:@selector(doneAction:)];
        
        // hide setup tip
        self.viewSetupLower.hidden = self.viewSetupUpper.hidden = YES;
        
        // addjust layout
        self.viewTable.frame = [GGUtils setH:self.view.frame.size.height - 10 rect:[GGUtils setY:10 rect:self.viewTable.frame]];
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
    [GGSharedAPI selectFunctionalAreas:[self _selectedAreaIDs] callback:^(id operation, id aResultObject, NSError *anError) {
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
            [GGAlert alert:parser.message];
        }
    }];
}

-(IBAction)doneAction:(id)sender
{
    [GGSharedAPI selectFunctionalAreas:[self _selectedAreaIDs] callback:^(id operation, id aResultObject, NSError *anError) {
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            [GGAlert alert:@"Succeeded!"];
        }
        else
        {
            [GGAlert alert:parser.message];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _functionalAreas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *areaCellId = @"areaCellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:areaCellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:areaCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GGFunctionalArea *areaData = _functionalAreas[indexPath.row];
    cell.textLabel.text = areaData.name;
    cell.accessoryType = areaData.checked ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGFunctionalArea *areaData = _functionalAreas[indexPath.row];
    areaData.checked = !areaData.checked;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
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
    [GGSharedAPI getFunctionalAreas:^(id operation, id aResultObject, NSError *anError) {
        
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.status == 1)
        {
            GGDataPage *page = [parser parseGetFunctionalAreas];
            _functionalAreas = [page.items mutableCopy];
            [self.viewTable reloadData];
        }
        
    }];
}
@end
