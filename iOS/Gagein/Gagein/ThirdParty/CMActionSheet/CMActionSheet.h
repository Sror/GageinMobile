//
//  CMActionSheet.h
//
//  Created by Constantine Mureev on 09.08.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CallbackBlock)(void);

typedef enum {
	CMActionSheetButtonTypeWhite = 0,
	CMActionSheetButtonTypeBlue,
	CMActionSheetButtonTypeRed,
	CMActionSheetButtonTypeGray,
    CMActionSheetButtonTypeCustomBg
} CMActionSheetButtonType;

@interface CMActionSheet : NSObject

@property (retain) NSString     *title;
@property (assign)  BOOL        isBgCustomized;
@property (assign) CGSize       buttonSize;


-(UIButton *)addButtonWithTitle:(NSString *)title block:(CallbackBlock)block;

-(UIButton *)addCancelButton;

- (UIButton *)addButtonWithTitle:(NSString *)title type:(CMActionSheetButtonType)type block:(CallbackBlock)block;

// added by daniel
- (UIButton *)addButtonWithTitle:(NSString *)buttonTitle bgImage:(UIImage *)aBgImage block:(CallbackBlock)block;
// added by daniel
- (UIButton *)addButtonWithTitle:(NSString *)title bgImage:(UIImage *)aBgImage type:(CMActionSheetButtonType)type block:(CallbackBlock)block;
- (void)addSeparator;

- (void)present;
- (void)dismissWithClickedButtonIndex:(NSUInteger)index animated:(BOOL)animated;

@end
