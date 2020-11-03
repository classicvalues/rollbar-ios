//
//  RollbarKSCrashCollector.m
//  
//
//  Created by Andrey Kornich on 2020-10-28.
//

#import "RollbarKSCrashCollector.h"
#import "RollbarCrashReportData.h"
#import "RollbarKSCrashInstallation.h"
#import "RollbarKSCrashReportSink.h"

@implementation RollbarKSCrashCollector

//- (nullable NSArray<RollbarCrashReportData *> *)collectCrashReports {
//
//    RollbarKSCrashInstallation *installation = [RollbarKSCrashInstallation sharedInstance];
//    [installation install];
//    [installation sendAllReportsWithCompletion:^(NSArray *filteredReports, BOOL completed, NSError *error) {
//        if (error) {
//            RollbarSdkLog(@"Could not enable crash reporter: %@", [error localizedDescription]);
//        } else if (completed) {
//            //[notifier processSavedItems];
//        }
//    }];}

//- (void)collectCrashReportsWithCompletion:(RollbarCrashCollectionCompletion)onCompletion {
//
//    RollbarKSCrashInstallation *installation = [RollbarKSCrashInstallation sharedInstance];
//    [installation install];
//    [installation sendAllReportsWithCompletion:onCompletion];
//}

+ (void)initialize {
    
    if (self == [RollbarKSCrashCollector class]) {
        RollbarKSCrashInstallation *installation = [RollbarKSCrashInstallation sharedInstance];
        [installation install];
    }
}

- (void)collectCrashReportsWithObserver:(NSObject<RollbarCrashCollectorObserver> *)observer {
    
    NSMutableArray<RollbarCrashReportData *> *crashReports = [[NSMutableArray alloc] init];

    RollbarKSCrashInstallation *installation = [RollbarKSCrashInstallation sharedInstance];
    [installation sendAllReportsWithCompletion:^(NSArray *filteredReports, BOOL completed, NSError *error) {
        if (error) {
            RollbarSdkLog(@"Could not enable crash reporter: %@", [error localizedDescription]);
        } else if (completed) {
            //[notifier processSavedItems];
            for (NSString *crashReport in filteredReports) {
                
                RollbarCrashReportData *crashReportData =
                [[RollbarCrashReportData alloc] initWithCrashReport:crashReport];
                
                [crashReports addObject:crashReportData];
            }
        }
    }];

    [observer onCrashReportsCollectionCompletion:crashReports];
}

//- (instancetype)initWithObserver:(id<RollbarCrashCollectorObserver>)observer {
//
//    if (self = [super initWithObserver:observer]) {
//    }
//    return self;
//}

@end
