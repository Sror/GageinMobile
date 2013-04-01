//
//  GGWelcomePageView.h
//  Gagein
//
//  Created by dong yiming on 13-4-1.
//  Copyright (c) 2013年 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGWelcomePageView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

-(void)showImageWithIndex:(NSUInteger)aIndex;

@end
