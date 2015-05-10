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

#import "Parcoa+NSDictionary.h"
#import "Parcoa+Combinators.h"
#import "ParcoaParser+Combinators.h"

@implementation Parcoa (NSDictionary)
+ (ParcoaParser *)dictionary:(ParcoaParser *)parser {
    return [parser transform:^id(id value) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [value enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL *stop) {
            dict[obj[0]] = obj[1];
        }];
        return dict;
    } name:@"dictionary"];
}

+ (ParcoaParser *)parser:(ParcoaParser *)parser dictionaryWithKeys:(NSArray *)keys {
    return [parser transform:^NSMutableDictionary *(NSArray *value) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSAssert(value.count == keys.count, @"Values must be the same length as keys.");
        [value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            dict[keys[idx]] = obj;
        }];
        return dict;
    } name:@"dictionaryWithKeys"];
}
@end
