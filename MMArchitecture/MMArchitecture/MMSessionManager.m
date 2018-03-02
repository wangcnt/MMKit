//
//  MMSessionManager.m
//  MMCoreServices
//
//  Created by Mark on 2018/1/23.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMSessionManager.h"

#import "MMConnection.h"
#import "MMRequest.h"
#import "MMResponse.h"
#import "MMSessionConfiguration.h"

@implementation MMSessionManager

- (void)cancelAllRequests {
}

- (void)cancelRequest:(id<MMRequest>)request {
}

- (void)cancelRequests:(NSArray<id<MMRequest>> *)requests {
}

- (void)startRequest:(id<MMRequest>)request withCompletion:(MMRequestCompletion)completion {
    __unused id<MMSessionConfiguration> configuration = request.configuration;
}

@end

@implementation MMHTTPSessionManager

@end

@interface MMSocketSessionManager ()

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, id<MMSocketConnection>> *connectionDictionary;
@property (nonatomic, strong, readonly) dispatch_semaphore_t semaphore;

@end

@implementation MMSocketSessionManager

@synthesize defaultConnection = _defaultConnection;
@synthesize freeConnection = _freeConnection;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pingInterval = 5;
        [self setupConnection:self.defaultConnection];
        _semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (id<MMSocketConnection>)defaultConnection {
    if(!_defaultConnection) {
        _defaultConnection = [[MMSocketConnection alloc] init];
        _defaultConnection.identifier = MMSocketConnectionDefaultIdentifier;
    }
    return _defaultConnection;
}

- (id<MMSocketConnection>)freeConnection {
    if(!_freeConnection) {
        _freeConnection = [[MMSocketConnection alloc] init];
        _freeConnection.identifier = MMSocketConnectionFreeIdentifier;
    }
    return _freeConnection;
}

- (void)startRequest:(id<MMSocketRequest>)request withCompletion:(MMRequestCompletion)completion {
    id<MMSocketConnection> connection = [self connectionWithRequest:request];
    [connection sendRequest:request withCompletion:completion];
}

- (void)connect {
    [self setupConnection:self.defaultConnection];
    [self.defaultConnection connect];
}

- (void)disconnect {
    [_connectionDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id<MMSocketConnection> connection , BOOL *stop) {
        [connection disconnect];
    }];
}

- (MMSocketConnectionLoginStatus)loginStatusForConnectionWithIdentifier:(NSString *)identifier {
    id<MMSocketConnection> connection = [self connectionWithIdentifier:identifier createIfNotExists:NO];
    return connection.loginStatus;
}

- (id<MMSocketConnection>)connectionWithRequest:(id<MMSocketRequest>)request {
    return [self connectionWithIdentifier:request.connectionID];
}

- (id<MMSocketConnection>)connectionWithIdentifier:(NSString *)identifier {
    return [self connectionWithIdentifier:identifier createIfNotExists:YES];
}

- (id<MMSocketConnection>)connectionWithIdentifier:(NSString *)identifier createIfNotExists:(BOOL)createIfNotExists {
    if(!identifier.length) {
        identifier = MMSocketConnectionDefaultIdentifier;
    }
    if([MMSocketConnectionDefaultIdentifier isEqualToString:identifier]) {
        return self.defaultConnection;
    }
    if([MMSocketConnectionFreeIdentifier isEqualToString:identifier]) {
        return self.freeConnection;
    }
    id<MMSocketConnection> connection = _connectionDictionary[identifier];
    if(connection) {
        return connection;
    } else if(createIfNotExists) {
        connection = [self generateAConnectionWithIdentifier:identifier];
        [self setupConnection:connection];
        [connection connect];
    }
    return connection;
}

- (id<MMSocketConnection>)anyOffworkedConnection {
    id<MMSocketConnection> connection = nil;
    for(id<MMSocketConnection> conn in _connectionDictionary.allValues) {
        if(conn.status == MMConnectionStatusOffworked) {
            connection = conn;
            break;
        }
    }
    if(!connection) {
        connection = [self generateAConnectionWithIdentifier:nil];
    }
    [self setupConnection:connection];
    [connection connect];
    return connection;
}

- (NSString *)identifierForAnyOffworkedConnection {
    return [self anyOffworkedConnection].identifier;
}

- (id<MMSocketConnection>)generateAConnectionWithIdentifier:(NSString *)identifier {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    identifier = identifier.length ? identifier : [NSString stringWithFormat:@"Conn.%lu", (unsigned long)_connectionDictionary.count];
    MMSocketConnection *connection = [[MMSocketConnection alloc] init];
    connection.identifier = identifier;
    _connectionDictionary[connection.identifier] = connection;
    dispatch_semaphore_signal(_semaphore);
    return connection;
}

- (void)setupConnection:(id<MMSocketConnection>)connection {
    if(!connection) return;
    connection.host = _host;
    connection.port = _port;
    connection.pingInterval = _pingInterval;
    connection.manager = self;
    _connectionDictionary[connection.identifier] = connection;
}

- (void)setConnectionFinishedWithIdentifier:(NSString *)identifier {
    id<MMSocketConnection> connection = _connectionDictionary[identifier];
    if(connection.type == MMSocketConnectionTypeGroup) {
        connection.status = MMConnectionStatusOffworked;
    }
}

@synthesize pingInterval = _pingInterval;
@synthesize port = _port;
@synthesize host = _host;

@end

