//
//  MasterViewController.h
//  CSSTest-Classy
//
//  Created by Vjacheslav Volodjko on 09.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

@import UIKit;
@import MediaPlayer;

@class AlbumViewController;

@interface AlbumListViewController : UITableViewController

@property (strong, nonatomic) AlbumViewController *detailViewController;


@end

