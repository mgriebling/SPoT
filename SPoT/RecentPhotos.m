//
//  RecentPhotos.m
//  SPoT
//
//  Created by Mike Griebling on 5.3.2013.
//  Copyright (c) 2013 Computer Inspirations. All rights reserved.
//

#import "RecentPhotos.h"
#import "FlickrFetcher.h"

@implementation RecentPhotos

#define USER_PHOTOS   @"RecentPhotos.photos"
#define MAX_PHOTOS    20

+ (NSArray *)photos {
    return [RecentPhotos getPhotos];
}

+ (NSMutableArray *)getPhotos {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *photos = [[defaults arrayForKey:USER_PHOTOS] mutableCopy];
    if (!photos) photos = [NSMutableArray array];
    return photos;
}

+ (void)savePhotos:(NSArray *)photos {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:photos forKey:USER_PHOTOS];
}

+ (void)addPhoto:(NSDictionary *)photo {
    NSMutableArray *photos = [RecentPhotos getPhotos];
    
    // look for duplicate photos
    __block BOOL duplicate = NO;
    [photos enumerateObjectsUsingBlock:^(NSDictionary *existingPhoto, NSUInteger idx, BOOL *stop) {
        if ([existingPhoto[FLICKR_PHOTO_ID] isEqual:photo[FLICKR_PHOTO_ID]]) {
            duplicate = YES; *stop = YES;
        }
    }];
    
    if (!duplicate) {
        [photos insertObject:photo atIndex:0];
        if (photos.count > MAX_PHOTOS) {
            [photos removeLastObject];
        }
        [RecentPhotos savePhotos:photos];
    }
}

@end
