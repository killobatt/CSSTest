/*
 ____
 |  _ \ __ _ _ __ ___ ___   __ _   Parcoa - Objective-C Parser Combinators
 | |_) / _` | '__/ __/ _ \ / _` |
 |  __/ (_| | | | (_| (_) | (_| |  Copyright (c) 2012,2013 James Brotchie
 |_|   \__,_|_|  \___\___/ \__,_|  https://github.com/brotchie/Parcoa
 
 
 The MIT License
 
 Copyright (c) 2012,2013 James Brotchie
 - brotchie@gmail.com
 - @brotchie
 
 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "ParcoaPredicate+Combinators.h"

@implementation ParcoaPredicate (Combinators)

- (ParcoaPredicate *)or:(ParcoaPredicate *)other {
    return [ParcoaPredicate predicateWithBlock:^BOOL(unichar x) {
        return [self check:x] || [other check:x];
    } name:@"or" summaryWithFormat:@"%@ || %@", self.summary, other.summary];
}

- (ParcoaPredicate *)and:(ParcoaPredicate *)other {
    return [ParcoaPredicate predicateWithBlock:^BOOL(unichar x) {
        return [self check:x] && [other check:x];
    } name:@"and" summaryWithFormat:@"%@ && %@", self.summary, other.summary];
}

- (ParcoaParser *)takeWhile {
    return [Parcoa takeWhile:self];
}

- (ParcoaParser *)takeWhile1 {
    return [Parcoa takeWhile1:self];
}

- (ParcoaParser *)takeUntil {
    return [Parcoa takeUntil:self];
}

- (ParcoaParser *)take:(NSUInteger)n {
    return [Parcoa take:self count:n];
}


@end
