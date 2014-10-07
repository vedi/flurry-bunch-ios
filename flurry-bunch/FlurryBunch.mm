//
//  FlurryBunch.m
//  Unity-iPhone
//
//  Created by Shubin Fedor on 01/10/14.
//
//

#import "FlurryBunch.h"
#import "ProcessorEngine.h"
#import "Flurry.h"

@interface FlurryBunch ()
@end

@implementation FlurryBunch {

}

+ (id)sharedInstance {
    static FlurryBunch *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self alloc];
    });
    return sharedInstance;
}

+ (void)initialize {
    [super initialize];
    [self initGlue];
}

+ (void)registerProcessorForKey:(NSString *)key withBlock:(void (^)(NSDictionary *parameters, NSMutableDictionary *retParameters))callHandler {
    [[ProcessorEngine sharedInstance] registerProcessorForBunch:@"FlurryBunch" andKey:key withBlock:callHandler];
}

+ (void)initGlue {

    [self registerProcessorForKey:@"startSession" withBlock:^(NSDictionary *parameters, NSMutableDictionary *retParameters) {
        NSString *apiKey = parameters[@"apiKey"];
        [[FlurryBunch sharedInstance] startSession:apiKey];
    }];

    [self registerProcessorForKey:@"setAppVersion" withBlock:^(NSDictionary *parameters, NSMutableDictionary *retParameters) {
        NSString *appVersion = parameters[@"appVersion"];
        [[FlurryBunch sharedInstance] setAppVersion:appVersion];
    }];

    [self registerProcessorForKey:@"logEvent" withBlock:^(NSDictionary *parameters, NSMutableDictionary *retParameters) {
        NSString *eventId = parameters[@"eventId"];
        NSDictionary *eventParameters = parameters[@"parameters"];
        [[FlurryBunch sharedInstance] logEvent:eventId withParameters:eventParameters];
    }];

    [self registerProcessorForKey:@"logError" withBlock:^(NSDictionary *parameters, NSMutableDictionary *retParameters) {
        NSString *errorId = parameters[@"errorId"];
        NSString *message = parameters[@"message"];
        NSDictionary *errorParameters = parameters[@"parameters"];
        [[FlurryBunch sharedInstance] logError:errorId withMessage:message withParameters:errorParameters];
    }];

    [self registerProcessorForKey:@"logPageView" withBlock:^(NSDictionary *parameters, NSMutableDictionary *retParameters) {
        [[FlurryBunch sharedInstance] logPageView];
    }];

    [self registerProcessorForKey:@"logTimedEventBegin" withBlock:^(NSDictionary *parameters, NSMutableDictionary *retParameters) {
        NSString *eventId = parameters[@"eventId"];
        NSDictionary *eventParameters = parameters[@"parameters"];
        [[FlurryBunch sharedInstance] logTimedEventBegin:eventId withParameters:eventParameters];
    }];

    [self registerProcessorForKey:@"logTimedEventEnd" withBlock:^(NSDictionary *parameters, NSMutableDictionary *retParameters) {
        NSString *eventId = parameters[@"eventId"];
        NSDictionary *eventParameters = parameters[@"parameters"];
        [[FlurryBunch sharedInstance] logTimedEventEnd:eventId withParameters:eventParameters];
    }];

    [self registerProcessorForKey:@"setContinueSessionMillis" withBlock:^(NSDictionary *parameters, NSMutableDictionary *retParameters) {
        NSNumber *milliseconds = parameters[@"milliseconds"];
        [[FlurryBunch sharedInstance] setContinueSessionMillis:milliseconds];
    }];

    [self registerProcessorForKey:@"setDebugLogEnabled" withBlock:^(NSDictionary *parameters, NSMutableDictionary *retParameters) {
        NSNumber *enabled = parameters[@"enabled"];
        [[FlurryBunch sharedInstance] setDebugLogEnabled:enabled];
    }];

    [self registerProcessorForKey:@"setUserId" withBlock:^(NSDictionary *parameters, NSMutableDictionary *retParameters) {
        NSString *userId = parameters[@"userId"];
        [[FlurryBunch sharedInstance] setUserId:userId];
    }];

    [self registerProcessorForKey:@"setAge" withBlock:^(NSDictionary *parameters, NSMutableDictionary *retParameters) {
        NSNumber *age = parameters[@"age"];
        [[FlurryBunch sharedInstance] setAge:age];
    }];

}

- (void)startSession:(NSString *)apiKey {
    [Flurry startSession:apiKey];
}

- (void)setAppVersion:(NSString *)appVersion {
    [Flurry setAppVersion:appVersion];
}

- (void)logEvent:(NSString *)eventId withParameters:(NSDictionary *)parameters {
    [Flurry logEvent:eventId withParameters:parameters];
}

- (void)logError:(NSString *)errorId withMessage:(NSString *)message withParameters:(NSDictionary *)parameters {
    [Flurry logError:errorId message:message error:[NSError errorWithDomain:errorId code:-1 userInfo:parameters]];
}

- (void)logPageView {
    [Flurry logPageView];
}

- (void)logTimedEventBegin:(NSString *)eventId withParameters:(NSDictionary *)parameters {
    [Flurry logEvent:eventId withParameters:parameters timed:YES];
}

- (void)logTimedEventEnd:(NSString *)eventId withParameters:(NSDictionary *)parameters {
    [Flurry endTimedEvent:eventId withParameters:parameters];
}

- (void)setContinueSessionMillis:(NSNumber *)milliseconds {
    [Flurry setSessionContinueSeconds:[milliseconds intValue] / 1000];
}

- (void)setDebugLogEnabled:(NSNumber *)enabled {
    [Flurry setDebugLogEnabled:[enabled boolValue]];
}

- (void)setUserId:(NSString *)userId {
    [Flurry setUserID:userId];
}

- (void)setAge:(NSNumber *)age {
    [Flurry setAge:[age intValue]];
}

@end
