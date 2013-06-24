//
//  GGFactory.m
//  Gagein
//
//  Created by Dong Yiming on 6/19/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGFactory.h"
#import "GGCompanyUpdateCell.h"
#import "GGCompanyUpdate.h"
#import "GGCompany.h"
#import "GGCompanyUpdateIpadCell.h"
#import "GGHappeningIpadCell.h"
#import "GGHappening.h"
#import "GGCompanyHappeningCell.h"

@implementation GGFactory

+(GGCompanyUpdateCell *)cellOfComUpdate:(id)aDequeuedCell
                                   data:(GGCompanyUpdate *)aData
                              dataIndex:(NSUInteger)aDataIndex
                             logoAction:(GGTagetActionPair *)anAction
{
    GGCompanyUpdateCell * cell = aDequeuedCell;
    if (cell == nil)
    {
        cell = [GGCompanyUpdateCell viewFromNibWithOwner:self];
        
        if (anAction && anAction.action)
        {
            //[cell.logoBtn addTarget:anAction.target action:anAction.action forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSAssert([cell isKindOfClass:[GGCompanyUpdateCell class]], @"cell should be GGCompanyUpdateCell");
    
    if (aData)
    {
        cell.ID = aData.ID;
        //cell.logoBtn.tag = aDataIndex;
        
        cell.titleLbl.text = [aData headlineTruncated];
        cell.sourceLbl.text = aData.fromSource;
        
        cell.descriptionLbl.text = aData.content;
        
        [cell.logoIV setImageWithURL:[NSURL URLWithString:aData.newsPicURL/*aData.company.logoPath*/] placeholderImage:GGSharedImagePool.logoDefaultCompany];
        
        cell.intervalLbl.text = [aData intervalStringWithDate:aData.date];
        cell.hasBeenRead = aData.hasBeenRead;
        
        [cell showPicture:(aData.newsPicURL!= nil)];
        
        [cell adjustLayout];
    }
    
    return cell;
}

+(GGCompanyUpdateIpadCell *)cellOfComUpdateIpad:(id)aDequeuedCell
                                           data:(GGCompanyUpdate *)aData
                                      dataIndex:(NSUInteger)aDataIndex
                                    expandIndex:(NSUInteger)aExpandIndex
                                  isTvExpanding:(BOOL)aIsTvExpanding
                                     logoAction:(GGTagetActionPair *)aLogoAction
                                 headlineAction:(GGTagetActionPair *)aHeadlineAction
{
    GGCompanyUpdateIpadCell *cell = aDequeuedCell;
    
    if (cell == nil) {
        cell = [GGCompanyUpdateIpadCell viewFromNibWithOwner:self];
        
        if (aLogoAction && aLogoAction.action)
        {
            [cell.btnLogo addTarget:aLogoAction.target action:aLogoAction.action forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (aHeadlineAction && aHeadlineAction.action)
        {
            [cell.btnHeadline addTarget:aHeadlineAction.target action:aHeadlineAction.action forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSAssert([cell isKindOfClass:[GGCompanyUpdateIpadCell class]], @"cell should be GGCompanyUpdateIpadCell");
    
    if (aData)
    {
        cell.data = aData;
        cell.btnLogo.tag = aDataIndex;
        cell.btnHeadline.tag = aDataIndex;
        
        cell.lblHeadline.text = aData.headline;//[aData headlineTruncated];
        cell.lblSource.text = aData.fromSource;
        cell.lblDescription.text = aData.content;
        
        cell.ivLogo.hidden = (aData.newsPicURL.length == 0);
        if (!cell.ivLogo.hidden)
        {
            [cell.ivLogo setImageWithURL:[NSURL URLWithString:aData.newsPicURL/*aData.company.logoPath*/] placeholderImage:GGSharedImagePool.logoDefaultCompany];
        }
        
        
        cell.lblInterval.text = [aData intervalStringWithDate:aData.date];
        cell.hasBeenRead = aData.hasBeenRead;
        
        if (aDataIndex == aExpandIndex)
        {
            cell.expanded = aIsTvExpanding;
        }
        else
        {
            cell.expanded = NO;
        }

    }
    
    return cell;
}

+(GGCompanyHappeningCell *)cellOfHappening:(id)aDequeuedCell
                                      data:(GGHappening *)aData
                                 dataIndex:(NSUInteger)aDataIndex
                                logoAction:(GGTagetActionPair *)aLogoAction
                        isCompanyHappening:(BOOL)aIsComHappening
{
    GGCompanyHappeningCell *cell = aDequeuedCell;
    if (cell == nil)
    {
        cell = [GGCompanyHappeningCell viewFromNibWithOwner:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (aLogoAction && aLogoAction.action)
        {
            [cell.btnLogo addTarget:aLogoAction.target action:aLogoAction.action forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    NSAssert([cell isKindOfClass:[GGCompanyHappeningCell class]], @"cell should be GGCompanyHappeningCell");
    
    if (aData)
    {
        cell.tag = aDataIndex;
        cell.btnLogo.tag = aDataIndex;
        
        cell.lblName.text = aData.sourceText;
        cell.lblDescription.text = aData.headLineText;
        cell.lblInterval.text = [aData intervalStringWithDate:aData.timestamp];
        
        if (aIsComHappening)
        {
            [cell.ivLogo setImageWithURL:[NSURL URLWithString:aData.company.logoPath]
                        placeholderImage:GGSharedImagePool.logoDefaultCompany];
        }
        else
        {
            [cell.ivLogo setImageWithURL:[NSURL URLWithString:aData.person.photoPath]
                        placeholderImage:GGSharedImagePool.logoDefaultPerson];
        }
        
        cell.hasBeenRead = aData.hasBeenRead;
    }
    
    return cell;
}

+(GGHappeningIpadCell *)cellOfHappeningIpad:(id)aDequeuedCell
                                       data:(GGHappening *)aData
                                  dataIndex:(NSUInteger)aDataIndex
                                expandIndex:(NSUInteger)aExpandIndex
                              isTvExpanding:(BOOL)aIsTvExpanding
                                 logoAction:(GGTagetActionPair *)aLogoAction
                         isCompanyHappening:(BOOL)aIsComHappening
{
    GGHappeningIpadCell *cell = aDequeuedCell;
    if (cell == nil)
    {
        cell = [GGHappeningIpadCell viewFromNibWithOwner:self];
        
        if (aLogoAction && aLogoAction.action)
        {
            [cell.btnLogo addTarget:aLogoAction.target action:aLogoAction.action forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.btnHeadline.enabled = NO;
    }
    
    NSAssert([cell isKindOfClass:[GGHappeningIpadCell class]], @"cell should be GGHappeningIpadCell");
    
    if (aData)
    {
        cell.data = aData;
        cell.btnLogo.tag = aDataIndex;
        cell.btnHeadline.tag = aDataIndex;
        
        cell.lblHeadline.text = aData.headLineText;
        cell.lblSource.text = aData.sourceText;
        
        if (aIsComHappening)
        {
            [cell.ivLogo setImageWithURL:[NSURL URLWithString:aData.company.logoPath]
                        placeholderImage:GGSharedImagePool.logoDefaultCompany];
        }
        else
        {
            [cell.ivLogo setImageWithURL:[NSURL URLWithString:aData.person.photoPath]
                        placeholderImage:GGSharedImagePool.logoDefaultPerson];
        }
        
        cell.lblInterval.text = [aData intervalStringWithDate:aData.timestamp];
        cell.hasBeenRead = aData.hasBeenRead;
        
        if (aDataIndex == aExpandIndex)
        {
            cell.expanded = aIsTvExpanding;
        }
        else
        {
            cell.expanded = NO;
        }
    }
    
    return cell;
}



@end
