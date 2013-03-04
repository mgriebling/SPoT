//
//  PhotoScrollViewController.m
//  SPoT
//
//  Created by Mike Griebling on 4.3.2013.
//  Copyright (c) 2013 Computer Inspirations. All rights reserved.
//

#import "PhotoScrollViewController.h"
#import "FlickrFetcher.h"

@interface PhotoScrollViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation PhotoScrollViewController

- (void)setPhoto:(UIImage *)photo {
    if (photo != _photo) {
        _photo = photo;
        [self resetImage];
    }
}

- (UIImageView *)imageView {
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

- (void)setTitle:(NSString *)title
{
    super.title = title;
    self.navigationItem.title = title;
}

- (void)resetImage
{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        if (self.photo) {
            self.scrollView.zoomScale = 1.0;
            self.scrollView.contentSize = self.photo.size;
            self.imageView.image = self.photo;
            self.imageView.frame = CGRectMake(0, 0, self.photo.size.width, self.photo.size.height);
        }
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    [self resetImage];
    self.navigationItem.title = self.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
