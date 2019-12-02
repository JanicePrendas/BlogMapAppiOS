//
//  BlogViewController.m
//  BlogMapApp
//
//  Created by Janice Prendas on 11/27/19.
//  Copyright © 2019 Janice. All rights reserved.
//

#import "BlogViewController.h"
#import "WebViewController.h"
#import "Article.h"

@interface BlogViewController ()

@property (strong, nonatomic) NSMutableArray * articles;

@end

@implementation BlogViewController

NSString *cellId = @"blogCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchArticlesUsingJSON];
}


- (void)fetchArticlesUsingJSON {
    NSLog(@"Fetching Articles");

    NSString *urlString = @"https://www.beenverified.com/articles/index.ios.json";
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Finished fetching articles....");
        
        NSError *err;
        NSDictionary *courseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        
        
        if (err){
            NSLog(@"Failed to serialize into JSON: %@", err);
            return;
        }
        
        self->_articles = NSMutableArray.new;
        
        NSArray *articlesArray = [courseJSON objectForKey:@"articles"];
        
        for (NSDictionary *courseDict in articlesArray) {
            NSString *date = courseDict[@"article_date"];
            NSString *author = courseDict[@"author"];
            NSString *description = courseDict[@"description"];
            NSString *image = courseDict[@"image"];
            NSString *link = courseDict[@"link"];
            NSString *title = courseDict[@"title"];
            NSString *uuid = courseDict[@"uuid"];
            date = [date substringToIndex:(date.length - 14)];
            
            Article *article = Article.new;
            article.article_date = date;
            article.author = author;
            article.desc = description;
            article.image = image;
            article.link = link;
            article.title = title;
            article.uuid = uuid;
            [self->_articles addObject:article];
        }
        
            [self->tableView reloadData];
        
    }] resume];
}

- ( NSString * )returnImageURLFixed:(NSString *)url{
    NSArray *separate = [url componentsSeparatedByString:@".com/"];
    
    NSString *firstPart = [NSString stringWithFormat: @"%@%@", [separate objectAtIndex:0], @".com/"];
    NSString *middlePart = @"/fit-in/60x/filters:autojpg()/";
    
    NSString *a = [NSString stringWithFormat:@"%@%@%@", firstPart,middlePart,[separate objectAtIndex:1]];
    return a;
}
    

- ( NSURLSession * )getURLSession
{
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken,
    ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:configuration];
    } );
    
    return session;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    WebViewController *vc;
    vc = [segue destinationViewController];
    Article *currentArticle = [self->_articles objectAtIndex:[self->tableView indexPathForSelectedRow].row];
    NSString *myUrl = currentArticle.link;
    vc.stringUrl = [myUrl stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //The api is not properly configured to support pagination. So returning _articles.count is not a good idea
    return 20; //_articles.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier: cellId];
       if (cell == nil)
       {
           cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
       }
       Article *maincell=[_articles objectAtIndex:indexPath.row];
    
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@", [self returnImageURLFixed:maincell.image]]]];
        if ( imageData == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *image1=(UIImageView *)[cell viewWithTag:0];
            image1.image=[UIImage imageWithData: imageData];
        });
        
    });

        UILabel *title=(UILabel *)[cell viewWithTag:1];
        title.text=maincell.title;
    
       UILabel *author=(UILabel *)[cell viewWithTag:2];
       author.text=maincell.author;
    
        UILabel *date=(UILabel *)[cell viewWithTag:3];
        date.text=maincell.article_date;
    
       UILabel *desc=(UILabel *)[cell viewWithTag:4];
       desc.text=maincell.desc;
    
    return cell;
}



@end
