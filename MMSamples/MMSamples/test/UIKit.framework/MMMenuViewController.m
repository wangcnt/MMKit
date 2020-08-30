//
//  MMMenuViewController.m
//  MMSamples
//
//  Created by Mark on 2020/7/14.
//  Copyright © 2020 Mark. All rights reserved.
//

#import "MMMenuViewController.h"

#import <Masonry/Masonry.h>
#import <MMRuntime/MMRuntime.h>

@interface MMMenuViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<NSString *> *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MMMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataSource = @[@"Vision.framework",
                        @"UIKit.framework"
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

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath {
    __unused NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(row < self.dataSource.count) {
        return self.dataSource[row];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
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
}

- (UIContextMenuConfiguration *)tableView:(UITableView *)tableView contextMenuConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point  API_AVAILABLE(ios(13.0)) {
    NSString *identifier = [NSString stringWithFormat:@"identifier - %ld", indexPath.row];
    return [UIContextMenuConfiguration configurationWithIdentifier:identifier previewProvider:^UIViewController * _Nullable{
        MMURI *uri = [MMURI URIWithString:@"ui://com.mark.halo.time/main"];
        UIViewController *controller = [[MMAccessor sharedInstance] resourceWithURI:uri];
        return controller;
    } actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        UIAction *sayHelloAction = [UIAction actionWithTitle:@"Hello, world!" image:[UIImage imageNamed:@"laoganma"] identifier:@"sayHelloAction" handler:^(__kindof UIAction * _Nonnull action) {
            NSLog(@"Hello, world!");
        }];
        
        UIAction *copyAction = [UIAction actionWithTitle:@"Copy" image:[UIImage systemImageNamed:@"pencil.and.outline"] identifier:@"copyAction" handler:^(__kindof UIAction * _Nonnull action) {
            NSLog(@"Copying.....");
        }];
        
        UIAction *cutAction = [UIAction actionWithTitle:@"Cut" image:[UIImage removeImage] identifier:@"removeAction" handler:^(__kindof UIAction * _Nonnull action) {
            NSLog(@"Cutting.....");
        }];
        
        UIAction *pasteAction = [UIAction actionWithTitle:@"Paste" image:[UIImage addImage] identifier:@"addAction" handler:^(__kindof UIAction * _Nonnull action) {
            NSLog(@"Pasting.....");
        }];
        
        UIAction *selectAction = [UIAction actionWithTitle:@"Select" image:[UIImage checkmarkImage] identifier:@"selectAction" handler:^(__kindof UIAction * _Nonnull action) {
            NSLog(@"selecting.....");
        }];
        
        UIAction *selectAllAction = [UIAction actionWithTitle:@"Select All" image:[UIImage strokedCheckmarkImage] identifier:@"selectAllAction" handler:^(__kindof UIAction * _Nonnull action) {
            NSLog(@"selecting all.....");
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:@"I'm a menu." image:[UIImage checkmarkImage] identifier:@"" options:UIMenuOptionsDisplayInline children:@[sayHelloAction, copyAction, cutAction, pasteAction, selectAction, selectAllAction]];
        
        return menu;
    }];
}

//- (UITargetedPreview *)tableView:(UITableView *)tableView previewForHighlightingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration  API_AVAILABLE(ios(13.0)){
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    return [[UITargetedPreview alloc] initWithView:cell];
//}

@end
