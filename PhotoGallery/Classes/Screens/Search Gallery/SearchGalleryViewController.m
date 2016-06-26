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
#import "DefaultCollectionViewDelegate.h"
#import "SearchGalleryViewModel.h"
#import "PhotoViewCell.h"

#import "RACCommand.h"
#import "UIRefreshControl+RACCommandSupport.h"
#import "UIColor+PhotoGallery.h"
#import "UICollectionView+EmptyState.h"

static CGFloat const kGalleryCollectionViewBottomInset = 45.0f;

@interface SearchGalleryViewController () <UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) DefaultCollectionViewDataSource *collectionViewDataSource;
@property (nonatomic, strong) DefaultCollectionViewDelegate *collectionViewDelegate;

@property (nonatomic, strong) SearchGalleryViewModel *viewModel;

@end

@implementation SearchGalleryViewController

- (instancetype)initWithViewModel:(SearchGalleryViewModel *)viewModel {
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor pg_lightBackgroundColor];

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
        [_searchController.searchBar sizeToFit];
        _searchController.dimsBackgroundDuringPresentation = YES;
        _searchController.hidesNavigationBarDuringPresentation = NO;

        UISearchBar *searchBar = _searchController.searchBar;
        searchBar.searchBarStyle = UISearchBarStyleMinimal;
        searchBar.tintColor = [UIColor whiteColor];
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        searchBar.placeholder = @"";
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
    self.collectionViewDelegate = [[DefaultCollectionViewDelegate alloc] initWithViewModel:self.viewModel];
    self.collectionView.delegate = self.collectionViewDelegate;

    [self setupCollectionViewEmptyState];

    [self setupCollectionViewRefreshControl];
}

- (void)setupCollectionViewEmptyState {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor pg_lightBackgroundColor];
    label.text = @"Start searching...";
    label.textAlignment = NSTextAlignmentCenter;
    self.collectionView.pg_emptyStateView = label;
}

- (void)setupCollectionViewRefreshControl {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.rac_command = self.viewModel.reloadCommand;
    [self.collectionView addSubview:refreshControl];
}

#pragma mark - SearchBar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (searchBar.text.length > 0) {
        // This avoids the text being stretched by the UISearchBar.
        [searchBar setShowsCancelButton:YES animated:YES];
    }
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    NSLog(@"SearchBar text: %@", searchText);
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    [self.searchController setActive:NO];
    self.searchBar.text = searchText;
    self.viewModel.searchText = searchText;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //Added delay for UISearchController specific animations
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.searchBar.text = self.viewModel.searchText;
    });
}

#pragma mark - SearchResultsUpdater

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    //TODO: update auto suggestion controller with new search text
    NSLog(@"Update auto suggestion");
}


@end
