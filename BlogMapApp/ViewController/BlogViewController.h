//
//  BlogViewController.h
//  BlogMapApp
//
//  Created by Janice Prendas on 11/27/19.
//  Copyright © 2019 Janice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlogViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView *tableView;
    NSArray *mainArray;
}


@end

NS_ASSUME_NONNULL_END
