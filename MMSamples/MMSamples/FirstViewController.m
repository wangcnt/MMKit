//
//  FirstViewController.m
//  MMSamples
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "FirstViewController.h"

#import <Masonry/Masonry.h>

#import "MMDetectFaceViewController.h"
#import "MMMenuViewController.h"
#import "MMAppearanceViewController.h"

@interface FirstViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSArray<NSString *> *> *> *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"First";
    
    self.dataSource = @[
        @{@"Vision.framework"   : @[@"人脸识别"]},
        @{@"UIKit.framework"       : @[@"UIMenu", @"UIAppearance"]}
    ];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tableView];
    __weak typeof(self) weakedSelf = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakedSelf.tableView.superview);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.dataSource[section].allKeys.lastObject;
}

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section < self.dataSource.count) {
        NSArray *titles = self.dataSource[section].allValues.firstObject;
        if(row < titles.count) {
            return titles[row];
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].allValues.firstObject.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [self titleAtIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:UITableViewRowAnimationMiddle];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *sectionName = self.dataSource[section].allKeys.firstObject;
    if([sectionName containsString:@"Vision."]) {
        if(row == 0) {
            MMDetectFaceViewController *controller = [[MMDetectFaceViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if([sectionName containsString:@"UIKit."]) {
        if(row == 0) {
            MMMenuViewController *controller = [[MMMenuViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        } else if(row == 1) {
            MMAppearanceViewController *controller = [[MMAppearanceViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

@end
