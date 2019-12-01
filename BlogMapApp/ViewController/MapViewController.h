//
//  MapViewController.h
//  BlogMapApp
//
//  Created by Janice Prendas on 11/28/19.
//  Copyright © 2019 Janice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : UIViewController <CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    UISearchBar *searchBar;
}

@end

NS_ASSUME_NONNULL_END
