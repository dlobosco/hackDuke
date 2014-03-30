//
//  PeakMoment.m
//  Peak
//
//  Created by David LoBosco on 3/29/14.
//  Copyright (c) 2014 David LoBosco. All rights reserved.
//

#import "PeakMoment.h"

@implementation PeakMoment

-(id)initWithImage:(UIImage *)pic{
    self = [super init];
    if(self){
        self.photo = pic;
        self.caption = @"";
    }
    return self;
}

-(NSString*)description{
    return [NSString stringWithFormat:@"\rImage Address: %@, Caption: %@",self.photo,self.caption];
}

@end
