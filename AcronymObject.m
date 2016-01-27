//  Created by Smita Vardhan on 1/26/16.
//  Copyright © 2016 Smita. All rights reserved.
//
#import "AcronymObject.h"

@implementation AcronymObject

-(id)initWithFrequency:(NSNumber*)cFrequency lfString:(NSString*)clfString since:(NSNumber*)cSince{

    self = [super init];
    if (self) {
        self.frequency = cFrequency;
        self.lfString = clfString;
        self.since = cSince;
    }

    return self;
}

@end
