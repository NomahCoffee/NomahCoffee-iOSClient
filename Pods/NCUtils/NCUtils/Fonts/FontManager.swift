//
//  FontManager.swift
//  NCUtils
//
//  Created by Caleb Rudnicki on 7/16/21.
//

import UIKit

internal class FontManager {
    
    // MARK: Public Functions
    
    class func OxygenBoldFontSize(_ size: CGFloat) -> UIFont {
        let fontName = "Oxygen-Bold"
        return loadFont(withName: fontName, size: size)
    }
    
    class func OxygenLightFontSize(_ size: CGFloat) -> UIFont {
        let fontName = "Oxygen-Light"
        return loadFont(withName: fontName, size: size)
    }
    
    class func OxygenRegularFontSize(_ size: CGFloat) -> UIFont {
        let fontName = "Oxygen-Regular"
        return loadFont(withName: fontName, size: size)
    }
    
    // MARK: Private Functions
    
    private class func loadFont(withName fontName: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: fontName, size: size) else {
            loadFontFromBundle(fontName)
            guard let font = UIFont(name: fontName, size: size) else {
                return UIFont.systemFont(ofSize: size)
            }
            return font
        }
        return font
    }
    
    private class func loadFontFromBundle(_ fontName: String) {
        let bundle = Bundle(for: FontManager.self)
        if let resourceURL = bundle.url(forResource: fontName, withExtension: "ttf") {
            if let fontData = try? Data(contentsOf: resourceURL) {
                if let provider = CGDataProvider(data: fontData as CFData), let fontRef = CGFont(provider) {
                    var error: Unmanaged<CFError>?
                    CTFontManagerRegisterGraphicsFont(fontRef, &error)
                }
            }
        }
    }
    
}
