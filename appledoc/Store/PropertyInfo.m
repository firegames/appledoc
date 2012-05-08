//
//  PropertyInfo.m
//  appledoc
//
//  Created by Tomaž Kragelj on 4/16/12.
//  Copyright (c) 2012 Tomaz Kragelj. All rights reserved.
//

#import "Objects.h"
#import "StoreRegistrations.h"
#import "TypeInfo.h"
#import "AttributesInfo.h"
#import "DescriptorsInfo.h"
#import "PropertyInfo.h"

@implementation PropertyInfo

@synthesize propertyType = _propertyType;
@synthesize propertyAttributes = _propertyAttributes;
@synthesize propertyDescriptors = _propertyDescriptors;
@synthesize propertyName = _propertyName;

#pragma mark - Helper methods

- (NSString *)propertyGetterSelector {
	NSString *result = [self.propertyAttributes valueForAttribute:@"getter"];
	if (result) return result;
	return self.propertyName;
}

- (NSString *)propertySetterSelector {
	// Note that current implementation ignores colon after setter selector name in attributes - it's registered as a separate item in array, just after setter name. It doesn't interfere with app logic in any way though...
	NSString *result = [self.propertyAttributes valueForAttribute:@"setter"];
	if (result) {
		if ([result hasSuffix:@":"]) return result;
		return [NSString stringWithFormat:@"%@:", result];
	}
	NSString *prefix = [[self.propertyName substringToIndex:1] uppercaseString];
	NSString *suffix = [self.propertyName substringFromIndex:1];
	result = [NSString stringWithFormat:@"set%@%@:", prefix, suffix];
	return result;
}

#pragma mark - Properties

- (TypeInfo *)propertyType {
	if (_propertyType) return _propertyType;
	LogIntDebug(@"Initializing property type due to first access...");
	_propertyType = [[TypeInfo alloc] init];
	return _propertyType;
}

- (AttributesInfo *)propertyAttributes {
	if (_propertyAttributes) return _propertyAttributes;
	LogIntDebug(@"Initializing property attributes due to first access...");
	_propertyAttributes = [[AttributesInfo alloc] init];
	return _propertyAttributes;
}

- (DescriptorsInfo *)propertyDescriptors {
	if (_propertyDescriptors) return _propertyDescriptors;
	LogIntDebug(@"Initializing property descriptors due to first access....");
	_propertyDescriptors = [[DescriptorsInfo alloc] init];
	return _propertyDescriptors;
}

@end

#pragma mark - 

@implementation PropertyInfo (Registrations)

- (void)beginPropertyTypes {
	// Note that we don't have to respond to endCurrentObject or cancelCurrentObject to pop propertyType - Store will automatically pop it from its stack whenever either of these messages are sent to it.
	LogStoVerbose(@"Starting property types...");
	[self pushRegistrationObject:self.propertyType];
}

- (void)beginPropertyAttributes {
	// Note that we don't have to respond to endCurrentObject or cancelCurrentObject to pop propertyAttributes - Store will automatically pop it from its stack whenever either of these messages are sent to it.
	LogStoVerbose(@"Starting property types...");
	[self pushRegistrationObject:self.propertyAttributes];
}

- (void)beginPropertyDescriptors {
	// Note that we don't have to respond to endCurrentObject or cancelCurrentObject to pop propertyDescriptors - Store will automatically pop it from its stack whenever either of these messages are sent to it.
	LogStoVerbose(@"Starting property descriptors...");
	[self pushRegistrationObject:self.propertyDescriptors];
}

- (void)appendPropertyName:(NSString *)name {
	LogStoInfo(@"Assigning property name %@...", name);
	self.propertyName = name;
}

@end

#pragma mark - 

@implementation PropertyInfo (Logging)

- (NSString *)description {
	NSMutableString *result = [NSMutableString string];
	[result appendString:@"@property "];
	if (_propertyAttributes) [result appendFormat:@"(%@) ", self.propertyAttributes];
	if (_propertyType) [result appendFormat:@"%@", self.propertyType];
	[result appendString:self.propertyName];
	if (_propertyDescriptors) [result appendFormat:@" %@", self.propertyDescriptors];
	[result appendString:@";"];
	return result;
}

@end
