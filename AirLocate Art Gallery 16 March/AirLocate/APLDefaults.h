

@import Foundation;


extern NSString *BeaconIdentifier;


@interface APLDefaults : NSObject

+ (APLDefaults *)sharedDefaults;

@property (nonatomic, copy, readonly) NSArray *supportedProximityUUIDs;

@property (nonatomic, copy, readonly) NSUUID *defaultProximityUUID;
@property (nonatomic, copy, readonly) NSNumber *defaultPower;
@property BOOL logInActionDone;

- (void) callbackWithResult:(NSArray *)result error:(NSError *)error;

@end
