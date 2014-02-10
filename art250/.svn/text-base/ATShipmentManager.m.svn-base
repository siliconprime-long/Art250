//
//  ATShipmentManager.m
//  art250
//
//  Created by Winfred Raguini on 7/1/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATShipmentManager.h"
#import "GDataXMLNode.h"

@implementation ATShipmentManager

+(ATShipmentManager*)sharedManager
{
    static ATShipmentManager *_sharedManager;
    static dispatch_once_t onceToken;
    

    dispatch_once(&onceToken, ^{
        _sharedManager = [[ATShipmentManager alloc] init];
    });
    
    return _sharedManager;
}

- (void)createXMLElement
{
    GDataXMLElement *verifyAddressElement = [GDataXMLNode elementWithName:@"VERIFYADDRESS"];
    GDataXMLElement *commandElement = [GDataXMLNode elementWithName:@"COMMAND" stringValue:@"ZIP1"];
    GDataXMLElement *serialNoElement = [GDataXMLNode elementWithName:@"SERIALNO" stringValue:@"123456"];
    GDataXMLElement *passwordElement = [GDataXMLNode elementWithName:@"PASSWORD" stringValue:@"Password"];
    GDataXMLElement *userElement = [GDataXMLNode elementWithName:@"USER" stringValue:@"123456"];
    GDataXMLElement *address0Element = [GDataXMLNode elementWithName:@"ADDRESS0"];
    GDataXMLElement *address1Element = [GDataXMLNode elementWithName:@"ADDRESS1" stringValue:@"Hattery"];
    GDataXMLElement *address2Element = [GDataXMLNode elementWithName:@"ADDRESS2" stringValue:@"414 Brannan Ave."];
    GDataXMLElement *address3Element = [GDataXMLNode elementWithName:@"ADDRESS3" stringValue:@"San Francisco, CA 94103"];
    
    [verifyAddressElement addChild:commandElement];
    [verifyAddressElement addChild:serialNoElement];
    [verifyAddressElement addChild:passwordElement];
    [verifyAddressElement addChild:userElement];
    [verifyAddressElement addChild:address0Element];
    [verifyAddressElement addChild:address1Element];
    [verifyAddressElement addChild:address2Element];
    [verifyAddressElement addChild:address3Element];
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithRootElement:verifyAddressElement];
    
    NSString *docXMLString = [[NSString alloc] initWithData:doc.XMLData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"docXMLString %@", docXMLString);
}


@end
