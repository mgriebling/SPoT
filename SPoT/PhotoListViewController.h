//
//  PhotoViewController.h
//  SPoT
//
//  Created by Mike Griebling on 27.2.2013.
//  Copyright (c) 2013 Computer Inspirations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoListViewController : UITableViewController

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSString *name;

@end
