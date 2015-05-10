//
//  TrackTableViewCell.m
//  CSSTest-Classy
//
//  Created by Vjacheslav Volodjko on 10.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

#import "TrackTableViewCell.h"

@interface TrackTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *trackTitle;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end

@implementation TrackTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTrack:(MPMediaItem *)track
{
    _track = track;

    self.trackTitle.text = self.track.title;
    
    NSUInteger hours = (NSUInteger)round(self.track.playbackDuration / 3600);
    NSUInteger minutes = (NSUInteger)round(self.track.playbackDuration / 60) % 60;
    NSUInteger seconds = (NSUInteger)round(self.track.playbackDuration) % 60;
    if (hours > 0) {
        self.durationLabel.text = [NSString stringWithFormat:@"%ld:%.2ld:%.2ld", hours, minutes, seconds];
    } else {
        self.durationLabel.text = [NSString stringWithFormat:@"%ld:%.2ld", minutes, seconds];
    }
}

@end
