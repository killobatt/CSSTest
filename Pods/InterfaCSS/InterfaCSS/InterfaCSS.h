//
//  InterfaCSS.h
//  Part of InterfaCSS - http://www.github.com/tolo/InterfaCSS
//
//  Created by Tobias Löfstrand on 2012-02-22.
//  Copyright (c) 2012 Leafnode AB.
//  License: MIT (http://www.github.com/tolo/InterfaCSS/LICENSE)
//


typedef NSArray* (^ISSWillApplyStylingNotificationBlock)(NSArray* propertyDeclarations);
typedef void (^ISSDidApplyStylingNotificationBlock)(NSArray* propertyDeclarations);


#import "ISSPropertyDefinition.h"
#import "ISSStyleSheet.h"
#import "ISSViewBuilder.h"
#import "UIView+InterfaCSS.h"
#import "UITableView+InterfaCSS.h"
#import "NSObject+ISSLogSupport.h"


@protocol ISSStyleSheetParser;
@class ISSViewPrototype;
@class ISSPropertyRegistry;


/** 
 * The heart, core and essence of InterfaCSS. Handles loading of stylesheets and keeps track of all style information.
 */
@interface InterfaCSS : NSObject


#pragma mark - Static methods

/** 
 * Gets the shared InterfaCSS instance.
 *
 * @deprecated use `[InterfaCSS sharedInstance]`.
 */
+ (InterfaCSS*) interfaCSS;

/**
 * Gets the shared InterfaCSS instance.
 */
+ (InterfaCSS*) sharedInstance;

/**
 * Clears and resets all loaded stylesheets, registered style class names and caches.
 */
+ (void) clearResetAndUnload;



#pragma mark - Behavioural properties

/**
 * Setting this flag to `YES` prevents "overwriting" of font and text color in attributed text of labels (and buttons) when styles are applied.
 * Default value is `NO`
 */
@property (nonatomic) BOOL preventOverwriteOfAttributedTextAttributes;

/**
 * If this flag is set to `YES`, any type selector that don't match a valid UIKit type will instead be used as a style class selector. Default is `NO`.
 */
@property (nonatomic) BOOL useLenientSelectorParsing;

/**
 * The interval at which refreshable stylesheets are refreshed. Default is 5 seconds.
 */
@property (nonatomic) NSTimeInterval stylesheetAutoRefreshInterval;

/**
 * Flag indicating if refreshable stylesheets always should be processed after "normal" stylesheets, and thereby always being able to override those. Default is `YES`.
 */
@property (nonatomic) NSTimeInterval processRefreshableStylesheetsLast;


#pragma mark - Properties

/**
 * The property registry keeps track on all properties that can be set through stylesheets.
 */
@property (nonatomic, readonly, strong) ISSPropertyRegistry* propertyRegistry;

/**
 * All currently active stylesheets (`ISSStyleSheet`).
 */
@property (nonatomic, readonly, strong) NSMutableArray* styleSheets;

/**
 * The current stylesheet parser.
 */
@property (nonatomic, strong) id<ISSStyleSheetParser> parser;


#pragma mark - Styling

/**
 * Clears cached styles.
 */
- (void) clearCachedStylesForUIElement:(id)uiElement;

/**
 * Schedules styling of the specified UI object.
 */
- (void) scheduleApplyStyling:(id)uiElement animated:(BOOL)animated;

/**
 * Schedules styling of the specified UI object.
 */
- (void) scheduleApplyStyling:(id)uiElement animated:(BOOL)animated force:(BOOL)force;

/**
 * Cancel previously scheduled styling of the specified UI object.
 */
- (void) cancelScheduledApplyStyling:(id)uiElement;

/**
 * Applies styling of the specified UI object.
 */
- (void) applyStyling:(id)uiElement;

/**
 * Applies styling of the specified UI object.
 */
- (void) applyStyling:(id)uiElement includeSubViews:(BOOL)includeSubViews;

/**
 * Applies styling of the specified UI object.
 */
- (void) applyStyling:(id)uiElement includeSubViews:(BOOL)includeSubViews force:(BOOL)force;

/**
 * Applies styling of the specified UI object in an animation block.
 */
- (void) applyStylingWithAnimation:(id)uiElement;

/**
 * Applies styling of the specified UI object in an animation block.
 */
- (void) applyStylingWithAnimation:(id)uiElement includeSubViews:(BOOL)includeSubViews;

/**
 * Applies styling of the specified UI object in an animation block.
 */
- (void) applyStylingWithAnimation:(id)uiElement includeSubViews:(BOOL)includeSubViews force:(BOOL)force;


#pragma mark - Style classes

/**
 * Gets the current style classes for the specifiied UI element.
 */
- (NSSet*) styleClassesForUIElement:(id)uiElement;

/**
 * Checks if the specified class is set on the specifiied UI element.
 */
- (BOOL) uiElement:(id)uiElement hasStyleClass:(NSString*)styleClass;

/**
 * Sets the style classes for the specifiied UI element, replacing any previous style classes.
 */
- (void) setStyleClasses:(NSSet*)styleClasses forUIElement:(id)uiElement;

/**
 * Adds a style class to the specifiied UI element.
 */
- (void) addStyleClass:(NSString*)styleClass forUIElement:(id)uiElement;

/**
 * Removes a style class from the specifiied UI element.
 */
- (void) removeStyleClass:(NSString*)styleClass forUIElement:(id)uiElement;


#pragma mark - Additional styling control

/**
 * Sets a callback block for getting notified when styles will be applied to the specified UI element. Makes it possible to prevent some properties from being applied, by returning a different
 * list of properties than the list passed as a parameter to the block.
 */
- (void) setWillApplyStylingBlock:(ISSWillApplyStylingNotificationBlock)willApplyStylingBlock forUIElement:(id)uiElement;

/** Gets the current callback block for getting notified when styles will be applied to the specified UI element.*/
- (ISSWillApplyStylingNotificationBlock) willApplyStylingBlockForUIElement:(id)uiElement;

/**
 * Sets a callback block for getting notified when styles have been applied to the specified UI element. Makes it possible to for instance adjust property values or update dependent properties.
 */
- (void) setDidApplyStylingBlock:(ISSDidApplyStylingNotificationBlock)didApplyStylingBlock forUIElement:(id)uiElement;

/** Gets the current callback block for getting notified when styles have been applied to the specified UI element.*/
- (ISSDidApplyStylingNotificationBlock) didApplyStylingBlockForUIElement:(id)uiElement;

/**
 * Sets a custom styling identity that overrides the default mechanism for assigning styling identities to elements (which essentially involves building a full view
 * hierarchy "path" of an element, such as "UIWindow UIView UIView[class]"). The styling identity is effectively the cache key for the styling information
 * associated with a UI element, and setting this to a custom value makes it possible to (further) increase performance by sharing cached styles with
 * UI elements located in different places in the view hierarchy for instance. Examples of places where setting this property can be useful is for instance
 * the root view of a view controller, a custom UI component or other views that can be styles regardless of the ancestor view hierarchy.
 *
 * NOTE: When using a custom styling identity for a view, avoid using style declarations that depends on the view hierarchy above that view (i.e. use of chained
 * or nested selectors that ).
 */
- (void) setCustomStylingIdentity:(NSString*)customStylingIdentity forUIElement:(id)uiElement;

/** Gets the custom styling identity. */
- (NSString*) customStylingIdentityForUIElement:(id)uiElement;

/**
 * Disables or re-enables styling of the specified UI element. If `enabled` is set to `NO`, InterfaCSS will stop applying styling information to the element and it's children,
 * but any styles that have already been applied will remain. This method can for instance be useful for setting initial styles for a view via InterfaCSS,
 * and then take control of the styling manually, without the risk of InterfaCSS overwriting any modified properties.
 */
- (void) setStylingEnabled:(BOOL)enabled forUIElement:(id)uiElement;

/** Returns `YES` if styling is enabled for the specified UI element. */
- (BOOL) isStylingEnabledForUIElement:(id)uiElement;

/** Returns `YES` if styling has been successfully applied to the specified UI element. */
- (BOOL) isStylingAppliedForUIElement:(id)uiElement;


/**
 * Disables or re-enables styling of a specific property in the specified UI element. If `enabled` is set to `NO`, InterfaCSS will stop applying styling information to the
 * property, but any value that has already been applied will remain. This method can for instance be useful for setting initial styles for a view via InterfaCSS,
 * and then take control of the styling manually, without the risk of InterfaCSS overwriting property values.
 */
- (void) setStylingEnabled:(BOOL)enabled forProperty:(NSString*)propertyName inUIElement:(id)uiElement;

/** Returns `YES` if styling is enabled for a specific property in the specified UI element. */
- (BOOL) isStylingEnabledForProperty:(NSString*)propertyName inUIElement:(id)uiElement;

/** Finds a sub view with the specified element identifier. */
- (id) subviewWithElementId:(NSString*)elementId inView:(UIView*)view;


#pragma mark - Stylesheets

/**
 * Loads a stylesheet from the main bundle.
 */
- (ISSStyleSheet*) loadStyleSheetFromMainBundleFile:(NSString*)styleSheetFileName;

/**
 * Loads a stylesheet from file.
 */
- (ISSStyleSheet*) loadStyleSheetFromFile:(NSString*)styleSheetFilePath;

/**
 * Loads an auto-refreshable stylesheet from a URL.
 * Note: Refreshable stylesheets are only intended for use during development, and not in production.
 */
- (ISSStyleSheet*) loadRefreshableStyleSheetFromURL:(NSURL*)styleSheetFileURL;

/**
 * Unloads the specified styleSheet.
 * @param styleSheet the stylesheet to unload.
 * @param refreshStyling @p YES if styling on all tracked views should be reset as a result of this call, otherwise @p NO.
 */
- (void) unloadStyleSheet:(ISSStyleSheet*)styleSheet refreshStyling:(BOOL)refreshStyling;

/**
 * Unloads all loaded stylesheets, effectively resetting the styling of all views.
 * @param refreshStyling @p YES if styling on all tracked views should be reset as a result of this call, otherwise @p NO.
 */
- (void) unloadAllStyleSheets:(BOOL)refreshStyling;


#pragma mark - Prototypes

/**
 * Registers a prototype defined in a view definition file.
 */
- (void) registerPrototype:(ISSViewPrototype*)prototype;

/**
 * Registers a prototype defined in a view definition file.
 */
- (void) registerPrototype:(ISSViewPrototype*)prototype inElement:(id)registeredInElement;

/**
 * Creates a view from a prototype defined in a view definition file.
 */
- (UIView*) viewFromPrototypeWithName:(NSString*)prototypeName;

/**
 * Creates a view from a prototype defined in a view definition file.
 */
- (UIView*) viewFromPrototypeWithName:(NSString*)prototypeName prototypeParent:(id)prototypeParent;

/**
 * Creates a view from a prototype defined in a view definition file.
 */
- (UIView*) viewFromPrototypeWithName:(NSString*)prototypeName registeredInElement:(id)registeredInElement prototypeParent:(id)prototypeParent;


#pragma mark - Variable access

/**
 * Returns the raw value of the stylesheet variable with the specified name.
 */
- (NSString*) valueOfStyleSheetVariableWithName:(NSString*)variableName;

/**
 * Returns the value of the stylesheet variable with the specified name, transformed to the specified type.
 */
- (id) transformedValueOfStyleSheetVariableWithName:(NSString*)variableName asPropertyType:(ISSPropertyType)propertyType;

/**
 * Returns the value of the stylesheet variable with the specified name, transformed using the specified property definition.
 */
- (id) transformedValueOfStyleSheetVariableWithName:(NSString*)variableName forPropertyDefinition:(ISSPropertyDefinition*)propertyDefinition;

/**
 * Sets the raw value of the stylesheet variable with the specified name.
 */
- (void) setValue:(NSString*)value forStyleSheetVariableWithName:(NSString*)variableName;


#pragma mark - Debugging support

/**
 * Logs the active style declarations for the specified UI element.
 */
- (void) logMatchingStyleDeclarationsForUIElement:(id)uiElement;

@end
