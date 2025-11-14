//
//  DeviceInfo.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 14/11/25.
//


import Foundation
import UIKit
import CoreTelephony

@MainActor
class DeviceInfo {
    
    enum ScreenSizeType {
        case Mini
        case Meduim
        case Plus
        case XSerial
    }
    
    //single config
    private init() {}
    static let info = DeviceInfo()
    
    var model: String { return UIDevice.current.model }
    var systemName: String { return UIDevice.current.systemName }
    var systemVersion: String { return UIDevice.current.systemVersion }
    
    func deviceId() -> Int {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 960: return 0 //iPhone 4/4s
            case 1136:  return 1 //iPhone 5 or 5S or 5C
            case 1334: return 2 //iPhone 6/6S/7/8
            case 1920, 2208: return 3 //iPhone 6+/6S+/7+/8+
            case 2436: return 4 //iPhone X, XS
            case 2688: return 5 //iPhone XS Max, 11Pro Max
            case 1792: return 6 //iPhone XR
            default: return 999 //otherwise
            }
        }
        return 0
    }
    
    func deviceSize() -> CGSize { return UIScreen.main.bounds.size }
    
    func groupDeviceScreenType() -> ScreenSizeType {
        let _deviceId = deviceId()
        if _deviceId == 0 || _deviceId == 1 { return .Mini}
        else if _deviceId == 2 { return .Meduim }
        else if _deviceId == 3 { return .Plus }
        else if _deviceId == 4 || _deviceId == 5 || _deviceId == 6 { return .XSerial }
        else { return .XSerial }
    }
    
    func getAppVersion() -> String {
        let mainBundleDictionary = Bundle.main.infoDictionary! as NSDictionary
        return mainBundleDictionary.object(forKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    func getUUID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    func getCarrierName() -> String {
        let networkInfo = CTTelephonyNetworkInfo()
        return networkInfo.subscriberCellularProvider?.carrierName ?? ""
    }
    
    /**Sreinin add on : 2023.02.24 new class for scroll collectionView animation*/
    class func getDevice() -> String {
        var utsnameInstance = utsname()
        uname(&utsnameInstance)
        let optionalString: String? = withUnsafePointer(to: &utsnameInstance.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        return optionalString ?? "N/A"
    }
    class func getPixelPerInch() -> Int {
        let systemInfoString = DeviceInfo.getDevice()
        if systemInfoString == "x86_64" || systemInfoString == "i386" || systemInfoString == "N/A" { // iOS Simulator
            return 326
        }
        
        // IPhone
        if UIDevice.current.userInterfaceIdiom == .phone {
            let iPhonePlusTypes = Set<AnyHashable>(["iPhone7,1", "iPhone8,2", "iPhone9,2", "iPhone9,4"])
            if iPhonePlusTypes.contains(systemInfoString) {
                return 401
            }
            
            let iPhoneLowTypes = Set<AnyHashable>(["iPhone1,1", "iPhone1,2", "iPhone2,1"])
            if iPhoneLowTypes.contains(systemInfoString) {
                return 163
            }
            
            // iPhone3,1 iPhone3,2 iPhone3,3 iPhone4,1 iPhone5,1 iPhone5,2 iPhone5,3 iPhone5,4
            // iPhone6,1 iPhone6,2 iPhone7,2 iPhone8,1 iPhone8,4 iPhone9,1 iPhone9,3
            return 326;
        }
        
        // IPad Mini
        let iPadMiniTypes = Set<AnyHashable>(["iPad2,5", "iPad2,6", "iPad2,7",
                                              "iPad4,4", "iPad4,5", "iPad4,6",
                                              "iPad4,7", "iPad4,8", "iPad4,9",
                                              "iPad5,1", "iPad5,2"])
        if iPadMiniTypes.contains(systemInfoString) {
            let iPadMiniLowPPITypes = Set<AnyHashable>(["iPad2,5", "iPad2,6", "iPad2,7"])
            if iPadMiniLowPPITypes.contains(systemInfoString) {
                return 163
            }
            // iPad4,4 iPad4,5 iPad4,6 iPad4,7 iPad4,8 iPad4,9 iPad5,1 iPad5,2
            return 326
        }
        
        // IPod
        let iPodTypes = Set<AnyHashable>(["iPod1,1", "iPod2,1", "iPod3,1",
                                          "iPod4,1", "iPod5,1", "iPod7,1"])
        if iPodTypes.contains(systemInfoString) {
            let iPodLowPPITypes = Set<AnyHashable>(["iPod1,1", "iPod2,1", "iPod3,1"])
            if iPodLowPPITypes.contains(systemInfoString) {
                return 163
            }
            // iPod4,1 iPod5,1 iPod7,1
            return 326
        }
        
        // IPad
        let iPadLowPPITypes = Set<AnyHashable>(["iPad1,1","iPad2,1", "iPad2,2", "iPad2,3"])
        if iPadLowPPITypes.contains(systemInfoString) {
            return 132
        }
        // iPad3,1 iPad3,2 iPad3,3 iPad3,4 iPad3,5 iPad3,6 iPad4,1 iPad4,2 iPad4,3 iPad5,3 iPad5,4 iPad6,3 iPad6,4 iPad6,7 iPad6,8
        return 264;
    }
}