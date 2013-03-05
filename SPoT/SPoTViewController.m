//
//  SPoTViewController.m
//  SPoT
//
//  Created by Mike Griebling on 26.2.2013.
//  Copyright (c) 2013 Computer Inspirations. All rights reserved.
//

#import "SPoTViewController.h"
#import "FlickrFetcher.h"
#import "PhotoListViewController.h"

@interface SPoTViewController ()

@property (nonatomic, strong) NSCountedSet *tags;
@property (nonatomic, strong) NSArray *locations;

@end

@implementation SPoTViewController

#pragma mark - Gettters/Setters

- (NSSet *)tags {
    if (!_tags) _tags = [[NSCountedSet alloc] init];
    return _tags;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Organize photos by tag
    NSArray *photos = [FlickrFetcher stanfordPhotos];
    [photos enumerateObjectsUsingBlock:^(NSDictionary *photo, NSUInteger idx, BOOL *stop) {
        NSArray *tags = [(NSString *)photo[FLICKR_TAGS] componentsSeparatedByString:@" "];
        [tags enumerateObjectsUsingBlock:^(NSString *tag, NSUInteger idx, BOOL *stop) {
            if (![tag isEqualToString:@"portrait"] && ![tag isEqualToString:@"landscape"] && ![tag isEqualToString:@"cs193pspot"]) {
                [self.tags addObject:[tag capitalizedString]];
            }
        }];
    }];
    
    // Create a sorted array
    self.locations = [[self.tags allObjects] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *tag = self.locations[indexPath.row];
    cell.textLabel.text = tag;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [self.tags countForObject:tag]];
    return cell;
}

- (NSArray *)photosInCategory:(NSString *)category {
    NSMutableArray *photos = [NSMutableArray array];
    [[FlickrFetcher stanfordPhotos] enumerateObjectsUsingBlock:^(NSDictionary *photo, NSUInteger idx, BOOL *stop) {
        NSString *tags = photo[FLICKR_TAGS];
        if ([tags rangeOfString:category].location != NSNotFound) {
            [photos addObject:photo];
        }
    }];
    return photos;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender {
    if ([segue.identifier isEqualToString:@"ShowPhotoList"]) {
        if ([segue.destinationViewController isKindOfClass:[PhotoListViewController class]]) {
            PhotoListViewController *controller = (PhotoListViewController *)segue.destinationViewController;
            controller.photos = [self photosInCategory:[sender.textLabel.text lowercaseString]];
            controller.name = sender.textLabel.text;
        }
    }
}

@end
