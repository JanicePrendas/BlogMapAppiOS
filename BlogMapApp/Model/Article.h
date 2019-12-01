//
//  Article.h
//  BlogMapApp
//
//  Created by Janice Prendas on 11/27/19.
//  Copyright © 2019 Janice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Article : NSObject

@property (strong, nonatomic) NSString *article_date;
@property (strong, nonatomic) NSString *author;
@property(strong,nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *uuid;


@end

NS_ASSUME_NONNULL_END
