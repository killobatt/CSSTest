//
//  AlbumTableViewCell.m
//  CSSTest-Classy
//
//  Created by Vjacheslav Volodjko on 10.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

#import "AlbumTableViewCell.h"

@interface AlbumTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *albumArtworkImageView;
@property (weak, nonatomic) IBOutlet UILabel *albumTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *tracksCountLabel;


@end

@implementation AlbumTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAlbum:(MPMediaItemCollection *)album
{
    _album = album;
    self.albumTitleLabel.text = [self.album.representativeItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    self.artistLabel.text = [self.album.representativeItem valueForProperty:MPMediaItemPropertyArtist];
    self.tracksCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.album.count];
    
    MPMediaItemArtwork *artwork = [self.album.representativeItem valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork) {
        self.albumArtworkImageView.image = [artwork imageWithSize:self.albumArtworkImageView.frame.size];
    }
}

@end
