//
//  ISSLazyValue.h
//  Part of InterfaCSS - http://www.github.com/tolo/InterfaCSS
//  
//  Created by Tobias Löfstrand on 2014-02-16.
//  Copyright (c) 2014 Leafnode AB.
//  License: MIT (http://www.github.com/tolo/InterfaCSS/LICENSE)
//

typedef id (^ISSLazyValueBlock)(id parameter);


@interface ISSLazyValue : NSObject

+ (instancetype) lazyValueWithBlock:(ISSLazyValueBlock)block;
- (instancetype) initWithLazyEvaluationBlock:(ISSLazyValueBlock)block;

- (id) evaluate;
- (id) evaluateWithParameter:(id)parameter;

@end