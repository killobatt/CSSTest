//
//  NSArray+ISSAdditions.m
//  Part of InterfaCSS - http://www.github.com/tolo/InterfaCSS
//
//  Created by Tobias Löfstrand on 2014-05-08.
//  Copyright (c) 2010 Leafnode AB.
//  License: MIT (http://www.github.com/tolo/InterfaCSS/LICENSE)
//


#import "NSMutableArray+ISSAdditions.h"

@implementation NSMutableArray (ISSAdditions)

- (void) iss_addAndReplaceUniqueObjectsInArray:(NSArray*)array {
    for(id element in array) {
        [self removeObject:element];
        [self addObject:element];
    }
}

@end