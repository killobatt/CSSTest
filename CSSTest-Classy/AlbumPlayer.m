//
//  AlbumPlayer.m
//  CSSTest-Classy
//
//  Created by Vjacheslav Volodjko on 11.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

#import "AlbumPlayer.h"

@interface AlbumPlayer ()
@property (strong, readwrite, nonatomic) MPMusicPlayerController *player;
@property (strong, readwrite, nonatomic) MPMediaItemCollection *album;
@end

@implementation AlbumPlayer

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.player = [[MPMusicPlayerController alloc] init];
    }
    return self;
}

- (void)setAlbum:(MPMediaItemCollection *)album currentItem:(NSUInteger)currentItem
{
    self.album = album;
    [self.player setQueueWithItemCollection:self.album];
    
    self.player.nowPlayingItem = album.items[currentItem];
}

@end
