//
//  GGLeftDrawerVC.m
//  Gagein
//
//  Created by Dong Yiming on 6/23/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGLeftDrawerVC.h"


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
    _viewContent.backgroundColor = GGSharedColor.darkRed;
    [self.view addSubview:_viewContent];
	
    _viewMenu = [[GGSlideSettingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_viewMenu];
    _viewMenu.viewTable.delegate = self;
    _viewMenu.viewTable.dataSource = self;
    _viewMenu.viewTable.backgroundColor = GGSharedColor.orange;
    [self.view addSubview:_viewMenu.viewTable];
    //[_viewMenu addSubview:_viewMenu.viewTable];
    
//    UITableView *_tv = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    _tv.delegate = self;
//    _tv.dataSource = self;
//    [self.view addSubview:_tv];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"aaa";
    return cell;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected");
}


@end
