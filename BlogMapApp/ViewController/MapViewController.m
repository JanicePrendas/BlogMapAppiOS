//
//  MapViewController.m
//  BlogMapApp
//
//  Created by Janice Prendas on 11/28/19.
//  Copyright © 2019 Janice. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController ()

@end

@implementation MapViewController{
    GMSMapView *mapView_;
    BOOL hasFirstMarker;
    BOOL firstLocationUpdate_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hasFirstMarker = false;
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.tintColor = [UIColor grayColor];
    searchBar.placeholder = @"Search";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
    longitude:151.2086
         zoom:12];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;

    // Listen to the myLocation property of GMSMapView.
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];

    self.view = mapView_;

    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        self->mapView_.myLocationEnabled = YES;
    });
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *address = searchBar.text;

    // Listen to the myLocation property of GMSMapView.
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];

    CLLocation *location = mapView_.myLocation;
    address = [address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSURL *googlePlacesURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&location=%f,%f&radius=1&key=YOUR_KEY_HERE", //Insert your Google Maps Api Key here
        address, location.coordinate.latitude,location.coordinate.longitude]];
    
    
    [[NSURLSession.sharedSession dataTaskWithURL:googlePlacesURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           
           NSLog(@"Finished fetching places....");
           
           NSError *err;
        
        NSDictionary *courseJSON = [NSJSONSerialization JSONObjectWithData:
        data options:NSJSONReadingMutableContainers error:&error]; //get JSON
        
           if (err){
               NSLog(@"Failed to serialize into JSON: %@", err);
               return;
           }
        
        NSArray *resultsArray = [courseJSON objectForKey:@"results"];
        NSUInteger size = resultsArray.count;
        
        if(size > 0){
            
            if(size > 5){
                size = 5; //The limit amount of markers is 5
            }
            
            if(self->hasFirstMarker){
                runOnMainThreadWithoutDeadlocking(^{
                    [self->mapView_ clear];
                });
            }
            
            NSMutableArray<GMSMarker *> *markers = NSMutableArray.new;
            
            for (int i = 0; i < size; i++) {
                NSString *name = resultsArray[i][@"name"];
                NSDictionary *geo = resultsArray[i][@"geometry"][@"location"];
                NSString *lat = [geo objectForKey:@"lat"];
                NSString *lng = [geo objectForKey:@"lng"];

                runOnMainThreadWithoutDeadlocking(^{
                    GMSMarker *marker = GMSMarker.new;
                               
                   marker.position = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
                   marker.title = name;
                    marker.map = self->mapView_;
                   
                   [markers addObject:marker];
                });
            }
            self->hasFirstMarker = true;
        }
        else{ //No results...
            [self noResultsAlert];
            NSLog(@"No encontre nada");
        }
       }] resume];
}

void runOnMainThreadWithoutDeadlocking(void (^block)(void)){
    if ([NSThread isMainThread]){
        block();
    }
    else{
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (IBAction) noResultsAlert{
  // create a simple alert
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No results found"
  message:@"Please, try again" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];

    runOnMainThreadWithoutDeadlocking(^{
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)dealloc {
  [mapView_ removeObserver:self
                forKeyPath:@"myLocation"
                   context:NULL];
}

#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if (!firstLocationUpdate_) {
    // If the first location update has not yet been recieved, then jump to that location.
    firstLocationUpdate_ = YES;
    CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
    mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:14];
  }
}

@end
