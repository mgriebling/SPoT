//
//  PhotoViewController.m
//  SPoT
//
//  Created by Mike Griebling on 27.2.2013.
//  Copyright (c) 2013 Computer Inspirations. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"
#import "PhotoScrollViewController.h"

@interface PhotoViewController ()
@property (nonatomic, strong) NSArray *categoryPhotos;
@property (nonatomic, strong) NSURL *activePhoto;
@end

@implementation PhotoViewController

@synthesize photoCategory = _photoCategory;


- (void)setPhotoCategory:(NSString *)photoCategory {
    _photoCategory = photoCategory;
    self.categoryPhotos = nil;      // force a refresh
}

- (NSString *)photoCategory {
    if (!_photoCategory) _photoCategory = @"";
    return _photoCategory;
}

- (NSArray *)categoryPhotos {
    if (!_categoryPhotos) {
        NSMutableArray *photos = [NSMutableArray array];
        [[FlickrFetcher stanfordPhotos] enumerateObjectsUsingBlock:^(NSDictionary *photo, NSUInteger idx, BOOL *stop) {
            NSString *tags = photo[FLICKR_TAGS];
            if ([tags rangeOfString:self.photoCategory].location != NSNotFound) {
                [photos addObject:photo];
            }
        }];
        _categoryPhotos = photos;
    }
    return _categoryPhotos;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title = [self.photoCategory capitalizedString];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.categoryPhotos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *photo = self.categoryPhotos[indexPath.row];
    cell.textLabel.text = photo[FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = photo[@"description"][@"_content"];
    NSURL *photoURL = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatSquare];
    NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
    cell.imageView.image = [UIImage imageWithData:photoData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *photo = self.categoryPhotos[indexPath.row];
    self.activePhoto = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
    [self performSegueWithIdentifier:@"ShowPhoto" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender {
    if ([segue.identifier isEqualToString:@"ShowPhoto"]) {
        if ([segue.destinationViewController isKindOfClass:[PhotoScrollViewController class]]) {
            PhotoScrollViewController *controller = (PhotoScrollViewController *)segue.destinationViewController;
            controller.title = sender.textLabel.text;
            NSData *photoData = [NSData dataWithContentsOfURL:self.activePhoto];
            controller.photo = [UIImage imageWithData:photoData];
        }
    }
}

@end
