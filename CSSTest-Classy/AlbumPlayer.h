//
//  AlbumPlayer.h
//  CSSTest-Classy
//
//  Created by Vjacheslav Volodjko on 11.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

@import Foundation;
@import MediaPlayer;

@interface AlbumPlayer : NSObject

+ (instancetype)sharedInstance;

@property (strong, readonly, nonatomic) MPMusicPlayerController *player;
@property (strong, readonly, nonatomic) MPMediaItemCollection *album;
- (void)setAlbum:(MPMediaItemCollection *)album currentItem:(NSUInteger)currentItem;
@end
