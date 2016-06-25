//
//  SearchGalleryViewController.m
//  PhotoGallery
//
//  Created by Eugene on 6/25/16.
//  Copyright © 2016 Tulusha.com. All rights reserved.
//

#import "SearchGalleryViewController.h"

@interface SearchGalleryViewController () <UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation SearchGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.definesPresentationContext = YES;

    self.navigationItem.titleView = self.searchBar;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchButtonPressed:(id)sender {
    [self.searchController setActive:YES];
    [self.searchBar becomeFirstResponder];
}

#pragma mark - Search UI Helpers

- (UISearchBar *)searchBar {
    return self.searchController.searchBar;
}

- (UISearchController *)searchController {
    if (!_searchController) {

        UIViewController *resultsController = nil; //TODO: add suggestion controller

        _searchController = [[UISearchController alloc] initWithSearchResultsController:resultsController];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = YES;
        _searchController.hidesNavigationBarDuringPresentation = NO;

        UISearchBar *searchBar = _searchController.searchBar;
        searchBar.placeholder = @"Search...";
        searchBar.clipsToBounds = NO;
        searchBar.delegate = self;
    }
    return _searchController;
}

#pragma mark - SearchBar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    [self.searchController setActive:NO];
    self.searchBar.text = searchText;
    
    //TODO: start searching
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

}

#pragma mark - SearchResultsUpdater

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    //TODO: update auto suggestion controller with new search text
}

@end
