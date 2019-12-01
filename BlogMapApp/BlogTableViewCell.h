//
//  BlogTableViewCell.h
//  BlogMapApp
//
//  Created by Janice Prendas on 11/26/19.
//  Copyright © 2019 Janice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlogTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UILabel *articleDate;

@end

NS_ASSUME_NONNULL_END
