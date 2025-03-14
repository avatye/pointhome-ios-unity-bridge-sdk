//
//  Created by 박영수 on 2/28/25.
//

#import <Foundation/Foundation.h>

// In this header, you should import all the public headers of your framework using statements like #import <TreasureIslandBridgeKit/PublicHeader.h>
@interface PHBridge : NSObject
+ (void)initialize:(NSString *)params initListener:(void (^)(NSNumber *success, NSString *message))initListener;
+ (void)makeBuilder:(NSString *)params;
+ (void)open;
@end


