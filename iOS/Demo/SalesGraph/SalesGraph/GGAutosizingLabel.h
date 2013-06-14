//
//  GGAutosizingLabel.h
//  Gagein
//
//  Created by Dong Yiming on 5/13/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGAutosizingLabel : UILabel{
    double _minHeight;
}

@property (nonatomic) double minHeight;

- (void)calculateSize;

@end
