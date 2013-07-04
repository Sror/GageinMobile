//
//  GGLeftDrawerVC.m
//  Gagein
//
//  Created by Dong Yiming on 6/23/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGLeftDrawerVC.h"
#import "GGAppDelegate.h"

@interface GGLeftDrawerVC ()

@end

@implementation GGLeftDrawerVC

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
    
    _viewContent = [[UIView alloc] initWithFrame:self.view.bounds];
    _viewContent.backgroundColor = GGSharedColor.black;
    //_viewContent.backgroundColor = GGSharedColor.random;
    [self.view addSubview:_viewContent];
	
    _viewMenu = [[GGSlideSettingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_viewMenu];
    //_viewMenu.alpha = .5f;
    
    //_viewMenu.viewTable.backgroundColor = GGSharedColor.orange;
    //[self.view addSubview:_viewMenu.viewTable];

}

//-(BOOL)doNeedMenu
//{
//    //DLog(@"%@ need menu.", NSStringFromClass([self class]));
//    return GGSharedDelegate.topMostVC.doNeedMenu;
//}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    cell.textLabel.text = @"aaa";
//    return cell;
//}
//
//-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 10;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"selected");
//}

-(BOOL)canHearAction
{
    return NO;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //[super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    [self layoutUIForIPadWithOrientation:toInterfaceOrientation];
}

-(void)layoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (ISIPADDEVICE)
    {
        //DLog(@"screen:%@", NSStringFromCGRect([GGLayout contentRectWithOrient:toInterfaceOrientation]));
        self.view.frame = [GGLayout contentRectWithOrient:toInterfaceOrientation];
        [_viewMenu setHeight:self.view.frame.size.height];
        //DLog(@"self.view:%@, menu:%@", self.view.frameString, _viewMenu.frameString);
    }
}

@end
