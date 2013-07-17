//
//  SAMenuCell.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SIMenuCell.h"
#import "SIMenuConfiguration.h"
#import "UIColor+Extension.h"
#import "SICellSelection.h"
#import <QuartzCore/QuartzCore.h>

@interface SIMenuCell ()
@property (nonatomic, strong) SICellSelection *cellSelection;
@end

@implementation SIMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithWhite:.2f alpha:1];//[UIColor color:[SIMenuConfiguration itemsColor] withAlpha:[SIMenuConfiguration menuAlpha]];
        
        // top line
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 1)];
        topLine.backgroundColor = [UIColor colorWithWhite:1 alpha:.1];
        [self.contentView addSubview:topLine];
        
        // bottom line
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.bounds.size.height - 1, self.contentView.bounds.size.width, 1)];
        bottomLine.backgroundColor = [UIColor colorWithWhite:0 alpha:.1];
        [self.contentView addSubview:bottomLine];
        
        //
        self.textLabel.textColor = [SIMenuConfiguration itemTextColor];
        self.textLabel.font = [UIFont fontWithName:GG_FONT_NAME_HELVETICA_NEUE_LIGHT size:15];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.shadowColor = [UIColor darkGrayColor];
        self.textLabel.shadowOffset = CGSizeMake(0.0, -1.0);
        
        self.selectionStyle = UITableViewCellEditingStyleNone;
        
        //
        self.cellSelection = [[SICellSelection alloc] initWithFrame:self.bounds andColor:[SIMenuConfiguration selectionColor]];
        //[self.cellSelection.layer setCornerRadius:6.0];
        [self.cellSelection.layer setMasksToBounds:YES];
        
        self.cellSelection.alpha = 0.0;
        [self.contentView insertSubview:self.cellSelection belowSubview:self.textLabel];
        
        //
        CGRect logoRc = CGRectMake(20, ([SIMenuConfiguration itemCellHeight] - [SIMenuConfiguration logoSize]) / 2, [SIMenuConfiguration logoSize], [SIMenuConfiguration logoSize]);
        _ivLogo = [[UIImageView alloc] initWithFrame:logoRc];
        _ivLogo.contentMode = UIViewContentModeScaleAspectFill;
        //_ivLogo.image = [UIImage imageNamed:@"tab_company_selected"];
        [self.contentView insertSubview:_ivLogo aboveSubview:self.textLabel];
    }
    return self;
}

//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(ctx, 2.0f);
//    
//    CGContextSetRGBStrokeColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//    CGContextMoveToPoint(ctx, 0, self.contentView.bounds.size.height);
//    CGContextAddLineToPoint(ctx, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
//    CGContextStrokePath(ctx);
//    
//    CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 0.7f);
//        
//    CGContextMoveToPoint(ctx, 0, 0);
//    CGContextAddLineToPoint(ctx, self.contentView.bounds.size.width, 0);
//    CGContextStrokePath(ctx);
//    
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setSelected:(BOOL)selected withCompletionBlock:(void (^)())completion
{
    float alpha = 0.0;
    if (selected) {
        alpha = 1.0;
    } else {
        alpha = 0.0;
    }
    
    self.cellSelection.alpha = alpha;
    
    [UIView animateWithDuration:[SIMenuConfiguration selectionSpeed] animations:^{
        
    } completion:^(BOOL finished) {
        completion();
    }];
}

- (void)dealloc
{
    self.cellSelection = nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //DLog(@"touches began");
    self.cellSelection.alpha = 1;
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //DLog(@"touches ended");
    self.cellSelection.alpha = 0;
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //DLog(@"touches cancelled");
    self.cellSelection.alpha = 0;
    [super touchesCancelled:touches withEvent:event];
}


@end