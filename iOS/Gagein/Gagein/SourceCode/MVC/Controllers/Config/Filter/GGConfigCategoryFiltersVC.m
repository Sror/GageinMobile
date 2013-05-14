//
//  GGConfigCategoryFiltersVC.m
//  Gagein
//
//  Created by dong yiming on 13-5-2.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGConfigCategoryFiltersVC.h"
#import "GGConfigSwitchView.h"

@interface GGConfigCategoryFiltersVC ()
//@property (weak, nonatomic) IBOutlet GGConfigSwitchCell *cellConfigSwitch;
@property (weak, nonatomic) IBOutlet GGConfigSwitchView *viewConfigSwitch;

@end

@implementation GGConfigCategoryFiltersVC

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
    self.naviTitle = @"Category Filters";
    self.view.backgroundColor = GGSharedColor.silver;
    
    _viewConfigSwitch = [GGUtils replaceFromNibForView:_viewConfigSwitch];
    
    _viewConfigSwitch.backgroundColor = GGSharedColor.white;
    _viewConfigSwitch.btnSwitch.isOn = YES;
    _viewConfigSwitch.btnSwitch.lblOn.text = @"On";
    _viewConfigSwitch.btnSwitch.lblOff.text = @"Off";
    _viewConfigSwitch.btnSwitch.delegate = self;
}



- (void)viewDidUnload {
    [self setViewConfigSwitch:nil];
    [super viewDidUnload];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - switch button delegate
-(void)switchButton:(GGSwitchButton *)aSwitchButton isOn:(BOOL)aIsOn
{
    [self showLoadingHUD];
    [GGSharedAPI setCategoryFilterEnabled:aIsOn callback:^(id operation, id aResultObject, NSError *anError) {
        [self hideLoadingHUD];
        GGApiParser *parser = [GGApiParser parserWithApiData:aResultObject];
        if (parser.isOK)
        {
            //_tv.hidden = !aIsOn;
        }
        
    }];
}

@end
