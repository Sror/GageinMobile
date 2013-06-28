//
//  GGSsgrfActionListener.h
//  Gagein
//
//  Created by Dong Yiming on 6/16/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <Foundation/Foundation.h>

//
@protocol GGSsgrfActionDelegate
@required
-(void)ssGraphShowPersonPanel:(NSNumber *)aPersonID;
-(void)ssGraphShowCompanyPanel:(GGCompany *)aCompany;

-(void)ssGraphShowPersonLandingPage:(NSNumber *)aPersonID;
-(void)ssGraphShowCompanyLandingPage:(NSNumber *)aCompanyID;

-(void)ssGraphShowEmployeeListPage:(NSNumber *)aCompanyID;
-(void)ssGraphShowEmployerListPage:(GGPerson *)aPerson;

//-(void)ssGraphShowCompanyListPage:(NSArray *)aCompanies;

-(void)ssGraphShowWebPage:(NSString *)aURL;
-(void)ssGraphShowImageURL:(NSString *)aImageURL;

-(void)ssGraphFollowPerson:(NSNumber *)aPersonID;
-(void)ssGraphUnfollowPerson:(NSNumber *)aPersonID;
-(void)ssGraphFollowCompany:(NSNumber *)aCompanyID;
-(void)ssGraphUnfollowCompany:(NSNumber *)aCompanyID;

-(void)ssGraphSignal:(id)aData;
-(void)ssGraphLike:(NSNumber *)aUpdateID;
-(void)ssGraphUnLike:(NSNumber *)aUpdateID;
-(void)ssGraphSave:(NSNumber *)aUpdateID;
-(void)ssGraphUnSave:(NSNumber *)aUpdateID;
-(void)ssGraphShare:(id)aData;
@end



@interface GGSsgrfActionListener : NSObject
AS_SINGLETON(GGSsgrfActionListener)
@property (nonatomic, weak) id<GGSsgrfActionDelegate>   delegate;

@end
