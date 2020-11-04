//
//  ViewController.m
//  KeychainTest
//
//  Created by 黄瑞 on 2020/10/21.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onCheckTap:(UIButton *)sender {
    NSDictionary *param = @{
        // 一个典型的查找请求，包含四个部分
        // 1、kSecClass key，它用来指定搜索对象的类型
        // 这里是 kSecClassGenericPassword
        (NSString *)kSecClass: (NSString *)kSecClassGenericPassword,
        // 2、一个或多个匹配项，这里仅使用账号名称进行匹配
        // 由于是单用户登录，可以将用户名写死
        (NSString *)kSecAttrAccount: @"uniqueID",
        // 3、高级搜索项，例如匹配一个还是所有，是否大小写敏感等
        // 这里只匹配一个
        (NSString *)kSecMatchLimit: (NSString *)kSecMatchLimitOne,
        // 4、指定返回值的类型
        // 这里需要保存的 Data 也就是用户 token，所以使用
        (NSString *)kSecReturnData: (NSNumber*)kCFBooleanTrue,
    };
    CFTypeRef resType;
    OSStatus result = SecItemCopyMatching((CFDictionaryRef)param, &resType);
    
    NSData *resData = (__bridge NSData *)resType;
    NSLog(@"resData = %@", [[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding]);
    if (result == errSecSuccess) {
        NSLog(@"errSecSuccess");
    } else if (result == errSecItemNotFound) {
        NSLog(@"errSecItemNotFound");
    } else {
        NSLog(@"err: %d", (int)result);
    }
}
- (IBAction)onAddTap:(UIButton *)sender {
    NSDictionary *param = @{
        (NSString *)kSecClass: (NSString *)kSecClassGenericPassword,
        (NSString *)kSecValueData: [@"123" dataUsingEncoding:NSUTF8StringEncoding],
        (NSString *)kSecAttrAccount: @"uniqueID",
    };
    CFTypeRef res;
    OSStatus result = SecItemAdd((CFDictionaryRef)param, &res);
    if (result == errSecSuccess) {
        NSLog(@"errSecSuccess");
    } else if (result == errSecDuplicateItem) {
        NSLog(@"errSecDuplicateItem");
    } else if (result == errSecItemNotFound) {
        NSLog(@"errSecItemNotFound");
    } else {
        NSLog(@"err: %d", (int)result);
    }
}

@end
