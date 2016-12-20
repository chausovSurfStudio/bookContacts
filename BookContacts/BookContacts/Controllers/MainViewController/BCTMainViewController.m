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
#import "BCTPhoneNumber.h"

#import "NSString+Extension.h"

static NSString *const searchCellReuseIdentifier = @"searchCellReuseIdentifier";
static NSString *const contactCellReuseIdentifier = @"contactCellReuseIdentifier";

@interface BCTMainViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray <BCTContact *> *contacts;

@end

@implementation BCTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigationBar];
    [self configureTableView];
    
    [self configureStyle];
    
    self.contacts = [[BCTDataBaseManager sharedInstance] findAndSortAllContacts];
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
        return cell;
    }
    if (indexPath.section == 1) {
        BCTContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contactCellReuseIdentifier];
        BCTContact *contact = self.contacts[indexPath.row];
        NSString *fullName = contact.name;
        if ([contact.surname notEmpty]) {
            fullName = [fullName stringByAppendingString:[NSString stringWithFormat:@" %@", contact.surname]];
        }
        [cell configureWithFullName:fullName phone:contact.mainPhoneNumber.phoneNumber likedFlag:contact.liked];
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

@end
