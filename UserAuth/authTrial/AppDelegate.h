//
//  AppDelegate.h
//  authTrial
//
//  Created by Paxcel on 05/10/15.
//  Copyright © 2015 TechHeal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    AuthorizationRef    _authRef;
}
@property (atomic, copy,   readwrite) NSData * authorization;

@end

