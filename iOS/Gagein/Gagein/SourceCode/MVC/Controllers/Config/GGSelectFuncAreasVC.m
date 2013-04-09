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
        self.title = @"Choose Agents";
        // add done button
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction:)];
        self.navigationItem.rightBarButtonItem = doneBtn;
        
        // hide setup tip
        self.viewSetupLower.hidden = self.viewSetupUpper.hidden = YES;
        
        // addjust layout
        self.viewTable.frame = [GGUtils setH:self.view.frame.size.height - 10 rect:[GGUtils setY:10 rect:self.viewTable.frame]];
    }
    
    [self _getAreasData];
}

#pragma mark - actions
-(IBAction)doneStepAction:(id)sender
{
    
}

-(IBAction)doneAction:(id)sender
{
    
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
