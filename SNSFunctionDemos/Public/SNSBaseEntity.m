//
//  SNSBaseEntity.m
//  SNS
//
//  Created by SohuSns on 11/1/16.
//  Copyright © 2016年 sohu. All rights reserved.
//

#import "SNSBaseEntity.h"
#import <objc/runtime.h>
@implementation SNSBaseEntity
- (NSArray *)listPropertyName {
    
    NSMutableArray *array = [NSMutableArray array];
    Class class = [self class];
    
    while (class != [NSObject class])
    {
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
        
        for (int i = 0; i < propertyCount; i++)
        {
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            NSString *key = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
            
            BOOL readonly = NO;
            const char *attributes = property_getAttributes(property);
            NSString *encoding = [NSString stringWithCString:attributes encoding:NSUTF8StringEncoding];
            
            if ([[encoding componentsSeparatedByString:@","] containsObject:@"R"])
            {
                readonly = YES;
                
                //see if there is a backing ivar with a KVC-compliant name
                NSRange iVarRange = [encoding rangeOfString:@",V"];
                
                if (iVarRange.location != NSNotFound)
                {
                    NSString *iVarName = [encoding substringFromIndex:iVarRange.location + 2];
                    
                    if ([iVarName isEqualToString:key] || [iVarName isEqualToString:[@"_" stringByAppendingString:key]])
                    {
                        //setValue:forKey: will still work
                        readonly = NO;
                    }
                }
            }
            
            if (!readonly)
            {
                //exclude read-only properties
                [array addObject:key];
            }
        }
        
        free(properties);
        
        class = [class superclass];
    }
    
    return array;
}

#pragma mark -
#pragma mark NSCopying Protocol Methods

- (id)copyWithZone:(NSZone *)zone {
    
    SNSBaseEntity *sourceResolve = [[[self class] allocWithZone:zone] init];
    
    for (NSString *key in [self listPropertyName])
    {
        id transfer = nil;
        
        id value = [self valueForKey:key];
        
        if (value)
        {
            if ([value isKindOfClass:[SNSBaseEntity class]])
            {
                transfer = [value copy];
            }
            else if ([value isKindOfClass:[NSString class]])
            {
                transfer = value;
            }
            else if ([value isKindOfClass:[NSValue class]])
            {
                transfer = [value copy];
            }
            else
            {
                if ([value conformsToProtocol:@protocol(NSCoding)])
                {
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
                    
                    transfer = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                }
                else
                {
                    transfer = value;
                }
            }
            
            [sourceResolve setValue:transfer forKey:key];
        }
    }
    
    return sourceResolve;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    
    return [self copyWithZone:zone];
}

#pragma mark -
#pragma mark - NSCoding delegate

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    
    if (self)
    {
        for (NSString *key in [self listPropertyName])
        {
            id value = [aDecoder decodeObjectForKey:key];
            
            if (value)
            {
                [self setValue:value forKey:key];
            }
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    for (NSString *key in [self listPropertyName])
    {
        id value = [self valueForKey:key];
        
        [aCoder encodeObject:value forKey:key];
    }
}

@end
