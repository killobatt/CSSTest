//
//  DetailViewController.h
//  CSSTest-Interfa
//
//  Created by Vjacheslav Volodjko on 09.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

