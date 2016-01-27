//  Created by Smita Vardhan on 1/26/16.
//  Copyright © 2016 Smita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UISplitViewControllerDelegate>
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UILabel *FullForm;
@property (strong, nonatomic) IBOutlet UILabel *frequencyLable;
@property (strong, nonatomic) IBOutlet UILabel *sinceLabel;
@property(nonatomic,strong)NSString *fullString;
@property(nonatomic,strong)NSString *freqString;
@property(nonatomic,strong)NSString *sinceString;
@property(nonatomic,strong)NSString *titleString;
@end

