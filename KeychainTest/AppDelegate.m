//
//  AppDelegate.m
//  KeychainTest
//
//  Created by 黄瑞 on 2020/10/21.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    [self checkLoginStatus];
    return YES;
}

- (void)checkLoginStatus {
    NSDictionary *param = @{
        // 一个典型的查找请求，包含四个部分
        // 1、kSecClass key，它用来指定搜索对象的类型
        // 这里是 kSecClassGenericPassword
        (NSString *)kSecClass: (NSString *)kSecClassGenericPassword,
        // 2、一个或多个匹配项，这里仅使用账号名称进行匹配
        // 由于是单用户登录，可以将用户名写死
        (NSString *)kSecAttrAccount: @"uniqueID",
        // 3、高级搜索项，例如匹配一个还是所有，是否大小写敏感等
        // 这里选择只匹配一个
        (NSString *)kSecMatchLimit: (NSString *)kSecMatchLimitOne,
        // 4、指定返回值的类型
        // 这里需要保存的 Data 也就是用户 token
        (NSString *)kSecReturnData: (NSNumber*)kCFBooleanTrue,
        // 还还需要获取上次修改的日期，来判断 token 是否过期
        (NSString *)kSecReturnAttributes:(NSNumber *)kCFBooleanTrue,
    };
    
    CFTypeRef resType;
    OSStatus result = SecItemCopyMatching((CFDictionaryRef)param, &resType);
    
    if (result == errSecSuccess) {
        // 已存在用户登录信息
        NSDictionary *resDic = (__bridge NSDictionary *)resType;
        NSDate *lastModifyDate = resDic[(NSString *)kSecAttrModificationDate];
        if ([lastModifyDate timeIntervalSinceNow] < - 3600) {
            // token 已失效，重新获取 token
        } else {
            // 跳过登录页，进入首页
        }
    } else if (result == errSecItemNotFound) {
    } else {
    }

    NSDictionary *resDic = (__bridge NSDictionary *)resType;
    NSLog(@"resData = %@", resDic);
    
    NSData *tokenData = resDic[(NSString *)kSecValueData];
    NSString *token = [[NSString alloc] initWithData:tokenData encoding:NSUTF8StringEncoding];
    NSLog(@"token = %@", token);
    
    NSString *modifyDate = resDic[(NSString *)kSecAttrModificationDate];
    NSLog(@"modify date = %@", modifyDate);
    
}

@end
