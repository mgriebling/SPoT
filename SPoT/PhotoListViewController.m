//
//  PhotoViewController.m
//  SPoT
//
//  Created by Mike Griebling on 27.2.2013.
//  Copyright (c) 2013 Computer Inspirations. All rights reserved.
//

#import "PhotoListViewController.h"
#import "FlickrFetcher.h"
#import "PhotoScrollViewController.h"
#import "RecentPhotos.h"

@interface PhotoListViewController ()
@property (nonatomic, strong) NSURL *activePhoto;
@end

@implementation PhotoListViewController

@synthesize photos = _photos;


- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    [self.tableView reloadData];
}

- (NSArray *)photos {
    if (!_photos) _photos = @[];
    return _photos;
}

- (void)setName:(NSString *)name {
    _name = [name capitalizedString];
    self.navigationItem.title = _name;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title = self.title;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *photo = self.photos[indexPath.row];
    cell.textLabel.text = photo[FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = photo[@"description"][@"_content"];
    NSURL *photoURL = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatSquare];
    NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
    cell.imageView.image = [UIImage imageWithData:photoData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *photo = self.photos[indexPath.row];
    [RecentPhotos addPhoto:photo];
    self.activePhoto = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
    [self performSegueWithIdentifier:@"ShowPhoto" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender {
    if ([segue.identifier hasPrefix:@"ShowPhoto"]) {
        if ([segue.destinationViewController isKindOfClass:[PhotoScrollViewController class]]) {
            PhotoScrollViewController *controller = (PhotoScrollViewController *)segue.destinationViewController;
            controller.title = sender.textLabel.text;
            NSData *photoData = [NSData dataWithContentsOfURL:self.activePhoto];
            controller.photo = [UIImage imageWithData:photoData];
        }
    }
}

@end
