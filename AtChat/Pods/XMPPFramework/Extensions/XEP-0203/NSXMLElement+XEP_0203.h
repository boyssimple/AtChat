#import <Foundation/Foundation.h>
#import "DDXML.h"


@interface NSXMLElement (XEP_0203)

- (BOOL)wasDelayed;
- (NSDate *)delayedDeliveryDate;

@end
