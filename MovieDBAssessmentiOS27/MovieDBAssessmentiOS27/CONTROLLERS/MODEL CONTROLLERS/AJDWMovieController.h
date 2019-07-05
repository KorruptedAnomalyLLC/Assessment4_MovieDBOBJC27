//
//  AJDWMovieController.h
//  MovieDBAssessmentiOS27
//
//  Created by Austin West on 7/5/19.
//  Copyright © 2019 Austin West. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJDWMovie.h"

NS_ASSUME_NONNULL_BEGIN

@interface AJDWMovieController : NSObject

+ (instancetype) sharedInstance;

- (void) fetchMoviesWithSearch:(NSString *)search completion:(void (^) (NSArray<AJDWMovie *> * movies)) completion;
- (void) fetchPosterForMovie:(AJDWMovie *)movie completion:(void (^) (UIImage * _Nullable image))completion;

@end

NS_ASSUME_NONNULL_END
