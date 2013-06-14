//
//  GGViewController.m
//  SalesGraph
//
//  Created by Dong Yiming on 6/12/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGViewController.h"
#import "GGSsgrfTitledImageBtnView.h"

#import "GGSsgrfDblTitleView.h"
#import "GGSsgrfRndImgButton.h"

#import "GGSsgrfTitledImgScrollView.h"

#import "GGSsgrfInfoWidgetView.h"

#import "GGSsgrfPanelTripleInfo.h"
#import "GGSsgrfPanelDoubleInfo.h"

#import "GGSsgrfPanelComChart.h"
#import "GGSsgrfPanelDoubleInfoPlus.h"
#import "GGSsgrfPanelTripleInfoPlus.h"

#import "UIView+AddOn.h"
#import "UIButton+WebCache.h"

#define SAMPLE_LONG_TEXT    @"WWDC 2013\n is great!WWDC 2013 is great!WWDC 2013 is great!WWDC 2013 is great!WWDC 2013 is great!WWDC 2013 is great!WWDC 2013 is great!WWDC 2013 is great!WWDC 2013 is great!WWDC 2013 is great!WWDC 2013 is great!WWDC 2013 is great!WWDC 2013 is great!"

#define PANEL_POS   CGPointMake(114, 332)

@interface GGViewController ()

@end

@implementation GGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
	
    
//    GGSsgrfDblTitleView *dblTitle = [[GGSsgrfDblTitleView alloc] initWithFrame:CGRectMake(10, 10, 300, 50)];
//    [self.view addSubview:dblTitle];
//    [dblTitle setTitle:@"Apple Software Inc."];
//    [dblTitle setSubTitle:@"World Wide Developer Conference 2013"];
//    
//    GGSsgrfRndImgButton *roundImgBtn = [[GGSsgrfRndImgButton alloc] initWithFrame:CGRectMake(10, 100, 120, 120)];
//    [self.view addSubview:roundImgBtn];
//    [roundImgBtn setImage:[UIImage imageNamed:@"picSample.jpg"]];
//    [roundImgBtn addTarget:self action:@selector(dummy)];
    
//    GGSsgrfTitledImageBtnView *titledImgBtnView = [[GGSsgrfTitledImageBtnView alloc] initWithFrame:CGRectMake(110, 600, 0, 0)];
//    [self.view addSubview:titledImgBtnView];
//    
//    GGSsgrfTitledImgScrollView *titledScrollView = [[GGSsgrfTitledImgScrollView alloc] initWithFrame:CGRectMake(110, 800, 180, 0)];
//    [self.view addSubview:titledScrollView];
    
    
    
    [self _installPanelTripplePlus];
    
    
}

-(void)_installBgView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 600, 425)];
    [self.view addSubview:bgView];
    [bgView setPos:PANEL_POS];
    bgView.backgroundColor = [UIColor orangeColor];
    bgView.alpha = .5f;
}

-(void)_installPanelTripplePlus
{
    UIImage *placeholder = [UIImage imageNamed:@"picSample.jpg"];
    NSArray * imageURLs = [NSArray arrayWithObjects:TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, nil];
    
    GGSsgrfPanelTripleInfoPlus *panel = [GGSsgrfPanelTripleInfoPlus viewFromNibWithOwner:self];
    [self.view addSubview:panel];
    [panel setPos:PANEL_POS];
    
    ///////
    [panel.viewLeftInfo setTitle:@"Apple Inc."];
    [panel.viewLeftInfo setSubTitle:@"Previous Company"];
    [panel.viewLeftInfo showScrollBar:NO];
    
    [panel.viewLeftInfo setMainImageUrl:TEST_IMG_URL placeholder:placeholder];
    [panel.viewLeftInfo setMainTaget:self action:@selector(dummy)];
    //[panel.viewLeftInfo setMainTaget:self action:@selector(puppy)];
    
    ///////
    [panel.viewCenterInfo setTitle:@"Tim Cook"];
    [panel.viewCenterInfo setSubTitle:@"VP of Gagein Inc."];
    [panel.viewCenterInfo showScrollBar:NO];
    
    [panel.viewCenterInfo setMainImageUrl:TEST_IMG_URL placeholder:placeholder];
    [panel.viewCenterInfo setMainTaget:self action:@selector(dummy)];
    
    ///////
    [panel.viewRightInfo setTitle:@"Gagein Inc."];
    [panel.viewRightInfo setSubTitle:@"Current Company"];
    [panel.viewRightInfo showScrollBar:NO];
    
    [panel.viewRightInfo setMainImageUrl:TEST_IMG_URL placeholder:placeholder];
    [panel.viewRightInfo setMainTaget:self action:@selector(dummy)];

    
    /////
    [panel.viewBottomInfo setTitle:@"Apple Inc."];
    [panel.viewBottomInfo setSubTitle:@"Previous Company"];
    [panel.viewBottomInfo showScrollBar:YES];
    
    [panel.viewBottomInfo setMainImageUrl:TEST_IMG_URL placeholder:placeholder];
    [panel.viewBottomInfo setMainTaget:self action:@selector(dummy)];
    
    
    [panel.viewBottomInfo setScrollImageUrls:imageURLs placeholder:placeholder];
    [panel.viewBottomInfo setScrollTaget:self action:@selector(dummy)];
}

-(void)_installPanelTripple
{
    GGSsgrfPanelTripleInfo *panel = [GGSsgrfPanelTripleInfo viewFromNibWithOwner:self];
    [self.view addSubview:panel];
    [panel setPos:PANEL_POS];
    
    ///////
    [panel.viewLeftInfo setTitle:@"Apple Inc."];
    [panel.viewLeftInfo setSubTitle:@"Previous Company"];
    [panel.viewLeftInfo showScrollBar:YES];
    
    UIImage *placeholder = [UIImage imageNamed:@"picSample.jpg"];
    [panel.viewLeftInfo setMainImageUrl:TEST_IMG_URL placeholder:placeholder];
    [panel.viewLeftInfo setMainTaget:self action:@selector(dummy)];
    
    NSArray * imageURLs = [NSArray arrayWithObjects:TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, nil];
    
    [panel.viewLeftInfo setScrollImageUrls:imageURLs placeholder:placeholder];
    [panel.viewLeftInfo setScrollTaget:self action:@selector(dummy)];
    
    ///////
    [panel.viewCenterInfo setTitle:@"Tim Cook"];
    [panel.viewCenterInfo setSubTitle:@"VP of Gagein Inc."];
    [panel.viewCenterInfo showScrollBar:NO];
    
    [panel.viewCenterInfo setMainImageUrl:TEST_IMG_URL placeholder:placeholder];
    [panel.viewCenterInfo setMainTaget:self action:@selector(dummy)];
    
    ///////
    [panel.viewRightInfo setTitle:@"Gagein Inc."];
    [panel.viewRightInfo setSubTitle:@"Current Company"];
    [panel.viewRightInfo showScrollBar:YES];
    
    //UIImage *placeholder = [UIImage imageNamed:@"picSample.jpg"];
    [panel.viewRightInfo setMainImageUrl:TEST_IMG_URL placeholder:placeholder];
    [panel.viewRightInfo setMainTaget:self action:@selector(dummy)];
    
    //NSArray * imageURLs = [NSArray arrayWithObjects:TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, nil];
    
    [panel.viewRightInfo setScrollImageUrls:imageURLs placeholder:placeholder];
    [panel.viewRightInfo setScrollTaget:self action:@selector(dummy)];
}

-(void)_installPanelTrippleText
{
    UIImage *placeholder = [UIImage imageNamed:@"picSample.jpg"];
    //NSArray * imageURLs = [NSArray arrayWithObjects:TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, nil];
    
    GGSsgrfPanelTripleInfo *panel = [GGSsgrfPanelTripleInfo viewFromNibWithOwner:self];
    [self.view addSubview:panel];
    [panel setPos:PANEL_POS];
    
    ///////
    [panel setLeftText:@"CEO"];
    [panel setLeftSubText:@""];
    [panel setLeftBigTitle];
    
    ///////
    [panel.viewCenterInfo setTitle:@"Tim Cook"];
    [panel.viewCenterInfo setSubTitle:@"VP of Gagein Inc."];
    [panel.viewCenterInfo showScrollBar:NO];
    
    [panel.viewCenterInfo setMainImageUrl:TEST_IMG_URL placeholder:placeholder];
    [panel.viewCenterInfo setMainTaget:self action:@selector(dummy)];
    
    ///////
    [panel setRightText:@"VP Sales Intellegence"];
    [panel setRightSubText:@"Current Title"];
}

-(void)_installPanelDouble
{
    GGSsgrfPanelDoubleInfo *panel = [GGSsgrfPanelDoubleInfo viewFromNibWithOwner:self];
    [self.view addSubview:panel];
    [panel setPos:PANEL_POS];
    
    ///////
    [panel.viewLeftInfo setTitle:@"Apple Inc."];
    [panel.viewLeftInfo setSubTitle:@"Previous Company"];
    [panel.viewLeftInfo showScrollBar:YES];
    
    UIImage *placeholder = [UIImage imageNamed:@"picSample.jpg"];
    [panel.viewLeftInfo setMainImageUrl:TEST_IMG_URL placeholder:placeholder];
    [panel.viewLeftInfo setMainTaget:self action:@selector(dummy)];
    
    NSArray * imageURLs = [NSArray arrayWithObjects:TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, nil];
    
    [panel.viewLeftInfo setScrollImageUrls:imageURLs placeholder:placeholder];
    [panel.viewLeftInfo setScrollTaget:self action:@selector(dummy)];
    
    ///////
    [panel.viewRightInfo setTitle:@"Tim Cook"];
    [panel.viewRightInfo setSubTitle:@"VP of Gagein Inc."];
    [panel.viewRightInfo showScrollBar:NO];
    
    [panel.viewRightInfo setMainImageUrl:TEST_IMG_URL placeholder:placeholder];
    [panel.viewRightInfo setMainTaget:self action:@selector(dummy)];
}

-(void)_installPanelDoublePlus
{
    GGSsgrfPanelDoubleInfoPlus *panel = [GGSsgrfPanelDoubleInfoPlus viewFromNibWithOwner:self];
    [self.view addSubview:panel];
    
    [panel setPos:PANEL_POS];
    
    ///////
    [panel.viewLeftInfo setTitle:@"Apple Inc."];
    [panel.viewLeftInfo setSubTitle:@"Previous Company"];
    [panel.viewLeftInfo showScrollBar:NO];
    
    UIImage *placeholder = [UIImage imageNamed:@"picSample.jpg"];
    [panel.viewLeftInfo setMainImageUrl:TEST_IMG_URL placeholder:placeholder];
    [panel.viewLeftInfo setMainTaget:self action:@selector(dummy)];

    
    ///////
    [panel.viewRightInfo setTitle:@"Tim Cook"];
    [panel.viewRightInfo setSubTitle:@"VP of Gagein Inc."];
    [panel.viewRightInfo showScrollBar:NO];
    
    [panel.viewRightInfo setMainImageUrl:TEST_IMG_URL placeholder:placeholder];
    [panel.viewRightInfo setMainTaget:self action:@selector(dummy)];
    
    ////
    [panel.viewBottomInfo setTitle:@"Apple Inc."];
    [panel.viewBottomInfo setSubTitle:@"Previous Company"];
    [panel.viewBottomInfo showScrollBar:YES];
    
    [panel.viewBottomInfo setMainImageUrl:TEST_IMG_URL placeholder:placeholder];
    [panel.viewBottomInfo setMainTaget:self action:@selector(dummy)];
    
    NSArray * imageURLs = [NSArray arrayWithObjects:TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, nil];
    
    [panel.viewBottomInfo setScrollImageUrls:imageURLs placeholder:placeholder];
    [panel.viewBottomInfo setScrollTaget:self action:@selector(dummy)];
}

-(void)_installPanelDoubleText
{
    GGSsgrfPanelDoubleInfo *panel = [GGSsgrfPanelDoubleInfo viewFromNibWithOwner:self];
    [self.view addSubview:panel];
    [panel setPos:PANEL_POS];
    
    ///////
    [panel setLeftText:@"CEO"];
    [panel setLeftSubText:@""];
    [panel setLeftBigTitle];
    
    ///////
    [panel setRightText:@"VP Sales Intellegence"];
    [panel setRightSubText:@"Current Title"];
}

-(void)_installPanelChart
{
    GGSsgrfPanelComChart *panel = [GGSsgrfPanelComChart viewFromNibWithOwner:self];
    [self.view addSubview:panel];
    [panel setPos:PANEL_POS];
    
    /////
    [panel.viewLeftInfo setTitle:@"Apple Inc."];
    [panel.viewLeftInfo setSubTitle:@"Previous Company"];
    [panel.viewLeftInfo showScrollBar:YES];
    
    UIImage *placeholder = [UIImage imageNamed:@"picSample.jpg"];
    [panel.viewLeftInfo setMainImageUrl:TEST_IMG_URL placeholder:placeholder];
    [panel.viewLeftInfo setMainTaget:self action:@selector(dummy)];
    
    NSArray * imageURLs = [NSArray arrayWithObjects:TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, TEST_IMG_URL, nil];
    
    [panel.viewLeftInfo setScrollImageUrls:imageURLs placeholder:placeholder];
    [panel.viewLeftInfo setScrollTaget:self action:@selector(dummy)];
    
    ///
   
    [panel.btnChart setBackgroundImageWithURL:[NSURL URLWithString:TEST_IMG_URL] forState:UIControlStateNormal placeholderImage:placeholder];
    [panel.btnChart addTarget:self action:@selector(dummy) forControlEvents:UIControlEventTouchUpInside];
}


-(void)dummy
{
    NSLog(@"button tapped");
}

-(void)puppy
{
    NSLog(@"good boy jumps");
}

@end
