//
//  Created by 박영수 on 2/28/25.
//


import Foundation
import AvatyePointHome
import UIKit

@objc public class PHBridgeKit: NSObject, AvatyePHDelegate {
    
    private static var pointHomeService: AvatyePHService? = nil
    
    static let shared = PHBridgeKit()
    
    private static var openType: String? = nil
    private static var buttonPositionX: CGFloat = -1
    private static var buttonPositionY: CGFloat = -1
    
    
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
        openType = jsonObject["openType"] as? String
        buttonPositionX = jsonObject["buttonPositionX"] as? CGFloat ?? -1
        buttonPositionY = jsonObject["buttonPositionY"] as? CGFloat ?? -1
           
           
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
        
    
           
           print("PHBridgeKit.swift => makeBuilder: PointHomeService makeBuilder")
   }
       
    
   @objc public static func open() {
       print("PHBridgeKit.swift -> open")
       guard let service = pointHomeService else {
           print("Error: PointHomeService is not initialized")
           return
       }

       
       if (openType == "float") {
           pointHomeService?.setCashButton(bottom: buttonPositionX, trailing: buttonPositionY)
       } else if(openType == "bottom"){
           service.openPointHome { result in
               switch result {
               case .success(let t):
                   print("PHBridgeKit => open::success \(t)")
               case .failure(let error):
                   print("PHBridgeKit => open::failure \(error)")
               @unknown default:
                   print("PHBridgeKit => open::Unknown result")
               }
           }
       } else {
           print("PHBridgeKit => open:: type is nothing")
       }
   }
    
    @objc public static func close() {
        print("PHBridgeKit.swift -> close")
        guard let service = pointHomeService else {
            print("Error: PointHomeService is not initialized")
            return
        }
        
        if (openType == "bottom") {
            service.closePointHome {
                print("PHBridgeKit => closePointHome")
            }
        } else {
            print("PHBridgeKit => close::The close function can only use the bottom type!! ")
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
        print("PHBridgeKit.swift => initializeApplovin { params: \(params) }")
        AvatyePH.initializeAppLovin(params as String)        
    }

    @objc public static func initializePangle(_ params: NSString) {
        print("PHBridgeKit.swift => initializePangle { params: \(params) }")
        AvatyePH.initializePangle(params as String)
        
    }

    @objc public static func initializeVungle(_ params: NSString) {
        print("PHBridgeKit.swift => initializeVungle { params: \(params) }")
        AvatyePH.initializeVungle(params as String)
    }

}

