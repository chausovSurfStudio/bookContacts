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
    self.navigationItem.title = @"Список контактов";
    [self configureTableView];
    
    self.contacts = [[BCTDataBaseManager sharedInstance] findAndSortAllContacts];
}

- (void)configureTableView {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BCTSearchTableViewCell class]) bundle:nil] forCellReuseIdentifier:searchCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BCTContactTableViewCell class]) bundle:nil] forCellReuseIdentifier:contactCellReuseIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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

@end
