//
//  GGImageVC.m
//  Gagein
//
//  Created by Dong Yiming on 5/29/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "GGImageVC.h"

@interface GGImageVC ()
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIImageView *iv;

@end

@implementation GGImageVC
{
    UITapGestureRecognizer  *_tapGestToDone;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tapGestToDone = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doneAction:)];
    [self.view addGestureRecognizer:_tapGestToDone];
    
    //_imageUrl = @"http://www.gagein.com/stream/ImageProxyServlet?url=http%3A%2F%2Fchart.apis.google.com%2Fchart%3Fcht%3Dlc%26chxt%3Dx%2Cy%26chs%3D570x150%26chg%3D0%2C20%2C1%2C0%26chd%3Dt%3A-1%7C42.94%2C29.32%2C24.38%2C22.06%2C44.44%2C20.0%26chxl%3D0%3A%7CDec%2030%2C%20%2711%7CMar%2030%2C%20%2712%7CJun%2029%2C%20%2712%7CSep%2029%2C%20%2712%7CDec%2030%2C%20%2712%7CMar%2030%2C%20%2713%7C1%3A%7C%7C%2431%2C356%2C000%7C%2432%2C356%2C000%7C%2433%2C356%2C000%7C%2434%2C356%2C000%7C%2435%2C356%2C000%26chm%3Do%2Cf08300%2C1%2C0%2C6.0%7Co%2Cf08300%2C1%2C1%2C6.0%7Co%2Cf08300%2C1%2C2%2C6.0%7Co%2Cf08300%2C1%2C3%2C6.0%7Co%2Cf08300%2C1%2C4%2C6.0%7Co%2Cf08300%2C1%2C6%2C6.0";
    
    NSURL *url = [NSURL URLWithString:_imageUrl];
    [_iv setImageWithURL:url placeholderImage:nil];
}


- (void)viewDidUnload {
    [self setBtnDone:nil];
    [self setIv:nil];
    [super viewDidUnload];
}

#pragma mark - actions
-(IBAction)doneAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
}

@end
