//
//  common.h
//  authTrial
//
//  Created by Paxcel on 05/10/15.
//  Copyright © 2015 TechHeal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface common : NSObject
+ (NSString *)authorizationRightForCommand:(SEL)command;
// For a given command selector, return the associated authorization right name.

+ (void)setupAuthorizationRights:(AuthorizationRef)authRef;
// Set up the default authorization rights in the authorization database.

@end
