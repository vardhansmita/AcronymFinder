//  Created by Smita Vardhan on 1/26/16.
//  Copyright © 2016 Smita. All rights reserved.
//
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "NetworkManager.h"
#import "AcronymObject.h"
#import "AcronymTableViewCell.h"
#import "MBProgressHUD.h"


@interface MasterViewController ()

@property NSMutableArray *objects;
@property NSMutableArray *acronymArray;
@property NSMutableArray *searchArray;
@property AcronymObject *acObj;
@property MBProgressHUD *hud;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.searchBar.delegate = self;
    self.acronymArray = [[NSMutableArray alloc]init];
    self.searchArray = [[NSMutableArray alloc]init];
    self.acObj   = [[AcronymObject alloc]init];
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
   
}



- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
       self.acObj = self.acronymArray[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.sinceString = [self.acObj.since stringValue];
        controller.fullString = self.acObj.lfString;
        controller.freqString = [self.acObj.frequency stringValue];
        controller.titleString = self.searchBar.text;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}
#pragma mark - SearchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

 [self getDealsFromServer];
 [self.searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.acronymArray removeAllObjects];
 

}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
[self.acronymArray removeAllObjects];
[self.tableView reloadData];
    if ([self.searchBar.text length] == 0)
    {
        [self.searchBar performSelector:@selector(resignFirstResponder)
                             withObject:nil
                             afterDelay:0];
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar {
    [self.searchBar  resignFirstResponder];
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.acronymArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AcronymTableViewCell *cell = (AcronymTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    self.acObj = self.acronymArray[indexPath.row];
    if (self.acObj.since!=nil) {
        cell.SinceLable.text =[self.acObj.since stringValue];
    }
    if (self.acObj.lfString!=nil) {
         cell.lsLable.text = self.acObj.lfString;
    }
    if (self.acObj.frequency!=nil) {
         cell.frequencyLable.text = [self.acObj.frequency stringValue];
    }
   
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   [self.hud hide:YES];
    return cell;
}

-(void)getDealsFromServer{
    if ([[NetworkManager sharedInstance]isInternetReachable]==TRUE) {
    NSString *searchString= self.searchBar.text;
    if ([searchString length] >= 2) {
        NSString *url = [NSString stringWithFormat:SERVICE_URL,searchString];
        [[NetworkManager sharedInstance]serviceCallWithURL:url ParameterDict:nil CompletionBlock:^(id responseData) {
            if (responseData) {
                [self parseAcronym:responseData];
                [self.tableView reloadData];
                [self startHud];
            }
        } ErrorBlock:^(id responseData) {
            [self.hud hide:YES];
        }];
  
    }
    else{
    
        UIAlertController *alertController =[UIAlertController alertControllerWithTitle:@"Invalid Acronym" message:@"Please enter atleast 2 Letters for search" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
}
    }else{
        UIAlertController *alertController =[UIAlertController alertControllerWithTitle:@"Network Error" message:@"Please Check your Network Setting" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
 }

}
-(void)parseAcronym:(NSMutableDictionary *)dictionary{
    if (![dictionary isKindOfClass:[NSNull class]] ) {
        
        for (NSDictionary *dict in dictionary) {
            NSArray *lfs = [dict objectForKey:@"lfs"];
            for (NSDictionary *tempDict in lfs) {
                NSNumber *freq = [tempDict objectForKey:@"freq"];
                NSNumber *since = [tempDict objectForKey:@"since"];
                NSString *lf = [tempDict objectForKey:@"lf"];
                NSArray *varArray = [tempDict objectForKey:@"vars"];
                for (NSDictionary *varDict in varArray) {
                    NSNumber *freq = [varDict objectForKey:@"freq"];
                    NSNumber *since = [varDict objectForKey:@"since"];
                    NSString *lf = [varDict objectForKey:@"lf"];
                    [self.acronymArray addObject:[[AcronymObject alloc]initWithFrequency:freq lfString:lf since:since]];
                }
             [self.acronymArray addObject:[[AcronymObject alloc]initWithFrequency:freq lfString:lf since:since]];
  
        }
           
        
        }
    }else{
        NSLog(@"Empty Response");
    
    }

}
#pragma MBProgresshud
-(void)startHud{

    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    self.hud.labelText = @"Loading";
    [self.hud show:YES];

}
@end
