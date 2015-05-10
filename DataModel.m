//
//  DataModel.m
//  CSSTest-Classy
//
//  Created by Vjacheslav Volodjko on 10.05.15.
//  Copyright (c) 2015 Vjacheslav Volodjko. All rights reserved.
//

#import "DataModel.h"

@interface DataModel ()

@property (strong, readwrite, nonatomic) NSArray *items;

@end

@implementation DataModel

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithFile:@"data.plist"];
    });
    return instance;
}

- (instancetype)initWithFile:(NSString *)fileName
{
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:fileName.stringByDeletingPathExtension
                                                                            ofType:fileName.pathExtension];
    }
    return self;
}

@end
