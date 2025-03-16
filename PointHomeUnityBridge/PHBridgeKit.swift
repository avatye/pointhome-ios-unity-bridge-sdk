//
//  Created by 박영수 on 2/28/25.
//


import Foundation
import AvatyePointHome
import UIKit

#if canImport(AppLovinSDK)
import AppLovinSDK
#endif

#if canImport(PAGAdSDK)
import PAGAdSDK
#endif

#if canImport(VungleAdsSDK)
import VungleAdsSDK
#endif

@objc public class PHBridgeKit: NSObject, AvatyePHDelegate {
    
    private static var pointHomeService: AvatyePHService? = nil
    
    static let shared = PHBridgeKit()
    
    
    @objc public static func initialize(_ params: NSString, initListener: @escaping(_ success: NSNumber, _ message: NSString) -> Void) {
       print("PHBridgeKit.swift -> initialize::   \(params)")
        
        if let jsonData = params.data(using: String.Encoding.utf8.rawValue) {
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    guard let appId = jsonObject["appID"] as? String else {
                        initListener(false, "appID must be not null or empty")
                        return
                    }
                    guard let appSecret = jsonObject["appSecret"] as? String else {
                        initListener(false, "appSecret must be not null or empty")
                        return
                        
                    }
                    // Pointhome initialize
                    AvatyePH.initialize(appId: appId, appSecretKey: appSecret, logLevel: .debug)
                    initListener(true, NSString(string: "Pointhome initialize success"))
                }
            } catch {
                initListener(false, NSString(string: "Pointhome initialize failure => \(error.localizedDescription)"))
            }
        }
    }
    
    @objc public static func makeBuilder(_ params: NSString) {
        print("PHBridgeKit.swift -> makeBuilder::   \(params)")
           
           guard let jsonData = params.data(using: String.Encoding.utf8.rawValue),
                 let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
               print("PHBridgeKit.swift => makeBuilder -> Error: Failed to parse JSON")
               return
           }
           
           guard let appId = jsonObject["appID"] as? String,
                 let appSecret = jsonObject["appSecret"] as? String,
                 let openKey = jsonObject["openKey"] as? String,
                 let fullScreen = jsonObject["fullScreen"] as? Bool else {
               print("PHBridgeKit.swift -> makeBuilder::Error: There is no json value!!")
               return
           }
         let userKey: String? = {
             if let key = jsonObject["userKey"] as? String, !key.isEmpty {
                 return key
             }
             return nil
         }()
        print("PHBridgeKit.swift -> userKey::   \(userKey ?? "nil")")
           
        // ios 13
//           guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
//               print("Error: rootViewController is nil")
//               return
//           }
        
        // ios 15
//           guard let rootVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
//              print("Error: rootViewController is nil")
//              return
//          }
        
            guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0 is UIWindowScene }) as? UIWindowScene,
                  let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
                print("PHBridgeKit.swift => Error: rootViewController is nil")
                return
            }
        
          
           
           pointHomeService = AvatyePHService(
               rootViewController: rootVC,
               appId: appId,
               appSecretKey: appSecret,
               userKey: userKey,
               openKey: openKey,
               fullScreen: fullScreen
           )
           pointHomeService?.delegate = PHBridgeKit.shared
           pointHomeService?.setCashButton()
           
           print("PHBridgeKit.swift => makeBuilder: PointHomeService makeBuilder")
   }
       
    
   @objc public static func open() {
       print("PHBridgeKit.swift -> open")
       guard let service = pointHomeService else {
           print("Error: PointHomeService is not initialized")
           return
       }
       
       service.openPointHome { result in
           switch result {
           case .success(let t):
               print("success \(t)")
           case .failure(let error):
               print("failure \(error)")
           @unknown default:
               print("Unknown result")
           }
       }
   }
    
    
    // 포인트홈 system Event 이벤트.
    public func pointHomeEventListener(event: String) {
        print("PHBridgeKit.swift => pointHomeEventListener \(event)")
    }
    
    // 포인트홈 iFrame Event 이벤트.
    public func pointHomeSystemEventListener(event: String) {
        print("PHBridgeKit.swift => pointHomeSystemEventListener \(event)")
    }
    
    // 포인트홈 슬라이더 open 이벤트
    public func pointHomeSliderOpened(caller: String) {
        print("PHBridgeKit.swift => pointHomeSliderOpened \(caller)")
    }
    
    // 포인트홈 슬라이더 closed 이벤트
    public func pointHomeSliderClosed(caller: String) {
        print("PHBridgeKit.swift => pointHomeSliderClosed \(caller)")
    }
    
    
    
    // 미디에이션 초기화 추가
    @objc public static func initializeApplovin(_ params: NSString) {
#if canImport(AppLovinSDK)
        print("PHBridgeKit.swift -> initializeAppLovin::    \(params)")
                   
           guard let jsonData = params.data(using: String.Encoding.utf8.rawValue),
                 let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
               print("PHBridgeKit.swift => initializeAppLovin -> Error: Failed to parse JSON")
               return
           }
           
           guard let applovinKey = jsonObject["applovinKey"] as? String else {
               print("PHBridgeKit.swift -> initializeAppLovin::Error: There is no json value!!")
               return
           }
        
        
        let initConfig = ALSdkInitializationConfiguration(sdkKey: applovinKey) { builder in
            builder.mediationProvider = ALMediationProviderMAX
        }
        ALSdk.shared().initialize(with: initConfig) { sdkConfig in
            print("PHBridgeKit.swift -> initializeAppLovin::{ AppLovin SDK initialized with success: \(sdkConfig) }")
        }
#endif
    }

    @objc public static func initializePangle(_ params: NSString) {
#if canImport(PAGAdSDK)
        print("PHBridgeKit.swift -> initializePangle::    \(params)")
                   
           guard let jsonData = params.data(using: String.Encoding.utf8.rawValue),
                 let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
               print("PHBridgeKit.swift => initializePangle -> Error: Failed to parse JSON")
               return
           }
           
           guard let pangleKey = jsonObject["pangleKey"] as? String else {
               print("PHBridgeKit.swift -> initializePangle::Error: There is no json value!!")
               return
           }
        
        let config = PAGConfig.share()
        config.appID = pangleKey
        PAGSdk.start(with: config) { pSuccess, error in
            if pSuccess {
                print("PHBridgeKit.swift -> initializePangle:: { PAG Success }")
            } else {
                print("PHBridgeKit.swift -> initializePangle:: { PAG Error: \(error?.localizedDescription ?? "Unknown error }")")
            }
        }
#endif
    }

    @objc public static func initializeVungle(_ params: NSString) {
#if canImport(VungleAdsSDK)
        print("PHBridgeKit.swift -> initializeVungle::    \(params)")
                   
           guard let jsonData = params.data(using: String.Encoding.utf8.rawValue),
                 let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
               print("PHBridgeKit.swift => initializeVungle -> Error: Failed to parse JSON")
               return
           }
           
           guard let vungleKey = jsonObject["vungleKey"] as? String else {
               print("PHBridgeKit.swift -> initializeVungle::Error: There is no json value!!")
               return
           }
        
        
        VungleAds.initWithAppId(vungleKey) { error in
            if let error = error {
                print("PHBridgeKit.swift -> initializeVungle:: { Vungle initialization failed with error: \(error.localizedDescription) }")
            } else {
                print("PHBridgeKit.swift -> initializeVungle:: { Vungle initialization success }")
            }
        }
        
        if VungleAds.isInitialized() {
            print("PHBridgeKit.swift -> initializeVungle:: { Vungle SDK is initialized } ")
        } else {
            print("PHBridgeKit.swift -> initializeVungle:: { Vungle SDK is Not initialized }")
        }
#endif
    }

}

