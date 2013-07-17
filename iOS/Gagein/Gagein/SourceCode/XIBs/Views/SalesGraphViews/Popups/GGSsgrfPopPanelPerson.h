//
//  GGSsgrfPopPanelPerson.h
//  TestPanel
//
//  Created by Dong Yiming on 6/17/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSsgrfPopPanelPerson : UIView

@property (weak, nonatomic) IBOutlet UIView *viewHeader;
//---------
@property (weak, nonatomic) IBOutlet UIButton *btnLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnLinkedIn;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnYoutube;
@property (weak, nonatomic) IBOutlet UIButton *btnSlideShare;
@property (weak, nonatomic) IBOutlet UIButton *btnHoover;
@property (weak, nonatomic) IBOutlet UIButton *btnYahoo;
@property (weak, nonatomic) IBOutlet UIButton *btnCB;

@property (weak, nonatomic) IBOutlet UIView *viewEmployers;

//------------
@property (weak, nonatomic) IBOutlet UIView *viewEmployer1;
@property (weak, nonatomic) IBOutlet UILabel *lblEmp1Title;
@property (weak, nonatomic) IBOutlet UIImageView *ivEmp1Logo;
@property (weak, nonatomic) IBOutlet UILabel *lblEmp1SubTitle;
//--------------
@property (weak, nonatomic) IBOutlet UIView *viewEmployer2;
@property (weak, nonatomic) IBOutlet UILabel *lblEmp2Title;
@property (weak, nonatomic) IBOutlet UIImageView *ivEmp2Logo;
@property (weak, nonatomic) IBOutlet UILabel *lblEmp2SubTitle;
//-------------------
@property (weak, nonatomic) IBOutlet UIView *viewEmployer3;
@property (weak, nonatomic) IBOutlet UILabel *lblEmp3Title;
@property (weak, nonatomic) IBOutlet UIImageView *ivEmp3Logo;
@property (weak, nonatomic) IBOutlet UILabel *lblEmp3SubTitle;
//-------------------
@property (weak, nonatomic) IBOutlet UIButton *btnMoreEmployers;


@property (weak, nonatomic) IBOutlet UIView *viewExtraInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblOwnership;

@property (weak, nonatomic) IBOutlet UIView *viewFooter;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;

@property (weak, nonatomic) IBOutlet UIButton *btnClose;


@property (strong, nonatomic) UIView    *viewCover;


-(void)updateWithPerson:(GGPerson *)aPerson;

@end
