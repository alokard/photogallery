//
//  SearchGalleryViewController.m
//  PhotoGallery
//
//  Created by Eugene on 6/25/16.
//  Copyright © 2016 Tulusha.com. All rights reserved.
//

#import "SearchGalleryViewController.h"
#import "AutoUpdatingLayout.h"
#import "DefaultCollectionViewDataSource.h"
#import "RACCommand.h"
#import "DefaultCollectionViewDelegate.h"
#import "UIRefreshControl+RACCommandSupport.h"
#import "SearchGalleryViewModel.h"
#import "PhotoViewCell.h"

static CGFloat const kGalleryCollectionViewBottomInset = 45.0f;

@interface SearchGalleryViewController () <UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) DefaultCollectionViewDataSource *collectionViewDataSource;
@property (nonatomic, strong) DefaultCollectionViewDelegate *collectionViewDelegate;

@property (nonatomic, strong) SearchGalleryViewModel *viewModel;

@end

@implementation SearchGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.viewModel = [[SearchGalleryViewModel alloc] initWithRouter:nil searchService:nil];

    self.definesPresentationContext = YES;

    self.navigationItem.titleView = self.searchBar;
    [self setupCollectionView];
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

- (void)setupCollectionView {
    UICollectionViewLayout *layout = [[AutoUpdatingLayout alloc] initWithBounds:self.view.bounds];

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;

    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, kGalleryCollectionViewBottomInset, 0)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeTop;

    self.collectionViewDataSource = [[DefaultCollectionViewDataSource alloc] initWithCollectionView:self.collectionView
                                                                                          cellClass:[PhotoViewCell class]
                                                                                            storage:self.viewModel.storage];
    self.collectionViewDelegate = [DefaultCollectionViewDelegate new];
    self.collectionView.delegate = self.collectionViewDelegate;

    [self setupCollectionViewRefreshControl];
}

- (void)setupCollectionViewRefreshControl {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.rac_command = self.viewModel.reloadCommand;
    [self.collectionView addSubview:refreshControl];
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
