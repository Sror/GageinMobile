//
//  GGWelcomeVC.m
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import "GGWelcomeVC.h"
#import "GGWelcomePageView.h"


@interface GGWelcomeVC ()

@end

@implementation GGWelcomeVC

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
    //self.view.backgroundColor = [UIColor darkGrayColor];
    
    int pageCount = 4;
    for (int i = 0; i < pageCount; i++)
    {
        GGWelcomePageView *page = [GGWelcomePageView viewFromNibWithOwner:self];
        //page.alpha = .5f;
        [page showPageWithIndex:i];
        CGRect pageFrame = CGRectOffset(page.frame, i * page.frame.size.width, 0);
        page.frame = pageFrame;
        [self.scrollView addSubview:page];
    }
    CGSize contentSize = CGSizeMake(self.view.frame.size.width * pageCount, self.view.frame.size.height);
    self.scrollView.contentSize = contentSize;
    self.scrollView.delegate = self;
    
    [self.pageControl addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPageControl:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / 320;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //self.pageControl.currentPage = scrollView.contentOffset.x / 320;
}

#pragma mark - page action
-(void)pageAction:(id)sender{
    int currentPage = self.pageControl.currentPage;
    //self.scrollView.contentOffset = CGPointMake(currentPage * 320, 0);
    [self.scrollView setContentOffset:CGPointMake(currentPage * 320, 0) animated:YES];
}

@end
