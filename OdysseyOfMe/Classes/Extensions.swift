//
//  Extensions.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//

import Foundation
import SwiftUI

//MARK: Colors
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
    
    //MARK: DO NOT ALTER FOLLOWING LINE
    static let ClaraPink : Color = Color(252,136,231)
    //
}

struct Theme {
    
    static let MainColor : Color = .blue
    
    static let ButtonColor : Color = .StPatricksBlue//.ClaraPink//.pink//.StPatricksBlue
    
    static let DarkGray : Color = .DimGray
    
    static let DeselectedGray : Color = .Gainsboro
    
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    init(_ r : Int, _ g : Int, _ b : Int, _ a : Double = 1){
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 1
        )
    }
}


//MARK: View
extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
          GeometryReader { geometryProxy in
            Color.clear
              .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
          }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}



//MARK: Dates
//TODO: if within 24 hours, says its same day even if different calendar days
func isSameDay(date1: Date, date2: Date) -> Bool {
    let diff = Calendar.current.dateComponents([.day], from: date1, to: date2)
    if diff.day == 0 {
        return true
    } else {
        return false
    }
}

//TODO: Test .weekOfYear vs .weekOfMonth
func isSameWeek(date1: Date, date2: Date) -> Bool {
    let diff = Calendar.current.dateComponents([.weekOfYear], from: date1, to: date2)
    if diff.day == 0 {
        return true
    } else {
        return false
    }
}

func isSameMonth(date1: Date, date2: Date) -> Bool {
    let diff = Calendar.current.dateComponents([.month], from: date1, to: date2)
    if diff.day == 0 {
        return true
    } else {
        return false
    }
}
