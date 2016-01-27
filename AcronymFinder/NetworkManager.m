
//  Created by Smita Vardhan on 1/26/16.
//  Copyright © 2016 Smita. All rights reserved.
//
#import "NetworkManager.h"
#import "AFNetworking/AFNetworking.h"
#import "Reachability.h"
@implementation NetworkManager


+(NetworkManager*)sharedInstance{
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
    
        sharedInstance = [[NetworkManager alloc]init];
    
    });
    return sharedInstance;
}
-(id)init{

    if (self = [super init]) {
        [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        Reachability *netReachability = [Reachability reachabilityWithHostName:REMOTEHOST_REACHABILITY];
        NetworkStatus netStatus = [netReachability currentReachabilityStatus];
        switch (netStatus) {
            case NotReachable:
                self.isInternetReachable = FALSE;
                break;
              case ReachableViaWiFi:
                self.isInternetReachable = TRUE;
            default:
                break;
        }
        [netReachability startNotifier];
    }
    return self;
}
-(BOOL)checkIfNetworkIsAvailable{
    Reachability *netReachability = [Reachability reachabilityWithHostName:REMOTEHOST_REACHABILITY];
    NetworkStatus netStatus = [netReachability currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:
            self.isInternetReachable = FALSE;
            break;
        case ReachableViaWiFi:
            self.isInternetReachable = TRUE;
        default:
            break;
    }
return self.isInternetReachable;
}

-(void)reachabilityChanged:(NSNotification*)notification{
    Reachability *reachability = notification.object;
    if (NotReachable == reachability.currentReachabilityStatus)
        self.isInternetReachable=FALSE;
    else
        self.isInternetReachable=TRUE;
}

#pragma mark - Service Calls
-(void)serviceCallWithURL:(NSString*)urlString ParameterDict:(NSDictionary*)parameterDictionary CompletionBlock:(void(^)(id responseData))successBlock ErrorBlock:(void(^)(id responseData))errorBlock{

    if (self.isInternetReachable) {
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [manager GET:urlString parameters:parameterDictionary success:^(AFHTTPRequestOperation * operation, id responseObject) {
           // NSLog(@"JSON: %@",responseObject);
            NSDictionary *responseDict= nil;
            //NSArray *responseArray = nil;
            NSError *error = nil;
           if([responseObject length] > 3){
             responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
           }
            if (successBlock) {
                successBlock(responseDict);
            }
           
        } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"JSON: %@",error);
        
            if (errorBlock) {
                errorBlock([operation responseObject]);
            }
       }];
        
    }
}

@end
