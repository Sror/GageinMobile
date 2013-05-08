//
//  GGComUpdateDetailView.h
//  Gagein
//
//  Created by dong yiming on 13-5-8.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGComUpdateDetailView : UIView
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIImageView *ivUpdateBg;
@property (weak, nonatomic) IBOutlet UILabel *lblSource;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;
@property (weak, nonatomic) IBOutlet UITextView *textviewHidden;
@property (weak, nonatomic) IBOutlet UIWebView *wvTextview;


-(float)height;
-(void)adjustHeight;
-(void)adjustLayoutHasImage:(BOOL)aHasImage;
@end
