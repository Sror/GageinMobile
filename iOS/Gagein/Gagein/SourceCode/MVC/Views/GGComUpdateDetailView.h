//
//  GGComUpdateDetailView.h
//  Gagein
//
//  Created by dong yiming on 13-5-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGAutosizingLabel.h"

@interface GGComUpdateDetailView : UIView
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIImageView *ivUpdateBg;
@property (weak, nonatomic) IBOutlet UILabel *lblSource;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet GGAutosizingLabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;
//@property (weak, nonatomic) IBOutlet UITextView *textviewHidden;
//@property (weak, nonatomic) IBOutlet UIWebView *wvTextview;
@property (weak, nonatomic) IBOutlet UITextView *tvContent;
@property (assign, nonatomic) float height;

//-(float)height;
-(void)adjustHeight;
-(void)adjustLayout;
-(void)adjustLayoutHasImage:(BOOL)aHasImage;
-(float)contentWidth;
@end
