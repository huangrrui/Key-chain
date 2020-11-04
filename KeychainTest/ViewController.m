//
//  TestViewController.m
//  KeychainTest
//
//  Created by 黄瑞 on 2020/11/4.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *labelField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onAddTap:(UIButton *)sender {
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:@{
        (NSString *)kSecClass: (NSString *)kSecClassGenericPassword,
    }];
    if ([self.accountField.text isEqualToString:@""] == NO) query[(NSString *)kSecAttrAccount] = self.accountField.text;
    if ([self.labelField.text isEqualToString:@""] == NO) query[(NSString *)kSecAttrLabel] = self.labelField.text;
    if ([self.valueField.text isEqualToString:@""] == NO) query[(NSString *)kSecValueData] = [self.valueField.text dataUsingEncoding:NSUTF8StringEncoding];
    
    OSStatus status = SecItemAdd((CFDictionaryRef)query, NULL);
    if (status == errSecSuccess) NSLog(@"errSecSuccess");
    if (status == errSecDuplicateItem) NSLog(@"errSecDuplicateItem");
    if (status == errSecParam) NSLog(@"errSecParam");
}

- (IBAction)onDeleteTap:(UIButton *)sender {
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:@{
        (NSString *)kSecClass: (NSString *)kSecClassGenericPassword,
    }];
    if ([self.accountField.text isEqualToString:@""] == NO) query[(NSString *)kSecAttrAccount] = self.accountField.text;
    if ([self.labelField.text isEqualToString:@""] == NO) query[(NSString *)kSecAttrLabel] = self.labelField.text;
    if ([self.valueField.text isEqualToString:@""] == NO) query[(NSString *)kSecValueData] = [self.valueField.text dataUsingEncoding:NSUTF8StringEncoding];

    OSStatus status = SecItemDelete((CFDictionaryRef)query);
    if (status == errSecSuccess) NSLog(@"errSecSuccess");
    if (status == errSecItemNotFound) NSLog(@"errSecItemNotFound");
    if (status == errSecParam) NSLog(@"errSecParam");
}
- (IBAction)onUpdateTap:(UIButton *)sender {
    NSDictionary *query = @{
        (NSString *)kSecClass: (NSString *)kSecClassGenericPassword,
        (NSString *)kSecAttrAccount: @"1",
    };
    NSDictionary *update = @{
        (NSString *)kSecAttrAccount: @"2",
        (NSString *)kSecValueData: [@"1" dataUsingEncoding:NSUTF8StringEncoding],
    };

    OSStatus status = SecItemUpdate((CFDictionaryRef)query, (CFDictionaryRef)update);
    if (status == errSecSuccess) NSLog(@"errSecSuccess");
    if (status == errSecItemNotFound) NSLog(@"errSecItemNotFound");
    if (status == errSecDuplicateItem) NSLog(@"errSecDuplicateItem");
    if (status == errSecParam) NSLog(@"errSecParam");

}
- (IBAction)onMatchTap:(UIButton *)sender {
    CFTypeRef result;
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:@{
        (NSString *)kSecClass: (NSString *)kSecClassGenericPassword,
        (NSString *)kSecMatchLimit: (NSString *)kSecMatchLimitOne,
        (NSString *)kSecReturnData:(NSNumber *)kCFBooleanFalse,
        (NSString *)kSecReturnAttributes: (NSNumber *)kCFBooleanFalse,
    }];
    if ([self.accountField.text isEqualToString:@""] == NO) query[(NSString *)kSecAttrAccount] = self.accountField.text;
    if ([self.labelField.text isEqualToString:@""] == NO) query[(NSString *)kSecAttrLabel] = self.labelField.text;
    if ([self.valueField.text isEqualToString:@""] == NO) query[(NSString *)kSecValueData] = [self.valueField.text dataUsingEncoding:NSUTF8StringEncoding];

    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, &result);
    if (status == errSecSuccess) {
        NSLog(@"errSecSuccess");
        NSArray *itemAttr = (__bridge NSArray *)result;
        NSLog(@"%@", itemAttr);
    }
    if (status == errSecItemNotFound) NSLog(@"errSecItemNotFound");
    if (status == errSecParam) NSLog(@"errSecParam");
    
}
@end
