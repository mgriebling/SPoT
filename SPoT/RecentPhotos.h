//
//  RecentPhotos.h
//  SPoT
//
//  Created by Mike Griebling on 5.3.2013.
//  Copyright (c) 2013 Computer Inspirations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentPhotos : NSObject

+ (NSArray *)photos;
+ (void)addPhoto:(NSDictionary *)photo;

@end
