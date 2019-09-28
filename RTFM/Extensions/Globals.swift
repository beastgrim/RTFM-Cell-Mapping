//
//  Globals.swift

import UIKit

let YandexMapsKey = "b515f5fd-3189-4842-a6a4-63188f99affa"

struct Global {
    static let currentLanguage = LocalizationManager.shared.language
    
    static let isEnglishLocale = Global.currentLanguage == "en"
    static let isRussianLocale = Global.currentLanguage == "ru"
}

func rgba(_ r: UInt8,_ g: UInt8, _ b: UInt8, _ a: CGFloat) -> UIColor {
    return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: a)
}

func UIColorFromHex(rgbValue: UInt32, alpha: Double = 1.0) -> UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8) / 256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    
    return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
}

func UIColorFromHexString(hexString: String) -> UIColor? {
    var rgbValue = UInt32(0)
    let scanner = Scanner(string: hexString.replacingOccurrences(of: "#", with: ""))
    if scanner.scanHexInt32(&rgbValue) {
        return UIColorFromHex(rgbValue: rgbValue)
    }
    return nil
}

func AppFontRegularWithSize(size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}

func AppFontSemiboldWithSize(size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
}

func AppFontBoldWithSize(size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
}

func AppFontHeavyWithSize(size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.heavy)
}

func AppFontItalicWithSize(size: CGFloat) -> UIFont {
    return UIFont.italicSystemFont(ofSize: size)
}

func AppFontMediumWithSize(size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
}

func AppFontLightWithSize(size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.light)
}

struct Screen {

    static let isRightToLeft = UIView.userInterfaceLayoutDirection(for: .unspecified) != .leftToRight || UIView.appearance().semanticContentAttribute == .forceRightToLeft
    
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    static var scale: CGFloat {
        return UIScreen.main.scale
    }
    
    static let onePixel: CGFloat = 1 / Screen.scale
    
    #if !TARGET_IOS_EXTENSION
    static var isLandscape: Bool {
        return UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight
    }
    
    static var isPortrait: Bool {
        return UIApplication.shared.statusBarOrientation == .portrait || UIApplication.shared.statusBarOrientation == .portraitUpsideDown
    }
    #endif
    
    static let isiPhone5Screen = Screen.height == 568
    static let isiPhone6Screen = Screen.height == 667
    static let isiPhonePlusScreen = Screen.height == 736
    static let isiPhoneXFamily = Screen.isiPhoneXScreen || Screen.isiPhoneXRScreen || Screen.isiPhoneXMaxScreen
    static let isiPhoneXScreen = Screen.height == 812
    static let isiPhoneXRScreen = Screen.height == 896 && Screen.scale == 2
    static let isiPhoneXMaxScreen = Screen.height == 896 && Screen.scale == 3
    
    #if targetEnvironment(macCatalyst)
        static let isMac = true
    #else
        static let isMac = false
    #endif
    
    static func normalizeCeil(_ value: CGFloat) -> CGFloat {
        return ceil(value * Screen.scale) / Screen.scale
    }
    
    static func normalizeFloor(_ value: CGFloat) -> CGFloat {
        return floor(value * Screen.scale) / Screen.scale
    }
    
    static func normalizeRound(_ value: CGFloat) -> CGFloat {
        return round(value * Screen.scale) / Screen.scale
    }
    
    static func normalizeCeilFrame(_ frame: CGRect) -> CGRect {
        return CGRect(x: Screen.normalizeCeil(frame.origin.x), y: Screen.normalizeCeil(frame.origin.y), width: Screen.normalizeCeil(frame.size.width), height: Screen.normalizeCeil(frame.size.height))
    }
    
    static func normalizeRoundFrame(_ frame: CGRect) -> CGRect {
        return CGRect(x: Screen.normalizeRound(frame.origin.x), y: Screen.normalizeRound(frame.origin.y), width: Screen.normalizeRound(frame.size.width), height: Screen.normalizeRound(frame.size.height))
    }
    
    static func normalizeFloorFrame(_ frame: CGRect) -> CGRect {
        return CGRect(x: Screen.normalizeFloor(frame.origin.x), y: Screen.normalizeFloor(frame.origin.y), width: Screen.normalizeFloor(frame.size.width), height: Screen.normalizeFloor(frame.size.height))
    }

}

extension NSString {
    
    func pluralKeyForCount(count: Int) -> String {
        let pluralType = PluralType.typeForCount(count: count)
        
        var key: String!
        
        let selfString = self as String
        
        switch pluralType {
        case .One:
            key = (selfString + "_ONE")
        case .Few:
            key = (selfString + "_FEW")
        case .Many:
            key = (selfString + "_MANY")
        }
        return key
    }
}

enum PluralType {
    case One
    case Few
    case Many
    
    static func typeForCount(count: Int) -> PluralType {
        if Global.isEnglishLocale {
            if count == 1 {
                return .One
            } else {
                return .Many
            }
        } else {
            let mod10 = count % 10
            let mod100 = count % 100
            
            switch mod100 {
            case 11, 12, 13, 14:
                break
            default:
                switch mod10 {
                case 1:
                    return .One
                case 2, 3, 4:
                    return .Few
                default:
                    break
                }
                break
            }
        }
        
        return .Many
    }
}

func delay(_ delay: Double, closure: @escaping () -> Void ) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}

class Weak<T: AnyObject> {
    weak var value: T?
    init (value: T) {
        self.value = value
    }
}
