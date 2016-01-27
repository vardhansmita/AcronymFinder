//  Created by Smita Vardhan on 1/26/16.
//  Copyright © 2016 Smita. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface AcronymObject : NSObject

@property(nonatomic,strong)NSNumber *frequency;
@property(nonatomic,strong)NSString *lfString;
@property(nonatomic,strong)NSNumber *since;
-(id)initWithFrequency:(NSNumber*)cFrequency lfString:(NSString*)clfString since:(NSNumber*)cSince;
@end

