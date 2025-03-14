//
//  Created by 박영수 on 2/28/25.
// 정의
// Objective-C와 C++ 코드를 혼합하여 사용할 수 있는 파일
// Objective-C 인터페이스(.h 파일)에 선언된 메서드의 구현을 포함
// 역할
// objective-C와 Swift 코드를 연결하는 역할
// Swift 코드를 호출하고, Unity로 결과를 전달하는 로직

/**
 요약:
 Unity C# 스크립트 -> .mm 파일
 .mm 파일 -> .swift 파일
 .swift 파일 -> .mm 파일 (콜백)
 .mm 파일 -> Unity C# 스크립트 (콜백)
 .h 파일은 .mm 파일에서 Objective-C 인터페이스를 사용할 수 있도록 헤더 파일을 제공하는 역할을 합니다.
 */
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <PHBridge.h>
#import "PointHomeUnityBridge//PointHomeUnityBridge-Swift.h"



typedef void (*CompletionCallback)(bool success, const char* message);
extern "C" {
    void InitializePH(const char* jsonParams, CompletionCallback callback) {
        NSString* params = [NSString stringWithUTF8String:jsonParams];
        NSLog(@"InitializePH called with params: %@", params);
        [PHBridgeKit initialize:params initListener:^(NSNumber *success, NSString *message) {
            if (callback) {
                callback([success boolValue], [message UTF8String]);
            }
        }];
    }

    
   void MakeBuilderPH(const char* jsonParams) {
       NSString* params = [NSString stringWithUTF8String:jsonParams];
       NSLog(@"MakeBuilderPH called with params: %@", params);
       [PHBridgeKit makeBuilder:params];
   }

   
   void OpenPH() {
       NSLog(@"OpenPH called");
       [PHBridgeKit open];
   }


    void InitializeApplovin(const char* jsonParams) {
        NSString* params = [NSString stringWithUTF8String:jsonParams];
        NSLog(@"InitializeApplovin called with params: %@", params);
        [PHBridgeKit initializeApplovin:params];
    }

    
    void InitializePangle(const char* jsonParams) {
        NSString* params = [NSString stringWithUTF8String:jsonParams];
        NSLog(@"InitializePangle called with params: %@", params);
        [PHBridgeKit initializePangle:params];
    }

    void InitializeVungle(const char* jsonParams) {
        NSString* params = [NSString stringWithUTF8String:jsonParams];
        NSLog(@"InitializeVungle called with params: %@", params);
        [PHBridgeKit initializeVungle:params];
    }

}
