//
//  Styles.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/15/22.
//

import Foundation
import SwiftUI

//MARK: App Colors
extension Color {
    
    //Custom Named Colors
    static let ColumbiaBlue : Color = Color(red: 188/255, green: 235/255, blue: 255/255)
    
    static let LightCyan : Color = Color(214, 255, 255)
    
    static let RegentStBlue : Color = Color(red: 159/255, green: 210/255, blue: 215/255)
    
    static let Azure : Color = Color(241,254,255)
    
    static let CreamBrulee : Color = Color(255, 231, 148)
    
    static let Turquoise : Color = Color(25, 211, 206)
    
    static let DimGray : Color = Color(107, 107, 107)
    
    static let PurpleHeart : Color = Color(119, 28, 191)
    
    static let ERROR_COLOR : Color = Color(74, 65, 42)
    
    static let SummerSky : Color = Color(65, 198, 235)
    
    static let Gainsboro : Color = Color(217, 217, 217)
    
    static let StPatricksBlue : Color = Color(32, 26, 111)
    
    static let RadicalRed : Color = Color(248, 63, 94)
    
    static let ChartreuseYellow : Color = Color(255, 255, 0)

    
    //MARK: DO NOT ALTER FOLLOWING LINE
    static let ClaraPink : Color = Color(252,136,231)
    //DO NOT ALTER THE ABOVE LINE
}

struct Theme {
    
    static let MainColor : Color = .blue
    
    static let ButtonColor : Color = .StPatricksBlue//.ClaraPink//.pink//.StPatricksBlue
    
    static let DarkGray : Color = .DimGray
    
    static let DeselectedGray : Color = .Gainsboro
    
    
    struct Fonts {
        
        enum sizes : Int {
            case largeTitle = 34, title1 = 28, title2 = 22, title3 = 20, headline = 18, body = 17, callout = 16, subhead = 15, footnote = 13, caption1 = 12, caption2 = 11
            
            var asCGFloat : CGFloat {
                return CGFloat(self.rawValue)
            }
        }
        
        static let FONT_FAMILY : String = "Raleway-Regular"

        
    }
    
    static func Font(_ size : Fonts.sizes) -> Font {
        return SwiftUI.Font.custom(Fonts.FONT_FAMILY, size: size.asCGFloat)
    }
    
    static func Font(_ size : CGFloat = 17) -> Font {
        return SwiftUI.Font.custom(Fonts.FONT_FAMILY, size: size)
    }
    
    
//    static func Font(size: CGFloat) -> Font{
//        return SwiftUI.Font.custom("raleway", size: size)
//    }
//
//
//    static func Font(size : FontSizes) -> Font{
//        return Font(size: size.asCGFloat)
//    }
//
//    enum FontSizes : Int {
//        case body = 16, subTitle = 18, title = 30
//
//
//        var asCGFloat : CGFloat {
//            return CGFloat(self.rawValue)
//        }
//    }
}


