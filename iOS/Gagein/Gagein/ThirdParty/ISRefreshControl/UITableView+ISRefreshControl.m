#import "UITableView+ISRefreshControl.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ISMethodSwizzling.h"
#import "ISRefreshControl.h"
#import <objc/runtime.h>

static char ISAssociatedRefreshControlKey;

@implementation UITableView (ISRefreshControl)

//+ (void)load
//{
//    @autoreleasepool {
//        if (![UIRefreshControl class]) {
//            ISSwizzleInstanceMethod([self class], @selector(initWithCoder:), @selector(_initWithCoder:));
//        }
//    }
//}
//
//- (id)_initWithCoder:(NSCoder *)coder
//{
//    self = [self _initWithCoder:coder];
//    if (self) {
//        ISRefreshControl *refreshControl = [coder decodeObjectForKey:@"UIRefreshControl"];
//        [self addSubview:refreshControl];
//    }
//    return self;
//}

-(void)refreshWithTarget:(id)aTarget action:(SEL)anAction
{
    self.refreshControl = [[ISRefreshControl alloc] init];
    
    if (aTarget && anAction)
    {
        [[self refreshControl] addTarget:aTarget action:anAction forControlEvents:UIControlEventValueChanged];
    }
}

- (ISRefreshControl *)refreshControl
{
    return objc_getAssociatedObject(self, &ISAssociatedRefreshControlKey);
}

- (void)setRefreshControl:(ISRefreshControl *)refreshControl
{
    ISRefreshControl *oldRefreshControl = objc_getAssociatedObject(self, &ISAssociatedRefreshControlKey);
    [oldRefreshControl removeFromSuperview];
    [self addSubview:refreshControl];
    
    objc_setAssociatedObject(self, &ISAssociatedRefreshControlKey, refreshControl, OBJC_ASSOCIATION_RETAIN);
}

-(void)beginRefreshing
{
    [[self refreshControl] beginRefreshing];
}

-(void)endRefreshing
{
    [[self refreshControl] endRefreshing];
}

-(void)stopAnimating
{
    [self stopInfiniteScrollAnimating];
    [self endRefreshing];
}

@end
