//
//  PaymentManager.m
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/8/6.
//

#import "PaymentManager.h"

#define TCMPP_PAY_URL  @"https://openapi-sg.tcmpp.com/superapp/pay/"
#define TCMPP_API_QUERY  @"queryPreOrder"
#define TCMPP_API_PAY  @"payOrder"

@interface XMLParser : NSObject<NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableDictionary *resultDict;
@property (nonatomic, strong) NSMutableString *currentElementValue;

- (NSDictionary *)dictionaryFromXMLData:(NSData *)xmlData;

@end

@implementation XMLParser

- (NSDictionary *)dictionaryFromXMLData:(NSData *)xmlData {
    self.resultDict = [NSMutableDictionary dictionary];
    self.currentElementValue = [NSMutableString string];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    parser.delegate = self;
    
    if ([parser parse]) {
        return self.resultDict;
    } else {
        NSLog(@"Parse error: %@", parser.parserError.localizedDescription);
        return nil;
    }
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    [self.currentElementValue setString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.currentElementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (![elementName isEqualToString:@"xml"]) {
        [self.resultDict setObject:[self.currentElementValue copy] forKey:elementName];
    }
}

@end

@implementation PaymentManager

+ (void)checkPreOrder:(NSString *)prePayId completion:(tcmppPayRequestHandler)handler {
    NSURL *url = [NSURL URLWithString:[TCMPP_PAY_URL stringByAppendingPathComponent:TCMPP_API_QUERY]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    request.HTTPMethod = @"POST";
    [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    
    NSString *xmlString = [NSString stringWithFormat:@"<xml><prepay_id>%@</prepay_id></xml>",prePayId];
    NSData *xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:xmlData];
    
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"tcmpp pay query error: %@", error);
            if(handler) {
                handler(error,nil);
            }
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            NSLog(@"tcmpp login request error code: %ld", (long)httpResponse.statusCode);
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"request error code: %ld", (long)httpResponse.statusCode] forKey:NSLocalizedDescriptionKey];
            if(handler) {
                handler([NSError errorWithDomain:@"KTCMPPPayQueryDomain" code:-1001 userInfo:userInfo],nil);
            }
            return;
        }
        
        NSString *errMsg = @"received response data error";
        NSInteger errCode = -1002;
        
        if (data) {
            XMLParser *parser = [[XMLParser alloc] init];
            NSDictionary *result = [parser dictionaryFromXMLData:data];
            NSString *returnCode = result[@"return_code"];
            if ([returnCode isEqualToString:@"SUCCESS"]) {
                if (handler) {
                    handler(nil,result);
                }
                return;
            } else {
                errMsg = result[@"return_msg"];
            }
        }
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
        if(handler) {
            handler([NSError errorWithDomain:@"KTCMPPPayQueryDomain" code:errCode userInfo:userInfo],nil);
        }
        return;
    }];
    
    [dataTask resume];
}

+ (void)payOrder:(NSString *)tradeNo prePayId:(NSString *)prePayId totalFee:(NSInteger)totalFee completion:(tcmppPayRequestHandler)handler {
    NSURL *url = [NSURL URLWithString:[TCMPP_PAY_URL stringByAppendingPathComponent:TCMPP_API_PAY]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    request.HTTPMethod = @"POST";
    [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    
    NSString *xmlString = [NSString stringWithFormat:@"<xml><out_trade_no>%@</out_trade_no><prepay_id>%@</prepay_id><total_fee>%ld</total_fee></xml>",tradeNo,prePayId,(long)totalFee];
    NSData *xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:xmlData];
    
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"tcmpp pay query error: %@", error);
            if(handler) {
                handler(error,nil);
            }
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            NSLog(@"tcmpp login request error code: %ld", (long)httpResponse.statusCode);
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"request error code: %ld", (long)httpResponse.statusCode] forKey:NSLocalizedDescriptionKey];
            if(handler) {
                handler([NSError errorWithDomain:@"KTCMPPPayQueryDomain" code:-1001 userInfo:userInfo],nil);
            }
            return;
        }
        
        NSString *errMsg = @"received response data error";
        NSInteger errCode = -1002;
        
        if (data) {
            XMLParser *parser = [[XMLParser alloc] init];
            NSDictionary *result = [parser dictionaryFromXMLData:data];
            NSString *returnCode = result[@"return_code"];
            if ([returnCode isEqualToString:@"SUCCESS"]) {
                if (handler) {
                    handler(nil,result);
                }
                return;
            } else {
                errMsg = result[@"return_msg"];
            }
        }
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
        if(handler) {
            handler([NSError errorWithDomain:@"KTCMPPPayQueryDomain" code:errCode userInfo:userInfo],nil);
        }
        return;
    }];
    
    [dataTask resume];
}

@end
