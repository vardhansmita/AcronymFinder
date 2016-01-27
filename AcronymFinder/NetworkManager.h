
//  Created by Smita Vardhan on 1/26/16.
//  Copyright © 2016 Smita. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Constant.h"


@interface NetworkManager : NSObject

@property(nonatomic,assign)BOOL isInternetReachable;
+(NetworkManager*)sharedInstance;
-(BOOL)checkIfNetworkIsAvailable;
-(void)serviceCallWithURL:(NSString*)urlString ParameterDict:(NSDictionary*)parameterDictionary CompletionBlock:(void(^)(id responseData))successBlock ErrorBlock:(void(^)(id responseData))errorBlock;

@end
