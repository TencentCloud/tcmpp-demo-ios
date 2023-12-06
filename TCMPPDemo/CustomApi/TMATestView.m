//
//  TMATestView.m
//  MiniAppDemo
//
//  Created by stonelshi on 2023/11/23.
//  Copyright © 2023 tencent. All rights reserved.
//

#import "TMATestView.h"
#import "TMAExternalJSPlugin.h"
#import "DemoUtils.h"

@interface TMATestView () <TMAExternalElementView>

@end

@implementation TMATestView {
    UILabel *_textLabel;
    UIButton *_clickButton;
    
    NSNumber *_elementId;
    id<TMAExternalJSContextProtocol> _context;
}

TMARegisterExternalElement(maTestView);


+ (UIView *)createWithParams:(NSDictionary *)params context:(id<TMAExternalJSContextProtocol>)context {
    TMATestView *testView = [[TMATestView alloc] initWithFrame:CGRectZero];
    NSDictionary *testViewParams = params[@"params"];
    if(testViewParams && [testViewParams isKindOfClass:[NSDictionary class]]) {
        [testView setText:[DemoUtils validNSString:testViewParams[@"text"]]];
    }
    
    testView->_elementId = params[@"externalElementId"];
    testView->_context = context;
    return testView;
}

- (void)operateWithParams:(NSDictionary *)param context:(id<TMAExternalJSContextProtocol>)context {
    NSDictionary *data = param[@"data"];
    NSDictionary *params1 = data[@"params1"];
    NSInteger age = [params1[@"age"] integerValue];
    NSString *name = params1[@"name"];
    
    __weak typeof(self) weakSelf = self;
    [DemoUtils executeOnMainThread:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf->_textLabel.text = [NSString stringWithFormat:@"name = %@ , age = %ld",name,(long)age];
            TMAExternalJSPluginResult *result = [TMAExternalJSPluginResult new];
            result.result = @{@"result":@"success"};
            [context doCallback:result];
        }
    }];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        
        self.layer.borderColor = [UIColor greenColor].CGColor;
        self.layer.borderWidth = 1.f;
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.font = [UIFont systemFontOfSize:16];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
        
        _clickButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _clickButton.layer.borderWidth = 1;
        [_clickButton setTitle:@"Click" forState:UIControlStateNormal];
        [_clickButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_clickButton addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_clickButton];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    _textLabel.frame = CGRectMake(0, 0, frame.size.width, 40);
    
    CGFloat btn_width = 100;
    _clickButton.frame = CGRectMake((frame.size.width - btn_width) / 2., 50, btn_width, 50);
}

- (void)onClickButton:(UIButton *)button {
    _textLabel.text = @"What do you want me to do";
    
    NSString *data = [DemoUtils convertToJsonData:@{@"externalElementId":_elementId,@"type": @"elvisgao callback"}];
    [_context doSubscribe:kTMAOnExternalElementEvent data:data];
}

- (void)setText:(NSString *)text {
    _textLabel.text = text;
}

@end
