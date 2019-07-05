//
//  AJDWMovieController.m
//  MovieDBAssessmentiOS27
//
//  Created by Austin West on 7/5/19.
//  Copyright © 2019 Austin West. All rights reserved.
//

#import "AJDWMovieController.h"

static NSString * const baseUrlString = @"https://api.themoviedb.org/3/search/movie";
static NSString * const baseImageUrl = @"https://image.tmdb.org/t/p/w500";
static NSString * const query = @"query";
static NSString * const api = @"api_key";
static NSString * const apiKey = @"621c011ff27583f12f2c0f2fce7cd6d8";

@implementation AJDWMovieController

+ (instancetype)sharedInstance
{
    static AJDWMovieController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [AJDWMovieController new];
    });
    return sharedInstance;
}


- (void)fetchMoviesWithSearch:(NSString *)search completion:(void (^)(NSArray<AJDWMovie *> *))completion
{

    NSURL *baseUrl = [NSURL URLWithString:baseUrlString];
    NSURLQueryItem *apiQuery = [[NSURLQueryItem alloc] initWithName:api value:apiKey];
    NSURLQueryItem *searchQuery = [[NSURLQueryItem alloc] initWithName:query value:search];
    NSURLComponents *components = [NSURLComponents componentsWithURL:baseUrl resolvingAgainstBaseURL:TRUE];
    components.queryItems = [[NSArray alloc] initWithObjects:(apiQuery), (searchQuery), nil];
    NSURL *finalUrl = components.URL;
    NSLog(@"%@", [finalUrl absoluteString]);
    [[[NSURLSession sharedSession] dataTaskWithURL:finalUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"There was an error in %s: %@, %@", __PRETTY_FUNCTION__, error, [error localizedDescription]);
            completion(nil);
            return;
        }
        if (data) {
            NSDictionary *jsonTopLevelDictionary = [NSJSONSerialization JSONObjectWithData:data options:2 error:&error];
            if (!jsonTopLevelDictionary) {
                NSLog(@"Error parsing json data top");
                completion(nil);
                return;
            }
            NSMutableArray *moviesArray = [NSMutableArray new];
            for (NSDictionary *movieDictionary in jsonTopLevelDictionary[@"results"]) {
                AJDWMovie *movie = [[AJDWMovie alloc] initWithDictionary:movieDictionary];
                [moviesArray addObject:movie];
            }
            completion(moviesArray);
        }
    }] resume];
}

- (void)fetchPosterForMovie:(AJDWMovie *)movie completion:(void (^)(UIImage * _Nullable))completion
{
    
    NSLog(@"%@", movie.posterPath);
    NSURL *baseUrl = [NSURL URLWithString:baseImageUrl];
    if ([movie.posterPath isKindOfClass:[NSNull class]]) {
        completion(nil);
        return;
    }
    NSURL *fullUrl = [baseUrl URLByAppendingPathComponent:movie.posterPath];
    NSLog(@"%@", [fullUrl absoluteString]);
    
    [[[NSURLSession sharedSession] dataTaskWithURL:fullUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            completion(nil);
            return;
        }
        UIImage *movieImage = [UIImage imageWithData:data];
        completion(movieImage);
    }] resume];
}
@end
