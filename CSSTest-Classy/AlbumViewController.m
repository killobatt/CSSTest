//
//  DetailViewController.m
//  CSSTest-Classy
//
//  Created by Vjacheslav Volodjko on 09.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumTracksViewController.h"

@interface AlbumViewController ()

@property (weak, nonatomic) IBOutlet UILabel *albumTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;

@property (strong, nonatomic) NSDateFormatter *yearFormatter;
@property (strong, nonatomic) AlbumTracksViewController *tracksController;

@end

@implementation AlbumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.yearFormatter = [NSDateFormatter new];
    self.yearFormatter.dateFormat = @"yyyy";
    // Do any additional setup after loading the view, typically from a nib.
    [self updateUI];
}

- (void)setAlbum:(MPMediaItemCollection *)album
{
    if (_album != album) {
        _album = album;
        [self updateUI];
    }
}

- (void)updateUI
{
    // Update the user interface for the detail item.
    if (self.album) {
        NSString *albumTitle = [self.album.representativeItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        self.albumTitleLabel.text = albumTitle;
        self.title = albumTitle;
        
        self.artistLabel.text = [self.album.representativeItem valueForProperty:MPMediaItemPropertyArtist];
        
        NSDate *date = [self.album.representativeItem valueForProperty:MPMediaItemPropertyReleaseDate];
        if (date) {
            self.yearLabel.text = [self.yearFormatter stringFromDate:date];
        } else {
            self.yearLabel.hidden = YES;
        }
        
        self.genreLabel.text = [self.album.representativeItem valueForProperty:MPMediaItemPropertyGenre];
        
        MPMediaItemArtwork *artwork = [self.album.representativeItem valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork) {
            self.artworkImageView.image = [artwork imageWithSize:self.artworkImageView.frame.size];
        }
    }
    self.tracksController.album = self.album;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EmbedAlbumTracks"]) {
        self.tracksController = (AlbumTracksViewController *)segue.destinationViewController;
        self.tracksController.album = self.album;
    }
}

@end
