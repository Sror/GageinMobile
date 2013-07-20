#import <UIKit/UIKit.h>

//@class ISRefreshControl;

@interface UITableView (ISRefreshControl)
//@property (strong, nonatomic) ISRefreshControl *refreshControl;

-(void)refreshWithTarget:(id)aTarget action:(SEL)anAction;

-(void)beginRefreshing;
-(void)endRefreshing;

@end
