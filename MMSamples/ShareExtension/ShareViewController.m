//
//  ShareViewController.m
//  ShareExtension
//
//  Created by Mark on 2020/7/12.
//  Copyright © 2020 Mark. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *shareIdentifier;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shareIdentifier = [NSUUID UUID].UUIDString;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:tableView];
    
    __weak typeof(self) weakedSelf = self;
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.mark.mmsample"];
    NSURL *directoryURL = [containerURL URLByAppendingPathComponent:_shareIdentifier];
    
    // 将 file:/// 转成 /
    NSString *directoryURLString = directoryURL.absoluteString;
    directoryURLString = [directoryURLString stringByReplacingOccurrencesOfString:@"file:///" withString:@"/"];
    
    
    [[NSFileManager defaultManager] createDirectoryAtPath:directoryURLString withIntermediateDirectories:YES attributes:nil error:nil];
    
    for(NSExtensionItem *item in self.extensionContext.inputItems) {
        for(NSItemProvider *provider in item.attachments) {
            if([provider hasItemConformingToTypeIdentifier:@"public.image"]) {
                [provider loadItemForTypeIdentifier:@"public.image" options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                    NSLog(@"");
                    NSURL *URL = (NSURL *)item;
                    NSString *URLString = URL.absoluteString;
                    URLString = [URLString stringByReplacingOccurrencesOfString:@"file:///" withString:@"/"];
                    
                    NSString *newURLString = [directoryURLString stringByAppendingPathComponent:URL.lastPathComponent];
                    [[NSFileManager defaultManager] copyItemAtPath:URLString toPath:newURLString error:nil];
                }];
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSInteger row = indexPath.row;
    NSString *title = (row == 0 ? @"What the hell?" : @"WTF?");
    cell.textLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:UITableViewRowAnimationMiddle];
    
    NSInteger row = indexPath.row;
    if(row == 0) {
        [self post];
    } else {
        [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
    }
}

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)post {
    NSURLComponents *URLComponents = [NSURLComponents componentsWithString:@"mmsamplescheme://com.mark.mmsample/shareimage"];
    URLComponents.query = [NSString stringWithFormat:@"identifier=%@", _shareIdentifier];
    if(YES) {
        UIResponder *responder = self;
        while ((responder = [responder nextResponder]) != nil) {
            if ([responder respondsToSelector:@selector(openURL:)] == YES) {
                [responder performSelector:@selector(openURL:) withObject:URLComponents.URL];
            }
        }
    } else {
        [self.extensionContext openURL:URLComponents.URL completionHandler:^(BOOL success) {
            NSLog(@"");
            [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
        }];
    }
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    [self post];
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
