//  Created by Smita Vardhan on 1/26/16.
//  Copyright © 2016 Smita. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController<UISearchBarDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


@end

