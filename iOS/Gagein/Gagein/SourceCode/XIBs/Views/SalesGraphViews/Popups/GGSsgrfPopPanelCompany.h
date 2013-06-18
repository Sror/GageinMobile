//
//  GGSsgrfPopPanelCompany.h
//  TestPanel
//
//  Created by Dong Yiming on 6/17/13.
//  Copyright (c) 2013 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSsgrfPopPanelCompany : UIView

@property (weak, nonatomic) IBOutlet UIView *viewHeader;
//---------
@property (weak, nonatomic) IBOutlet UIButton *btnLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnLinkedIn;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;


@property (weak, nonatomic) IBOutlet UIView *viewEmployees;

@property (weak, nonatomic) IBOutlet UIView *viewExtraInfo;

@property (weak, nonatomic) IBOutlet UIView *viewFooter;

@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@end
