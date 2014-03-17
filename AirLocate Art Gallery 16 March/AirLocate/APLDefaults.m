

#import "APLDefaults.h"


NSString *BeaconIdentifier = @"com.samarth.ArtGallery";


@implementation APLDefaults

- (id)init
{
    self = [super init];
    if(self)
    {
        // uuidgen should be used to generate UUIDs.
        
        
    }
    
    return self;
}

- (void) callbackWithResult:(NSArray *)result error:(NSError *)error
{
    NSMutableArray *uidArr = [[NSMutableArray alloc] init];
    if ([result count] >0)
    {
        for (int i=0; i<[result count]; i++)
        {
            PFObject *uidObject = [result objectAtIndex:i];
            NSString *uidString = [uidObject valueForKey:@"UID"];
            NSUUID *uid = [[NSUUID alloc] initWithUUIDString:uidString];
            [uidArr addObject:uid];
            
        }
        NSArray *cleanArray = [[NSSet setWithArray:uidArr] allObjects];
        _supportedProximityUUIDs = cleanArray;
    }
    
    // in case of connectivity issues, populate the default UUIDs B9407F30-F5F8-466E-AFF9-25556B57FE6D
    else
    {
        _supportedProximityUUIDs = @[[[NSUUID alloc] initWithUUIDString:@"8DEEFBB9-F738-4297-8040-96668BB44281"],
                                     [[NSUUID alloc] initWithUUIDString:@"ECABCF8F-23F0-4531-9522-3E75C3A40EA3"],
                                     [[NSUUID alloc] initWithUUIDString:@"D701BBC7-5BE5-4D93-BE07-3F216674D1B9"],
                                     [[NSUUID alloc] initWithUUIDString:@"8492E75F-4FD6-469D-B132-043FE94921D8"],
                                     [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]];
    }
    
    
    _defaultPower = @-59;
}

- (void) uuidCustomize
{
    
}

+ (APLDefaults *)sharedDefaults
{
    static id sharedDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDefaults = [[self alloc] init];
    });
    
    return sharedDefaults;
}


- (NSUUID *)defaultProximityUUID
{
    return _supportedProximityUUIDs[0];
}


@end
