//
//  AJDWMovie.h
//  MovieDBAssessmentiOS27
//
//  Created by Austin West on 7/5/19.
//  Copyright © 2019 Austin West. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AJDWMovie : NSObject

@property (nonatomic, copy, readonly) NSString *movieTitle;
@property (nonatomic, copy, readonly, nullable) NSString *movieDescription;
@property (nonatomic, copy, readonly, nullable) NSString *posterPath;
@property (nonatomic, readonly, nullable) NSNumber *votes;
@property (nonatomic, copy, readonly, nullable) NSNumber *rating;

- (instancetype) initWithTitle:(NSString *)title movieDescription:(NSString *)movieDescription posterPath:(NSString *)posterPath votes:(NSNumber *)votes rating:(NSNumber *)rating;

@end

@interface AJDWMovie (JSONConvertable)

- (instancetype) initWithDictionary:(NSDictionary<NSString *, id> *)dictionary;

@end

NS_ASSUME_NONNULL_END
