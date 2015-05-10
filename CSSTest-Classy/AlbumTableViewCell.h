//
//  AlbumTableViewCell.h
//  CSSTest-Classy
//
//  Created by Vjacheslav Volodjko on 10.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

@import UIKit;
@import MediaPlayer;

@interface AlbumTableViewCell : UITableViewCell

@property (strong, nonatomic) MPMediaItemCollection *album;

@end
