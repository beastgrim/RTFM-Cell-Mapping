//
//  CoreTelephony.h
//  RTFM
//
//  Created by Евгений Богомолов on 28/09/2019.
//  Copyright © 2019 be. All rights reserved.
//

//#ifndef CoreTelephony_h
//#define CoreTelephony_h
//
//#import <CoreTelephony/CoreTelephonyDefines.h>
//
//@interface CTTelephonyNetworkInfo : NSObject {
//    NSString *_cachedCellId;
//    NSString *_cachedCurrentRadioAccessTechnology;
//    NSDictionary *_cachedSignalStrength;
//    BOOL _monitoringCellId;
//    struct queue {
//        struct dispatch_object_s {} *fObj;
//    } _queue;
//    CTCarrier *_subscriberCellularProvider;
//    id /* block */ _subscriberCellularProviderDidUpdateNotifier;
//    struct __CTServerConnection { struct __CFRuntimeBase { unsigned int x_1_1_1; unsigned char x_1_1_2[4]; } x1; struct dispatch_queue_s {} *x2; struct CTServerState {} *x3; unsigned char x4; unsigned int x5; struct _xpc_connection_s {} *x6; } *server_connection;
//    NSLock *server_lock;
//}
//
//@property (retain) NSString *cachedCellId;
//@property (retain) NSString *cachedCurrentRadioAccessTechnology;
//@property (retain) NSDictionary *cachedSignalStrength;
//@property (nonatomic, retain) NSString *cellId;
//@property (nonatomic, readonly, retain) NSString *currentRadioAccessTechnology;
//@property BOOL monitoringCellId;
//@property (retain) CTCarrier *subscriberCellularProvider;
//@property (nonatomic, copy) id /* block */ subscriberCellularProviderDidUpdateNotifier;
//
//- (id).cxx_construct;
//- (void).cxx_destruct;
//- (id)cachedCellId;
//- (id)cachedCurrentRadioAccessTechnology;
//- (id)cachedSignalStrength;
//- (id)cellId;
//- (void)cleanUpServerConnection;
//- (id)createSignalStrengthDictWithBars:(id)arg1;
//- (id)currentRadioAccessTechnology;
//- (void)dealloc;
//- (BOOL)getAllowsVOIP:(BOOL*)arg1 withCTError:(struct { int x1; int x2; }*)arg2;
//- (BOOL)getCarrierName:(id)arg1 withCTError:(struct { int x1; int x2; }*)arg2;
//- (BOOL)getMobileCountryCode:(id)arg1 andIsoCountryCode:(id)arg2 withCTError:(struct { int x1; int x2; }*)arg3;
//- (BOOL)getMobileNetworkCode:(id)arg1 withCTError:(struct { int x1; int x2; }*)arg2;
//- (void)handleCTRegistrationCellChangedNotification:(id)arg1;
//- (void)handleCTSignalStrengthNotification:(id)arg1;
//- (void)handleNotificationFromConnection:(void*)arg1 ofType:(id)arg2 withInfo:(id)arg3;
//- (id)init;
//- (BOOL)monitoringCellId;
//- (void)postCellularProviderUpdatesIfNecessary;
//- (void)queryCTSignalStrengthNotification;
//- (void)queryCellId;
//- (void)queryDataMode;
//- (id)radioAccessTechnology;
//- (void)setCachedCellId:(id)arg1;
//- (void)setCachedCurrentRadioAccessTechnology:(id)arg1;
//- (void)setCachedSignalStrength:(id)arg1;
//- (void)setCellId:(id)arg1;
//- (void)setMonitoringCellId:(BOOL)arg1;
//- (void)setSubscriberCellularProvider:(id)arg1;
//- (void)setSubscriberCellularProviderDidUpdateNotifier:(id /* block */)arg1;
//- (BOOL)setUpServerConnection;
//- (id)signalStrength;
//- (id)subscriberCellularProvider;
//- (id /* block */)subscriberCellularProviderDidUpdateNotifier;
//- (BOOL)updateNetworkInfoAndShouldNotifyClient:(BOOL*)arg1;
//- (void)updateRadioAccessTechnology:(id)arg1;
//- (void)updateSignalStrength:(id)arg1;
//
//@end
//
//#endif /* CoreTelephony_h */
