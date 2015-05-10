//
//  MasterViewController.m
//  CSSTest-Classy
//
//  Created by Vjacheslav Volodjko on 09.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

#import "AlbumListViewController.h"
#import "AlbumViewController.h"
#import "AlbumTableViewCell.h"

@interface AlbumListViewController ()
@property MPMediaQuery *query;
@end

@implementation AlbumListViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.query = [MPMediaQuery albumsQuery];
    [self.tableView reloadData];
    
    self.detailViewController = (AlbumViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MPMediaItemCollection *)albumAtIndexPath:(NSIndexPath *)indexPath
{
    MPMediaQuerySection *mediaSection = self.query.collectionSections[indexPath.section];
    return self.query.collections[mediaSection.range.location + indexPath.row];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"AlbumDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MPMediaItemCollection *albumItem = [self albumAtIndexPath:indexPath];
        AlbumViewController *controller = (AlbumViewController *)[[segue destinationViewController] topViewController];
        [controller setAlbum:albumItem];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.query.collectionSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MPMediaQuerySection *mediaSection = self.query.collectionSections[section];
    return mediaSection.range.length;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MPMediaQuerySection *mediaSection = self.query.collectionSections[section];
    return mediaSection.title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumCell" forIndexPath:indexPath];
    
    MPMediaItemCollection *albumItem = [self albumAtIndexPath:indexPath];
    cell.album = albumItem;
    return cell;
}

// return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.query valueForKeyPath:@"collectionSections.@unionOfObjects.title"];
}

 // tell table which section corresponds to section title/index (e.g. "B",1))
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

@end
