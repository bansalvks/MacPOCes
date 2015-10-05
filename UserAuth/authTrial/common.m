//
//  common.m
//  authTrial
//
//  Created by Paxcel on 05/10/15.
//  Copyright © 2015 TechHeal. All rights reserved.
//

#import "common.h"


@implementation common


static NSString * kCommandKeyAuthRightName    = @"authRightName";
static NSString * kCommandKeyAuthRightDefault = @"authRightDefault";
static NSString * kCommandKeyAuthRightDesc    = @"authRightDescription";

+ (NSDictionary *)commandInfo
{
    static dispatch_once_t sOnceToken;
    static NSDictionary *  sCommandInfo;
    
    dispatch_once(&sOnceToken, ^{
        sCommandInfo = @{
                         NSStringFromSelector(@selector(readLicenseKeyAuthorization:withReply:)) : @{
                                 kCommandKeyAuthRightName    : @"com.example.apple-samplecode.EBAS.readLicenseKey",
                                 kCommandKeyAuthRightDefault : @kAuthorizationRuleClassAllow,
                                 kCommandKeyAuthRightDesc    : NSLocalizedString(
                                                                                 @"EBAS is trying to read its license key.",
                                                                                 @"prompt shown when user is required to authorize to read the license key"
                                                                                 )
                                 },
                         NSStringFromSelector(@selector(writeLicenseKey:authorization:withReply:)) : @{
                                 kCommandKeyAuthRightName    : @"com.example.apple-samplecode.EBAS.writeLicenseKey",
                                 kCommandKeyAuthRightDefault : @kAuthorizationRuleAuthenticateAsAdmin,
                                 kCommandKeyAuthRightDesc    : NSLocalizedString(
                                                                                 @"EBAS is trying to write its license key.",
                                                                                 @"prompt shown when user is required to authorize to write the license key"
                                                                                 )
                                 },
                         NSStringFromSelector(@selector(bindToLowNumberPortAuthorization:withReply:)) : @{
                                 kCommandKeyAuthRightName    : @"com.example.apple-samplecode.EBAS.startWebService",
                                 kCommandKeyAuthRightDefault : @kAuthorizationRuleClassAllow,
                                 kCommandKeyAuthRightDesc    : NSLocalizedString(
                                                                                 @"EBAS is trying to start its web service.",
                                                                                 @"prompt shown when user is required to authorize to start the web service"
                                                                                 )
                                 }
                         };
    });
    return sCommandInfo;
}

+ (NSString *)authorizationRightForCommand:(SEL)command
// See comment in header.
{
    return [self commandInfo][NSStringFromSelector(command)][kCommandKeyAuthRightName];
}

+ (void)enumerateRightsUsingBlock:(void (^)(NSString * authRightName, id authRightDefault, NSString * authRightDesc))block
// Calls the supplied block with information about each known authorization right..
{
    [self.commandInfo enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
#pragma unused(key)
#pragma unused(stop)
        NSDictionary *  commandDict;
        NSString *      authRightName;
        id              authRightDefault;
        NSString *      authRightDesc;
        
        // If any of the following asserts fire it's likely that you've got a bug
        // in sCommandInfo.
        
        commandDict = (NSDictionary *) obj;
        assert([commandDict isKindOfClass:[NSDictionary class]]);
        
        authRightName = [commandDict objectForKey:kCommandKeyAuthRightName];
        assert([authRightName isKindOfClass:[NSString class]]);
        
        authRightDefault = [commandDict objectForKey:kCommandKeyAuthRightDefault];
        assert(authRightDefault != nil);
        
        authRightDesc = [commandDict objectForKey:kCommandKeyAuthRightDesc];
        assert([authRightDesc isKindOfClass:[NSString class]]);
        
        block(authRightName, authRightDefault, authRightDesc);
    }];
}

+ (void)setupAuthorizationRights:(AuthorizationRef)authRef
// See comment in header.
{
    assert(authRef != NULL);
    [common enumerateRightsUsingBlock:^(NSString * authRightName, id authRightDefault, NSString * authRightDesc) {
        OSStatus    blockErr;
        
        // First get the right.  If we get back errAuthorizationDenied that means there's
        // no current definition, so we add our default one.
        
        blockErr = AuthorizationRightGet([authRightName UTF8String], NULL);
        if (blockErr == errAuthorizationDenied) {
            blockErr = AuthorizationRightSet(
                                             authRef,                                    // authRef
                                             [authRightName UTF8String],                 // rightName
                                             (__bridge CFTypeRef) authRightDefault,      // rightDefinition
                                             (__bridge CFStringRef) authRightDesc,       // descriptionKey
                                             NULL,                                       // bundle (NULL implies main bundle)
                                             CFSTR("Common")                             // localeTableName
                                             );
            assert(blockErr == errAuthorizationSuccess);
        } else { 
            // A right already exists (err == noErr) or any other error occurs, we 
            // assume that it has been set up in advance by the system administrator or
            // this is the second time we've run.  Either way, there's nothing more for 
            // us to do.
        }
    }];
}



@end
