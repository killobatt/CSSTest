//
//  ISSUIElementDetails.m
//  Part of InterfaCSS - http://www.github.com/tolo/InterfaCSS
//
//  Created by Tobias Löfstrand on 2014-03-19.
//  Copyright (c) 2012 Leafnode AB.
//  License: MIT (http://www.github.com/tolo/InterfaCSS/LICENSE)
//

#import "ISSUIElementDetails.h"

#import <objc/runtime.h>
#import "ISSPropertyRegistry.h"

NSString* const ISSIndexPathKey = @"ISSIndexPathKey";
NSString* const ISSPrototypeViewInitializedKey = @"ISSPrototypeViewInitializedKey";
NSString* const ISSUIElementDetailsResetCachedDataNotificationName = @"ISSUIElementDetailsResetCachedDataNotification";


@implementation NSObject (ISSUIElementDetails)

@dynamic elementDetailsISS;

- (void) setElementDetailsISS:(ISSUIElementDetails*)elementDetailsISS {
     objc_setAssociatedObject(self, @selector(elementDetailsISS), elementDetailsISS, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ISSUIElementDetails*) elementDetailsISS {
    return objc_getAssociatedObject(self, @selector(elementDetailsISS));
}

@end


@interface ISSUIElementDetails ()

@property (nonatomic, strong, readwrite) NSString* elementStyleIdentity;
@property (nonatomic, strong) NSString* canonicalTypeAndClasses;
@property (nonatomic, strong) NSMutableDictionary* additionalDetails;
@property (nonatomic, strong) NSMutableDictionary* prototypes;

@end

@implementation ISSUIElementDetails {
    __weak UIViewController* _parentViewController;
}

#pragma mark - Lifecycle

- (id) initWithUIElement:(id)uiElement {
    self = [super init];
    if (self) {
        _uiElement = uiElement;
        if( [uiElement isKindOfClass:[UIView class]] ) {
            UIView* view = (UIView*)uiElement;
            _parentView = view.superview;
        }

        ISSPropertyRegistry* registry = [InterfaCSS sharedInstance].propertyRegistry;
        _canonicalType = [registry canonicalTypeClassForViewClass:[self.uiElement class]];
        if( !_canonicalType ) _canonicalType = [uiElement class];

        [self updateElementStyleIdentity];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetCachedData) name:ISSUIElementDetailsResetCachedDataNotificationName object:nil];
    }
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ISSUIElementDetailsResetCachedDataNotificationName object:nil];
}


#pragma mark - NSCopying

- (id) copyWithZone:(NSZone*)zone {
    ISSUIElementDetails* copy = [[(id)self.class allocWithZone:zone] init];
    copy->_uiElement = self->_uiElement;
    copy.parentView = self.parentView;

    copy.elementId = self.elementId;

    copy.canonicalType = self.canonicalType;
    copy.styleClasses = self.styleClasses;

    copy.canonicalTypeAndClasses = self.canonicalTypeAndClasses;
    copy.elementStyleIdentity = self.elementStyleIdentity;
    copy.usingCustomElementStyleIdentity = self.usingCustomElementStyleIdentity;
    copy.ancestorUsesCustomElementStyleIdentity = self.ancestorUsesCustomElementStyleIdentity;

    copy.cachedDeclarations = self.cachedDeclarations;

    copy.stylingApplied = self.stylingApplied;
    copy.stylingDisabled = self.stylingDisabled;

    copy.willApplyStylingBlock = self.willApplyStylingBlock;
    copy.didApplyStylingBlock = self.didApplyStylingBlock;

    copy.additionalDetails = self.additionalDetails;

    copy.prototypes = self.prototypes;

    return copy;
}


#pragma mark - Utils

- (id) findParent:(UIView*)parentView ofClass:(Class)class {
    if( !parentView ) return nil;
    else if( [parentView isKindOfClass:class] ) return parentView;
    else return [self findParent:parentView.superview ofClass:class];
}

- (void) updateElementStyleIdentity {
    if( self.usingCustomElementStyleIdentity ) return;

    if( self.styleClasses ) {
        NSArray* styleClasses = [[self.styleClasses allObjects] sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
            return [obj1 compare:obj2];
        }];
        NSMutableString* str = [NSMutableString stringWithString:NSStringFromClass(self.canonicalType)];
        [str appendString:@"["];
        [str appendString:[styleClasses componentsJoinedByString:@","]];
        [str appendString:@"]"];
        self.canonicalTypeAndClasses = [str copy];
    } else {
        self.canonicalTypeAndClasses = NSStringFromClass(self.canonicalType);
    }

    self.elementStyleIdentity = nil;
}

+ (void) buildElementStyleIdentityPath:(NSMutableString*)identityPath element:(ISSUIElementDetails*)element ancestorUsesCustomElementStyleIdentity:(BOOL*)ancestorUsesCustomElementStyleIdentity {
    if( element.parentView && !element.usingCustomElementStyleIdentity ) [self buildElementStyleIdentityPath:identityPath element:[[InterfaCSS interfaCSS] detailsForUIElement:element.parentView] ancestorUsesCustomElementStyleIdentity:ancestorUsesCustomElementStyleIdentity];
    if( identityPath.length ) [identityPath appendString:@" "];

    if( element.usingCustomElementStyleIdentity ) {
        [identityPath appendString:element.elementStyleIdentity];
        *ancestorUsesCustomElementStyleIdentity = YES;
    } else {
        [identityPath appendString:element.canonicalTypeAndClasses];
    }
}


#pragma mark - Public interface

- (BOOL) addedToViewHierarchy {
    return self.parentView.window || (self.parentView.class == UIWindow.class) || (self.view.class == UIWindow.class);
}

- (BOOL) stylesCacheable {
    return self.usingCustomElementStyleIdentity || self.ancestorUsesCustomElementStyleIdentity || self.addedToViewHierarchy;
}

+ (void) resetAllCachedData {
    [[NSNotificationCenter defaultCenter] postNotificationName:ISSUIElementDetailsResetCachedDataNotificationName object:nil];
}

- (void) resetCachedData {
    // Identity and structure:
    if( !self.usingCustomElementStyleIdentity ) self.elementStyleIdentity = nil;
    self.ancestorUsesCustomElementStyleIdentity = NO;
    _parentViewController = nil;
    // Cached styles:
    self.stylingApplied = NO;
    self.cachedDeclarations = nil;
}

- (UIView*) view {
    return [self.uiElement isKindOfClass:UIView.class] ? self.uiElement : nil;
}

- (UIViewController*) parentViewController {
    if( !_parentViewController ) {
        for (UIView* next = self.view.superview; next; next = next.superview) {
            UIResponder* nextResponder = next.nextResponder;
            if ( [nextResponder isKindOfClass:UIViewController.class] ) {
                _parentViewController = (UIViewController*)nextResponder;
                break;
            }
        }
    }
    return _parentViewController;
}

- (void) setStyleClasses:(NSSet*)styleClasses {
    _styleClasses = styleClasses;
    [self updateElementStyleIdentity];
}

- (void) setCustomElementStyleIdentity:(NSString*)identityPath {
    self.usingCustomElementStyleIdentity = identityPath != nil;
    _elementStyleIdentity = identityPath;
    [self updateElementStyleIdentity];
}

- (NSString*) elementStyleIdentity {
    NSString* path = _elementStyleIdentity;
    if( !path ) {
        NSMutableString* identityPath = [NSMutableString string];
        BOOL ancestorUsesCustomElementStyleIdentity = NO;
        [self.class buildElementStyleIdentityPath:identityPath element:self ancestorUsesCustomElementStyleIdentity:&ancestorUsesCustomElementStyleIdentity];
        self.ancestorUsesCustomElementStyleIdentity = ancestorUsesCustomElementStyleIdentity;
        path = [identityPath copy];
        if( self.parentView && (ancestorUsesCustomElementStyleIdentity || self.parentView.window) ) {
            _elementStyleIdentity = path;
        }
    }
    return path;
}

- (BOOL) elementStyleIdentityResolved {
    return _elementStyleIdentity != nil;
}

- (NSMutableDictionary*) additionalDetails {
    if( !_additionalDetails ) _additionalDetails = [[NSMutableDictionary alloc] init];
    return _additionalDetails;
}

- (void) setPosition:(NSInteger*)position count:(NSInteger*)count fromIndexPath:(NSIndexPath*)indexPath countBlock:(NSInteger(^)(NSIndexPath*))countBlock {
    if( !indexPath ) indexPath = self.additionalDetails[ISSIndexPathKey];
    if( indexPath ) {
        *position = indexPath.row;
        *count = countBlock(indexPath);
    }
}

- (void) typeQualifiedPositionInParent:(NSInteger*)position count:(NSInteger*)count {
    *position = NSNotFound;
    *count = 0;

    if( [self.uiElement isKindOfClass:UITableViewCell.class] ) {
        UITableView* tv = [self findParent:self.parentView ofClass:UITableView.class];
        NSIndexPath* _indexPath = [tv indexPathForCell:(UITableViewCell*)self.uiElement];
        [self setPosition:position count:count fromIndexPath:_indexPath countBlock:^NSInteger(NSIndexPath* indexPath) {
            return [tv numberOfRowsInSection:indexPath.section];;
        }];
    }
    else if( [self.uiElement isKindOfClass:UICollectionViewCell.class] ) {
        UICollectionView* cv = [self findParent:self.parentView ofClass:UICollectionView.class];
        NSIndexPath* _indexPath = [cv indexPathForCell:(UICollectionViewCell*)self.uiElement];
        [self setPosition:position count:count fromIndexPath:_indexPath countBlock:^NSInteger(NSIndexPath* indexPath) {
            return [cv numberOfItemsInSection:indexPath.section];
        }];
    }
    else if( [self.uiElement isKindOfClass:UICollectionReusableView.class] ) {
        UICollectionView* cv = [self findParent:self.parentView ofClass:UICollectionView.class];
        [self setPosition:position count:count fromIndexPath:nil countBlock:^NSInteger(NSIndexPath* indexPath) {
            return [cv numberOfItemsInSection:indexPath.section];
        }];
    }
    else if( [self.uiElement isKindOfClass:UIBarButtonItem.class] && [self.parentView isKindOfClass:UINavigationBar.class] ) {
        UINavigationBar* navBar = (UINavigationBar*)self.parentView;
        if( navBar ) {
            *position = [navBar.items indexOfObject:self.uiElement];
            *count = navBar.items.count;
        }
    }
    else if( [self.uiElement isKindOfClass:UIBarButtonItem.class] && [self.parentView isKindOfClass:UIToolbar.class] ) {
        UIToolbar* toolbar = (UIToolbar*)self.parentView;
        if( toolbar ) {
            *position = [toolbar.items indexOfObject:self.uiElement];
            *count = toolbar.items.count;
        }
    }
    else if( self.parentView ) {
        ISSPropertyRegistry* registry = [InterfaCSS sharedInstance].propertyRegistry;
        Class uiKitClass = [registry canonicalTypeClassForViewClass:[self.uiElement class]];
        for(UIView* v in self.parentView.subviews) {
            if( [v.class isSubclassOfClass:uiKitClass] ) {
                if( v == self.uiElement ) *position = *count;
                (*count)++;
            }
        }
    }
}

- (void) addDisabledProperty:(ISSPropertyDefinition*)disabledProperty {
    if( !disabledProperty ) return;
    if( !_disabledProperties ) _disabledProperties = [NSSet setWithObject:disabledProperty];
    else _disabledProperties = [_disabledProperties setByAddingObject:disabledProperty];
}

- (void) removeDisabledProperty:(ISSPropertyDefinition*)disabledProperty {
    if( !disabledProperty || !_disabledProperties ) return;
    NSMutableSet* disabledProperties = [NSMutableSet setWithSet:_disabledProperties];
    [disabledProperties removeObject:disabledProperty];
    _disabledProperties = [disabledProperties copy];
}

- (BOOL) hasDisabledProperty:(ISSPropertyDefinition*)disabledProperty {
    return [_disabledProperties containsObject:disabledProperty];
}

- (void) clearDisabledProperties {
    _disabledProperties = nil;
}

- (NSMutableDictionary*) prototypes {
    if( !_prototypes ) _prototypes = [[NSMutableDictionary alloc] init];
    return _prototypes;
}

@end
