//
//  GGFollowPeopleVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-26.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGFollowPeopleVC.h"
#import "GGStyledSearchBar.h"

@interface GGFollowPeopleVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *svContent;

@end

@implementation GGFollowPeopleVC
{
    GGStyledSearchBar *_searchBar;
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
    self.svContent.backgroundColor = GGSharedColor.silver;
    
    _searchBar = [GGStyledSearchBar viewFromNibWithOwner:self];
    [self.svContent addSubview:_searchBar];
}

- (void)viewDidUnload {
    [self setSvContent:nil];
    [super viewDidUnload];
}
@end
