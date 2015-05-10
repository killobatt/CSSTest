//
//  MasterViewController.h
//  CSSTest-Interfa
//
//  Created by Vjacheslav Volodjko on 09.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

