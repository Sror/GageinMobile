//
//  GGSsgrfFullInfoWidgetView.m
//  SalesGraph
//
//  Created by Dong Yiming on 6/13/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import "GGSsgrfInfoWidgetView.h"

#import "GGSsgrfTitledImageBtnView.h"
#import "GGSsgrfTitledImgScrollView.h"

#import "GGCompany.h"
#import "GGPerson.h"
#import "GGDataPage.h"

@interface GGSsgrfInfoWidgetView ()
@property (strong, nonatomic)   GGSsgrfTitledImageBtnView   *viewTitledImage;


@end

@implementation GGSsgrfInfoWidgetView
{
    BOOL                        _canReportLoading;
}


-(void)_doInit
{
    //self.backgroundColor = [UIColor darkGrayColor];
    
    _viewTitledImage = [[GGSsgrfTitledImageBtnView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview:_viewTitledImage];
    
    CGRect scrollRc = CGRectMake(0, CGRectGetMaxY(_viewTitledImage.frame), _viewTitledImage.frame.size.width, 0);
    _viewTitledScroll = [[GGSsgrfTitledImgScrollView alloc] initWithFrame:scrollRc];
    [self addSubview:_viewTitledScroll];
    _viewTitledScroll.viewScroll.delegate = self;
    
    CGRect thisRc = self.frame;
    thisRc.size.width = _viewTitledImage.frame.size.width;
    thisRc.size.height = CGRectGetMaxY(_viewTitledScroll.frame);
    self.frame = thisRc;
    
    //
    [self setScrollTitle:@"Similar"];
    
    _canReportLoading = YES;
}

+(float)WIDTH
{
    return [GGSsgrfTitledImageBtnView WIDTH];
}

#pragma mark - interface
-(void)setTitle:(NSString *)aTitle
{
    [_viewTitledImage setTitle:aTitle];
}

-(void)setSubTitle:(NSString *)aTitle
{
    [_viewTitledImage setSubTitle:aTitle];
}

-(void)setScrollTitle:(NSString *)aTitle
{
    [_viewTitledScroll setTitle:aTitle];
}

-(void)makeMeSimple
{
    [self showScrollBar:NO];
}

-(void)showScrollBar:(BOOL)aShow
{
    _viewTitledScroll.hidden = !aShow;
    
    CGRect thisRc = self.frame;
    thisRc.size.height = aShow ? CGRectGetMaxY(_viewTitledScroll.frame) : CGRectGetMaxY(_viewTitledImage.frame);
    self.frame = thisRc;
}

-(void)setMainImage:(UIImage *)aImage
{
    [_viewTitledImage setImage:aImage];
}

-(void)setMainImageUrl:(NSString *)aImageUrl placeholder:(UIImage *)aPlaceholder
{
    [_viewTitledImage setImageURL:aImageUrl placeholder:aPlaceholder];
}

-(void)applyCircleEffect:(BOOL)aApplyCircle
{
    [_viewTitledImage applyCircleEffect:aApplyCircle];
}

-(void)setMainTaget:(id)aTarget action:(SEL)aAction
{
    [_viewTitledImage resetTarget:aTarget action:aAction];
}


-(void)setScrollImageUrls:(NSArray *)aScrollImageUrls placeholder:(UIImage *)aPlaceholder
{
    [self setScrollImageUrls:aScrollImageUrls placeholder:aPlaceholder needReInstall:YES];
}

-(void)setScrollImageUrls:(NSArray *)aScrollImageUrls placeholder:(UIImage *)aPlaceholder needReInstall:(BOOL)aNeedReInstall
{
    [_viewTitledScroll setImageUrls:aScrollImageUrls placeholder:aPlaceholder needReInstall:aNeedReInstall];
}

-(void)setScrollTaget:(id)aTarget action:(SEL)aAction
{
    [_viewTitledScroll setTaget:aTarget action:aAction];
}

-(GGCompanyDigest *)_company
{
    if ([_data isKindOfClass:[GGCompanyDigest class]])
    {
        return ((GGCompanyDigest *)_data);
    }
    
    return nil;
}

-(GGHappeningPerson *)_person
{
    if ([_data isKindOfClass:[GGHappeningPerson class]])
    {
        return ((GGHappeningPerson *)_data);
    }
    
    return nil;
}

-(NSString *)_mapURL
{
    if ([_data isKindOfClass:[NSString class]])
    {
        return ((NSString *)_data);
    }
    
    return nil;
}

-(NSArray *)_competitors
{
    return [self _company].competitors.items;
}

-(void)updateWithCompany:(GGCompanyDigest *)aCompany
{
    [self updateWithCompany:aCompany needReInstall:YES];
}

-(void)updateWithCompany:(GGCompanyDigest *)aCompany needReInstall:(BOOL)aNeedReInstall
{
    _type = kGGSsGrfInfoWidgetCompany;
    _data = aCompany;
    
    DLog(@"company:%@, name:%@ logo:%@", aCompany, aCompany.name, aCompany.logoPath);
    if (aCompany)
    {
        NSString *trunckName = [aCompany.name stringSeperatedWith:@" " componentsCount:2 maxLength:20];
        [self setTitle:trunckName];
        
        if (aCompany.hasBeenRemoved)
        {
            [self setMainImage:GGSharedImagePool.x];
        }
        else
        {
            [self setMainImageUrl:aCompany.logoPath placeholder:GGSharedImagePool.logoDefaultCompany];
        }
        
        [self setMainTaget:self action:@selector(companyLogoTapped:)];
        
        NSArray *competitors = aCompany.competitors.items;
        NSMutableArray *imageURLs = [NSMutableArray array];
        for (GGCompanyDigest *com in competitors)
        {
            [imageURLs addObjectIfNotNil:com.logoPath];
        }
        
        [self setScrollTaget:self action:@selector(competitorTapped:)];
        [self setScrollImageUrls:imageURLs placeholder:GGSharedImagePool.placeholder needReInstall:aNeedReInstall];
    }
}

-(void)updateWithPerson:(GGHappeningPerson *)aPerson
{
    [self updateWithPerson:aPerson showOldPhoto:NO];
}

-(void)updateWithPerson:(GGHappeningPerson *)aPerson showOldPhoto:(BOOL)showOldPhoto
{
    _type = kGGSsGrfInfoWidgetPerson;
    _data = aPerson;
    
    if (aPerson)
    {
        [self setTitle:aPerson.name];
        [self setMainTaget:self action:@selector(personLogoTapped:)];
        
        if (showOldPhoto)
        {
            [self setMainImageUrl:aPerson.oldPhotoPath placeholder:GGSharedImagePool.logoDefaultPerson];
        }
        else
        {
            [self setMainImageUrl:aPerson.photoPath placeholder:GGSharedImagePool.logoDefaultPerson];
        }
        
        [self applyCircleEffect:YES];
        
        [self makeMeSimple];
    }
}

-(void)updateWithMapUrl:(NSString *)aMapURL
{
    _type = kGGSsGrfInfoWidgetAddress;
    _data = aMapURL;
    
    if (aMapURL)
    {
        [self setMainImageUrl:aMapURL placeholder:GGSharedImagePool.placeholder];
        [self setMainTaget:self action:@selector(mapTapped:)];
        
        [self makeMeSimple];
    }
}

#pragma mark - actions
-(void)companyLogoTapped:(id)sender
{
    //UIButton * btn = (UIButton *)sender;
    //DLog(@"companyLogoTapped: %d", btn.tag);
//    NSArray *params = nil;
//    if ([_data isKindOfClass:[GGCompany class]])
//    {
//        params = [NSArray arrayWithObjects:@([self _company].ID), @(0), nil];
//    }
//    else if ([_data isKindOfClass:[GGPerson class]])
//    {
//        params = [NSArray arrayWithObjects:@([self _company].ID), @(0), nil];
//    }
    
    [self postNotification:GG_NOTIFY_SSGRF_SHOW_COMPANY_PANEL withObject:[self _company]];
}

-(void)personLogoTapped:(id)sender
{
    [self postNotification:GG_NOTIFY_SSGRF_SHOW_PERSON_PANEL withObject:@([self _person].ID)];
}

-(void)mapTapped:(id)sender
{
    [self postNotification:GG_NOTIFY_SSGRF_SHOW_MAP_IMAGE_URL withObject:[self _mapURL]];
}

-(void)competitorTapped:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    DLog(@"competitorTapped: %d", btn.tag);
    GGCompany *competitor = [self _competitors][btn.tag];
    [self postNotification:GG_NOTIFY_SSGRF_SHOW_COMPANY_PANEL withObject:competitor];
}


#pragma mark - 
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_canReportLoading && scrollView == _viewTitledScroll.viewScroll)
    {
        if (scrollView.contentOffset.x + scrollView.frame.size.width == scrollView.contentSize.width)
        {
            //DLog(@"\noffset:%@, content size:%@, scroll view frame:%@", NSStringFromCGPoint(scrollView.contentOffset), NSStringFromCGSize(scrollView.contentSize), NSStringFromCGRect(scrollView.frame));
            
            if (_loadingResponder && [_data isKindOfClass:[GGCompanyDigest class]])
            {
                GGCompanyDigest *company = _data;
                if (company.competitors.hasMore)
                {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         _loadingResponder, @"responder"
                                         , company, @"company", nil];
                    
                    [self postNotification:GG_NOTIFY_INFO_WIDGET_SCROLL_TO_END withObject:dic];
                }
            }
            
            
            
            _canReportLoading = NO;
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _viewTitledScroll.viewScroll)
    {
        _canReportLoading = YES;
    }
}

@end
