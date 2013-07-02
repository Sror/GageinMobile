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
@property (weak, nonatomic) IBOutlet UIImageView *ivTopLogo;
@property (weak, nonatomic) IBOutlet UIButton *btnGetStarted;

@end

@implementation GGWelcomeVC
{
    NSMutableArray      *_welcomePages;
    UIImage             *_imgPageDotNormal;
    UIImage             *_imgPageDotSelected;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _welcomePages = [NSMutableArray array];
        _imgPageDotNormal = [UIImage imageNamed:@"pageDotDarkGray"];
        _imgPageDotSelected = [UIImage imageNamed:@"pageDotYellow"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GGSharedColor.bgGray;
    [_btnGetStarted setBackgroundImage:GGSharedImagePool.bgBtnOrangeDarkEdge forState:UIControlStateNormal];
    
    int pageCount = 4;
    for (int i = 0; i < pageCount; i++)
    {
        GGWelcomePageView *page = [GGWelcomePageView viewFromNibWithOwner:self];
        //page.alpha = .5f;
        [page showPageWithIndex:i];
        CGRect pageFrame = CGRectOffset(page.frame, i * page.frame.size.width, 0);
        page.frame = pageFrame;
        [self.scrollView addSubview:page];
        [_welcomePages addObject:page];
    }
    CGSize contentSize = CGSizeMake(self.view.frame.size.width * pageCount, self.view.frame.size.height);
    self.scrollView.contentSize = contentSize;
    self.scrollView.delegate = self;
    
    _pageControl.numberOfPages = 4;
    _pageControl.defersCurrentPageDisplay = YES;
    _pageControl.dotImage = _imgPageDotNormal;
    _pageControl.selectedDotImage = _imgPageDotSelected;
    self.pageControl.delegate = self;
    [self.pageControl addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(CGRect)_viewBoundsWithOrient:(UIInterfaceOrientation)toInterfaceOrientation
{
    CGRect windowRc = [UIScreen mainScreen].bounds;
    return [GGLayout frameWithOrientation:toInterfaceOrientation rect:windowRc];
}

-(void)doLayoutUIForIPadWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
    
    float offsetY = (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) ?  100.f : 50.f;
    UIImage *logoImg = [UIImage imageNamed:@"pad_gageinLogo"];
    CGSize logoSize = logoImg.size;
    _ivTopLogo.image = logoImg;
    _ivTopLogo.frame = CGRectMake((self.view.frame.size.width - logoSize.width) / 2
                                  , offsetY
                                  , logoSize.width
                                  , logoSize.height);
    
    CGRect orientRc = [self _viewBoundsWithOrient:toInterfaceOrientation];
    self.scrollView.autoresizingMask = UIViewAutoresizingNone;
    self.scrollView.frame = orientRc;
    //self.scrollView.backgroundColor = GGSharedColor.darkRed;
    int i = 0;
    for (GGWelcomePageView *welcomePage in _welcomePages)
    {
        [welcomePage removeFromSuperview];
        [welcomePage doLayoutUIForIPadWithOrientation:toInterfaceOrientation];
        //CGRect welcomeRc = welcomePage.frame;
        welcomePage.frame = CGRectMake(i * orientRc.size.width
                                       , 0
                                       , orientRc.size.width
                                       , orientRc.size.height);
        [self.scrollView addSubview:welcomePage];
        i++;
    }
    
    CGSize contentSize = CGSizeMake(orientRc.size.width * _welcomePages.count, orientRc.size.height);
    self.scrollView.contentSize = contentSize;
    
    //[_btnGetStarted centerMeHorizontally];
    
}

- (void)viewDidUnload {
    [self setPageControl:nil];
    [self setScrollView:nil];
    [self setIvTopLogo:nil];
    [self setBtnGetStarted:nil];
    [super viewDidUnload];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGRect orientRc = [self _viewBoundsWithOrient:[UIApplication sharedApplication].statusBarOrientation];
    float offsetX = scrollView.contentOffset.x;
    float pageWidth = orientRc.size.width;
    NSUInteger  currentPage = offsetX / pageWidth;
    self.pageControl.currentPage = currentPage;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //self.pageControl.currentPage = scrollView.contentOffset.x / 320;
}

#pragma mark - page action

-(void)pageAction:(id)sender{
    int currentPage = self.pageControl.currentPage;
    //self.scrollView.contentOffset = CGPointMake(currentPage * 320, 0);
    CGRect orientRc = [self _viewBoundsWithOrient:[UIApplication sharedApplication].statusBarOrientation];
    [self.scrollView setContentOffset:CGPointMake(currentPage * orientRc.size.width, 0) animated:YES];
    self.pageControl.currentPage = currentPage;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (ISIPADDEVICE)
    {
        CGRect orientRc = [self _viewBoundsWithOrient:toInterfaceOrientation];
        [self.scrollView setContentOffset:CGPointMake(self.pageControl.currentPage * orientRc.size.width, 0) animated:NO];
    }
}

#pragma mark - fx page control delegate
//- (UIImage *)pageControl:(FXPageControl *)pageControl imageForDotAtIndex:(NSInteger)index
//{
//    return _imgPageDotNormal;
//}
//
//- (UIImage *)pageControl:(FXPageControl *)pageControl selectedImageForDotAtIndex:(NSInteger)index
//{
//    return _imgPageDotSelected;
//}

-(IBAction)getStartedAction:(id)sender
{
    DLog(@"show sign up screen");
    [self postNotification:GG_NOTIFY_GET_STARTED];
}


@end
