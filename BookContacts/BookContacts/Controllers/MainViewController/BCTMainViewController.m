//
//  BCTMainViewController.m
//  BookContacts
//
//  Created by Chausov Alexander on 11/12/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//

#import "BCTMainViewController.h"
#import "BCTSearchTableViewCell.h"
#import "BCTContactTableViewCell.h"
#import "BCTThemeConstant.h"
#import "BCTContactViewController.h"

#import "BCTDataBaseManager.h"
#import "BCTContact.h"

#import "NSString+Extension.h"
#import <MGSwipeTableCell/MGSwipeTableCell.h>

static NSString *const searchCellReuseIdentifier = @"searchCellReuseIdentifier";
static NSString *const contactCellReuseIdentifier = @"contactCellReuseIdentifier";

@interface BCTMainViewController () <UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate, BCTSearchTableViewCellDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray <BCTContact *> *contacts;

@property (nonatomic, assign) BOOL showingLiked;

@end

@implementation BCTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigationBar];
    [self configureTableView];
    
    [self configureStyle];
    
    self.showingLiked = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshTable];
}

- (void)refreshTable {
    if (self.showingLiked) {
        self.contacts = [[BCTDataBaseManager sharedInstance] findAndSortLikedContacts];
    } else {
        self.contacts = [[BCTDataBaseManager sharedInstance] findAndSortAllContacts];
    }
    [self.tableView reloadData];
}

- (void)filterContactsByString:(NSString *)searchString {
    NSArray *contacts;
    if (self.showingLiked) {
        contacts = [[BCTDataBaseManager sharedInstance] findAndSortLikedContacts];
    } else {
        contacts = [[BCTDataBaseManager sharedInstance] findAndSortAllContacts];
    }
    
    if ([searchString isEqualToString:@""]) {
        self.contacts = contacts;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationLeft];
        return;
    }
    
    searchString = [searchString stringByAppendingString:@"*"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE[c] %@", searchString];
    NSArray *filteredByName = [contacts filteredArrayUsingPredicate:predicate];
    
    predicate = [NSPredicate predicateWithFormat:@"mainPhoneNumber LIKE[c] %@", searchString];
    NSArray *filteredByPhone = [contacts filteredArrayUsingPredicate:predicate];
    
    NSArray *newContacts = [filteredByName arrayByAddingObjectsFromArray:filteredByPhone];
    UITableViewRowAnimation animationType = newContacts.count != self.contacts.count ? UITableViewRowAnimationLeft : UITableViewRowAnimationNone;
    self.contacts = newContacts;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:animationType];
}

- (void)configureStyle {
    self.view.backgroundColor = mainBackgroundThemeNrmColor;
    self.tableView.backgroundColor = mainBackgroundThemeNrmColor;
}

- (void)configureNavigationBar {
    self.navigationItem.title = @"Список контактов";
    
    UIImage *image = [UIImage imageNamed:@"ic_add.png"];
    CGRect imgFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:imgFrame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addContact) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *addContactButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = addContactButton;
}

- (void)configureTableView {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BCTSearchTableViewCell class]) bundle:nil] forCellReuseIdentifier:searchCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BCTContactTableViewCell class]) bundle:nil] forCellReuseIdentifier:contactCellReuseIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)addContact {
    BCTContactViewController *ctrl = [[BCTContactViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BCTSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellReuseIdentifier];
        cell.cellDelegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        BCTContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contactCellReuseIdentifier];
        BCTContact *contact = self.contacts[indexPath.row];
        NSString *fullName = contact.name;
        if ([contact.surname notEmpty]) {
            fullName = [fullName stringByAppendingString:[NSString stringWithFormat:@" %@", contact.surname]];
        }
        [cell configureWithFullName:fullName phone:contact.mainPhoneNumber likedFlag:contact.liked];
        cell.delegate = self;
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BCTContact *contact = self.contacts[indexPath.row];
    BCTContactViewController *ctrl = [[BCTContactViewController alloc] initWithContact:contact];
    [self.navigationController pushViewController:ctrl animated:YES];
    [self.tableView endEditing:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.tableView endEditing:YES];
}

#pragma mark - BCTSearchTableViewCellDelegate
- (void)likedButtonDidPress {
    self.showingLiked = !self.showingLiked;
    [self refreshTable];
}

- (void)searchTextFieldTextDidChange:(NSString *)searchString {
    [self filterContactsByString:searchString];
}

- (void)searchTextFieldDidClear {
    [self filterContactsByString:@""];
}

#pragma mark - MGSwipeTableCellDelegate
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction {
    return direction == MGSwipeDirectionLeftToRight;
}

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BCTContact *contact = self.contacts[indexPath.row];
    [[BCTDataBaseManager sharedInstance] deleteContactFromDB:contact];
    [self refreshTable];
    return YES;
}

@end
