//
//  PeakMoment.h
//  Peak
//
//  Created by David LoBosco on 3/29/14.
//  Copyright (c) 2014 David LoBosco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeakMoment : NSObject

@property (nonatomic,strong) UIImage *photo;
@property (nonatomic,strong) NSString *caption;


-(id)initWithImage:(UIImage*)pic;
@end
