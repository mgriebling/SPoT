//
//  RecentsViewController.m
//  SPoT
//
//  Created by Mike Griebling on 5.3.2013.
//  Copyright (c) 2013 Computer Inspirations. All rights reserved.
//

#import "RecentsViewController.h"
#import "RecentPhotos.h"


@implementation RecentsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photos = [RecentPhotos photos];
    self.name = @"Recent Photos";
}


@end
