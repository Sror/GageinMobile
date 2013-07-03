//
//  CMActionSheet.m
//
//  Created by Constantine Mureev on 09.08.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "CMActionSheet.h"
#import "CMRotatableModalViewController.h"


@interface CMActionSheet ()

@property (retain) UIImageView *backgroundActionView;
@property (retain) UIWindow *overlayWindow;
@property (retain) UIWindow *mainWindow;
@property (retain) NSMutableArray *items;
@property (retain) NSMutableArray *callbacks;

@end

@implementation CMActionSheet

@synthesize title, backgroundActionView, overlayWindow, mainWindow, items, callbacks;

- (id)init {
    self = [super init];
    if (self) {
        UIImage *backgroundImage = [UIImage imageNamed:@"action-sheet-panel.png"];
        backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:0 topCapHeight:30];
        
        self.backgroundActionView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
        self.backgroundActionView.alpha = 0.8;
        self.backgroundActionView.contentMode = UIViewContentModeScaleToFill;
        self.backgroundActionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.overlayWindow = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
        self.overlayWindow.windowLevel = UIWindowLevelStatusBar;
        self.overlayWindow.userInteractionEnabled = YES;
        self.overlayWindow.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5f];
        self.overlayWindow.hidden = YES;
    }
    return self;
}

- (void)dealloc {
    self.backgroundActionView = nil;
    self.overlayWindow = nil;
    self.mainWindow = nil;
    self.items = nil;
    self.callbacks = nil;
    
    [super dealloc];
}

- (UIButton *)addButtonWithTitle:(NSString *)buttonTitle bgImage:(UIImage *)aBgImage type:(CMActionSheetButtonType)type block:(CallbackBlock)block
{
    NSAssert(buttonTitle, @"Button title must not be nil!");
    
    NSUInteger index = 0;
    
    if (!self.items) {
        self.items = [NSMutableArray array];
    }
    if (!self.callbacks) {
        self.callbacks = [NSMutableArray array];
    }
    
    NSString* color = nil;
    if (CMActionSheetButtonTypeBlue == type) {
        color = @"blue";
    } else if (CMActionSheetButtonTypeRed == type) {
        color = @"red";
    } else if (CMActionSheetButtonTypeWhite == type) {
        color = @"white";
    } else if (CMActionSheetButtonTypeGray == type) {
        color = @"gray";
    } else {
        color = @"white";
    }
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    button.titleLabel.adjustsFontSizeToFitWidth = NO;
    
    //button.titleLabel.adjustsFontSizeToFitWidth = YES;
    //button.titleLabel.minimumFontSize = 10;
    
    // Add 6px padding
    [button setTitleEdgeInsets:UIEdgeInsetsMake(6.0, 6.0, 6.0, 6.0)];
    
    button.titleLabel.textAlignment = UITextAlignmentCenter;
    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    button.backgroundColor = [UIColor clearColor];
    
    // modified by daniel
    UIImage *image = aBgImage;
    if (image == nil)
    {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"action-%@-button.png", color]];
        image = [image stretchableImageWithLeftCapWidth:(int)(image.size.width)>>1 topCapHeight:0];
    }
//    else
//    {
//        button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//    }
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    if (CMActionSheetButtonTypeWhite == type) {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    } else if (CMActionSheetButtonTypeGray == type) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else if (CMActionSheetButtonTypeBlue == type || CMActionSheetButtonTypeCustomBg == type) {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleShadowColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:GGSharedColor.white forState:UIControlStateHighlighted];
        [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    } else {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:255 / 255.0 green:40 / 255.0 blue:60 / 255.0 alpha:1] forState:UIControlStateHighlighted];
        [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    }

    if (CMActionSheetButtonTypeCustomBg == type)
    {
        _isBgCustomized = YES;
        _buttonSize = image.size;
    }
    
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    button.accessibilityLabel = buttonTitle;
    
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.items addObject:button];
    
    if (block) {
        [self.callbacks addObject:[[block copy] autorelease]];
    } else {
        [self.callbacks addObject:[NSNull null]];
    }
    
    index++;
    
    return button;
}

- (UIButton *)addButtonWithTitle:(NSString *)buttonTitle bgImage:(UIImage *)aBgImage block:(CallbackBlock)block
{
    return [self addButtonWithTitle:buttonTitle bgImage:aBgImage type:CMActionSheetButtonTypeCustomBg block:block];
}

- (UIButton *)addButtonWithTitle:(NSString *)buttonTitle type:(CMActionSheetButtonType)type block:(CallbackBlock)block
{
	return [self addButtonWithTitle:buttonTitle bgImage:nil type:type block:block];
}

- (void)addSeparator {
    UIImage *separatorImage = [UIImage imageNamed:@"action-separator.png"];
    separatorImage = [separatorImage stretchableImageWithLeftCapWidth:0 topCapHeight:2];
    
    UIImageView *separator = [[[UIImageView alloc] initWithImage:separatorImage] autorelease];
    separator.contentMode = UIViewContentModeScaleToFill;
    separator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.items addObject:separator];
}

- (void)present
{
    ISIPADDEVICE ? [self presentIPad] : [self presentIPhone];
}

#define IPAD_SHIT_WIDTH    650
- (void)presentIPad
{
    if (self.items && self.items.count > 0) {
        self.mainWindow = [UIApplication sharedApplication].keyWindow;
        CMRotatableModalViewController *viewController = [[CMRotatableModalViewController new] autorelease];
        viewController.rootViewController = mainWindow.rootViewController;
        
        // Build action sheet view
        UIView* actionSheet = [[[UIView alloc] initWithFrame:CGRectMake(0, viewController.view.frame.size.height, viewController.view.frame.size.width, 0)] autorelease];
        actionSheet.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [viewController.view addSubview:actionSheet];
        
        // Add background
        if (ISIPADDEVICE)
        {
//            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, actionSheet.frame.size.width, actionSheet.frame.size.height)];
//            bgView.backgroundColor = GGSharedColor.darkGray;
//            bgView.layer.opacity = .8f;
//            bgView.layer.cornerRadius = 8.f;
//            bgView.layer.borderColor = GGSharedColor.lightGray.CGColor;
//            bgView.layer.borderWidth = 1.f;
//            
//            [actionSheet addSubview:bgView];
        }
        //else
        {
            self.backgroundActionView.frame = CGRectMake(0, 0, actionSheet.frame.size.width, actionSheet.frame.size.height);
            self.backgroundActionView.image = nil;
            self.backgroundActionView.backgroundColor = GGSharedColor.darkGray;
            self.backgroundActionView.layer.cornerRadius = 8.f;
            //self.backgroundActionView.layer.borderWidth = 2.f;
            //self.backgroundActionView.layer.borderColor = GGSharedColor.lightGray.CGColor;
            self.backgroundActionView.layer.opacity = .9f;
            [actionSheet addSubview:self.backgroundActionView];
            
            UIView *borderView = [[UIView alloc] initWithFrame:self.backgroundActionView.frame];
            borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            borderView.backgroundColor = GGSharedColor.clear;
            borderView.layer.cornerRadius = 8.f;
            borderView.layer.borderWidth = 1.f;
            borderView.layer.opacity = .7f;
            borderView.layer.borderColor = GGSharedColor.lightGray.CGColor;
            [actionSheet addSubview:borderView];
        }
        
        CGFloat offset = 15;
        
        // Add Title
        if (self.title) {
            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:18]
                            constrainedToSize:CGSizeMake(actionSheet.frame.size.width-10*2, 1000)
                                lineBreakMode:UILineBreakModeWordWrap];
            
            UILabel *labelView = [[[UILabel alloc] initWithFrame:CGRectMake(10, offset, actionSheet.frame.size.width-10*2, size.height)] autorelease];
            labelView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            labelView.font = [UIFont fontWithName:GG_FONT_NAME_HELVETICA_NEUE_LIGHT size:13.f];
            labelView.numberOfLines = 0;
            labelView.lineBreakMode = UILineBreakModeWordWrap;
            labelView.textColor = GGSharedColor.silverLight;
            labelView.backgroundColor = [UIColor clearColor];
            labelView.textAlignment = UITextAlignmentCenter;
            labelView.shadowColor = [UIColor blackColor];
            labelView.shadowOffset = CGSizeMake(0, -1);
            labelView.text = title;
            [actionSheet addSubview:labelView];
            
            offset += size.height + 10;
        }
        
        // Add action sheet items
        NSUInteger tag = 100;
        
        for (UIView *item in self.items) {
            if ([item isKindOfClass:[UIImageView class]]) {
                item.frame = CGRectMake(0, offset, actionSheet.frame.size.width, 2);
                [actionSheet addSubview:item];
                [actionSheet insertSubview:item aboveSubview:self.backgroundActionView];
                
                offset += item.frame.size.height + 10;
            } else {
                
                BOOL isButton = [item isKindOfClass:[UIButton class]];
                if (_isBgCustomized && isButton)
                {
                    item.frame = CGRectMake((actionSheet.frame.size.width - _buttonSize.width) / 2, offset, _buttonSize.width, _buttonSize.height);
                }
                else
                {
                    item.frame = CGRectMake(10, offset, actionSheet.frame.size.width - 10*2, 35);
                }
                
                item.tag = tag++;
                [actionSheet addSubview:item];
                
                offset += item.frame.size.height + 10;
            }
        }
        
        //float width = viewController.view.frame.size.width - IPAD_GAP * 2;
        actionSheet.frame = CGRectMake((viewController.view.frame.size.width - IPAD_SHIT_WIDTH) / 2, viewController.view.frame.size.height, IPAD_SHIT_WIDTH, offset + 10);
        
        CGPoint center = actionSheet.center;
        DLog(@"vc rect:%@, action sheet rect:%@", viewController.view.frameString, actionSheet.frameString);
        center.y -= actionSheet.frame.size.height + (viewController.view.frame.size.height - actionSheet.frame.size.height) / 2;
        actionSheet.center = center;
        
        for (UIView *item in self.items)
        {
            item.frame = CGRectMake((actionSheet.frame.size.width - item.frame.size.width) / 2
                                    , item.frame.origin.y
                                    , item.frame.size.width
                                    , item.frame.size.height);
        }
        
        // Present window and action sheet
        self.overlayWindow.rootViewController = viewController;
        self.overlayWindow.alpha = 0.0f;
        self.overlayWindow.hidden = NO;
        [self.overlayWindow makeKeyWindow];
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
            self.overlayWindow.alpha = 1;
            
        } completion:^(BOOL finished) {
            // we retain self until with dismiss action sheet
            [self retain];
        }];
    }

}

- (void)presentIPhone
{
    if (self.items && self.items.count > 0) {
        self.mainWindow = [UIApplication sharedApplication].keyWindow;
        CMRotatableModalViewController *viewController = [[CMRotatableModalViewController new] autorelease];
        viewController.rootViewController = mainWindow.rootViewController;
        
        // Build action sheet view
        UIView* actionSheet = [[[UIView alloc] initWithFrame:CGRectMake(0, viewController.view.frame.size.height, viewController.view.frame.size.width, 0)] autorelease];
        actionSheet.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [viewController.view addSubview:actionSheet];
        
        // Add background
        self.backgroundActionView.frame = CGRectMake(0, 0, actionSheet.frame.size.width, actionSheet.frame.size.height);
        [actionSheet addSubview:self.backgroundActionView];
        
        CGFloat offset = 15;
        
        // Add Title
        if (self.title) {
            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:18]
                            constrainedToSize:CGSizeMake(actionSheet.frame.size.width-10*2, 1000)
                                lineBreakMode:UILineBreakModeWordWrap];
            
            UILabel *labelView = [[[UILabel alloc] initWithFrame:CGRectMake(10, offset, actionSheet.frame.size.width-10*2, size.height)] autorelease];
            labelView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            labelView.font = [UIFont fontWithName:GG_FONT_NAME_HELVETICA_NEUE_LIGHT size:13.f];
            labelView.numberOfLines = 0;
            labelView.lineBreakMode = UILineBreakModeWordWrap;
            labelView.textColor = GGSharedColor.silverLight;
            labelView.backgroundColor = [UIColor clearColor];
            labelView.textAlignment = UITextAlignmentCenter;
            labelView.shadowColor = [UIColor blackColor];
            labelView.shadowOffset = CGSizeMake(0, -1);
            labelView.text = title;
            [actionSheet addSubview:labelView];
            
            offset += size.height + 10;
        }
        
        // Add action sheet items
        NSUInteger tag = 100;
        
        for (UIView *item in self.items) {
            if ([item isKindOfClass:[UIImageView class]]) {
                item.frame = CGRectMake(0, offset, actionSheet.frame.size.width, 2);
                [actionSheet addSubview:item];
                
                offset += item.frame.size.height + 10;
            } else {
                
                if (_isBgCustomized && [item isKindOfClass:[UIButton class]])
                {
                    item.frame = CGRectMake((actionSheet.frame.size.width - _buttonSize.width) / 2, offset, _buttonSize.width, _buttonSize.height);
                }
                else
                {
                    item.frame = CGRectMake(10, offset, actionSheet.frame.size.width - 10*2, 35);
                }
                
                item.tag = tag++;
                [actionSheet addSubview:item];
                
                offset += item.frame.size.height + 10;
            }
        }
        
        actionSheet.frame = CGRectMake(0, viewController.view.frame.size.height, viewController.view.frame.size.width, offset + 10);
        
        // Present window and action sheet
        self.overlayWindow.rootViewController = viewController;
        self.overlayWindow.alpha = 0.0f;
        self.overlayWindow.hidden = NO;
        [self.overlayWindow makeKeyWindow];
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
            self.overlayWindow.alpha = 1;
            CGPoint center = actionSheet.center;
            center.y -= actionSheet.frame.size.height;
            actionSheet.center = center;
        } completion:^(BOOL finished) {
            // we retain self until with dismiss action sheet
            [self retain];
        }];
    }
}

- (void)dismissWithClickedButtonIndex:(NSUInteger)index animated:(BOOL)animated {
    // Hide window and action sheet
    UIView *actionSheet = self.overlayWindow.rootViewController.view.subviews.lastObject;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
        self.overlayWindow.alpha = 0;
        
        if (!ISIPADDEVICE)
        {
            CGPoint center = actionSheet.center;
            center.y += actionSheet.frame.size.height;
            actionSheet.center = center;
        }
        
    } completion:^(BOOL finished) {
        self.overlayWindow.hidden = YES;
        [self.mainWindow makeKeyWindow];
        
        // now we can release self
        [self release];
    }];
    
    // Call callback
    CallbackBlock callback = [self.callbacks objectAtIndex:index];
    if ([callbacks isKindOfClass:[NSNull class]]) {
        // Do nothing... It's just placeholder
    } else {
        callback();
    }
}


#pragma mark - Private


- (void)buttonClicked:(id)sender {
    NSUInteger buttonIndex = ((UIView *)sender).tag - 100;
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

@end
