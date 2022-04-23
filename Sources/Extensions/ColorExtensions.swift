//
//  ColorExtensions.swift
//  UtilityPackage
//
//  Created by Irshad Ahmad on 05/04/22.
//

#if !os(Linux)

#if canImport(UIKit)
import UIKit
/// UtilityPackage: Color
public typealias Color = UIColor
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
/// UtilityPackage: Color
public typealias Color = NSColor
#endif

#if !os(watchOS)
import CoreImage
#endif

// MARK: - Properties
public extension Color {
    /// UtilityPackage: Random color.
    static var random: Color {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)
        return Color(red: red, green: green, blue: blue)!
    }

    // swiftlint:disable large_tuple
    /// UtilityPackage: RGB components for a Color (between 0 and 255).
    ///
    ///     UIColor.red.rgbComponents.red -> 255
    ///     NSColor.green.rgbComponents.green -> 255
    ///     UIColor.blue.rgbComponents.blue -> 255
    ///
    var rgbComponents: (red: Int, green: Int, blue: Int) {
        let components: [CGFloat] = {
            let comps: [CGFloat] = cgColor.components!
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        return (red: Int(red * 255.0), green: Int(green * 255.0), blue: Int(blue * 255.0))
    }

    // swiftlint:enable large_tuple
    // swiftlint:disable large_tuple
    /// UtilityPackage: RGB components for a Color represented as CGFloat numbers (between 0 and 1).
    ///
    ///     UIColor.red.rgbComponents.red -> 1.0
    ///     NSColor.green.rgbComponents.green -> 1.0
    ///     UIColor.blue.rgbComponents.blue -> 1.0
    ///
    var cgFloatComponents: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let components: [CGFloat] = {
            let comps: [CGFloat] = cgColor.components!
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        return (red: red, green: green, blue: blue)
    }

    // swiftlint:enable large_tuple
    // swiftlint:disable large_tuple
    /// UtilityPackage: Get components of hue, saturation, and brightness, and alpha (read-only).
    var hsbaComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    // swiftlint:enable large_tuple
    /// UtilityPackage: Hexadecimal value string (read-only).
    var hexString: String {
        let components: [Int] = {
            let comps = cgColor.components!.map { Int($0 * 255.0) }
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()
        return String(format: "#%02X%02X%02X", components[0], components[1], components[2])
    }

    /// UtilityPackage: Short hexadecimal value string (read-only, if applicable).
    var shortHexString: String? {
        let string = hexString.replacingOccurrences(of: "#", with: "")
        let chrs = Array(string)
        guard chrs[0] == chrs[1], chrs[2] == chrs[3], chrs[4] == chrs[5] else { return nil }
        return "#\(chrs[0])\(chrs[2])\(chrs[4])"
    }

    /// UtilityPackage: Short hexadecimal value string, or full hexadecimal string if not possible (read-only).
    var shortHexOrHexString: String {
        let components: [Int] = {
            let comps = cgColor.components!.map { Int($0 * 255.0) }
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()
        let hexString = String(format: "#%02X%02X%02X", components[0], components[1], components[2])
        let string = hexString.replacingOccurrences(of: "#", with: "")
        let chrs = Array(string)
        guard chrs[0] == chrs[1], chrs[2] == chrs[3], chrs[4] == chrs[5] else { return hexString }
        return "#\(chrs[0])\(chrs[2])\(chrs[4])"
    }

    /// UtilityPackage: Alpha of Color (read-only).
    var alpha: CGFloat {
        return cgColor.alpha
    }

    #if !os(watchOS)
    /// UtilityPackage: CoreImage.CIColor (read-only).
    var coreImageColor: CoreImage.CIColor? {
        return CoreImage.CIColor(color: self)
    }
    #endif

    /// UtilityPackage: Get UInt representation of a Color (read-only).
    var uInt: UInt {
        let components: [CGFloat] = {
            let comps: [CGFloat] = cgColor.components!
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()

        var colorAsUInt32: UInt32 = 0
        colorAsUInt32 += UInt32(components[0] * 255.0) << 16
        colorAsUInt32 += UInt32(components[1] * 255.0) << 8
        colorAsUInt32 += UInt32(components[2] * 255.0)

        return UInt(colorAsUInt32)
    }

    /// UtilityPackage: Get color complementary (read-only, if applicable).
    var complementary: Color? {
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        let convertColorToRGBSpace: ((_ color: Color) -> Color?) = { _ -> Color? in
            if self.cgColor.colorSpace!.model == CGColorSpaceModel.monochrome {
                let oldComponents = self.cgColor.components
                let components: [CGFloat] = [oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1]]
                let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
                let colorOut = Color(cgColor: colorRef!)
                return colorOut
            } else {
                return self
            }
        }

        let color = convertColorToRGBSpace(self)
        guard let componentColors = color?.cgColor.components else { return nil }

        let red: CGFloat = sqrt(pow(255.0, 2.0) - pow(componentColors[0] * 255, 2.0)) / 255
        let green: CGFloat = sqrt(pow(255.0, 2.0) - pow(componentColors[1] * 255, 2.0)) / 255
        let blue: CGFloat = sqrt(pow(255.0, 2.0) - pow(componentColors[2] * 255, 2.0)) / 255

        return Color(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

// MARK: - Methods
public extension Color {
    /// UtilityPackage: Blend two Colors.
    ///
    /// - Parameters:
    ///   - color1: first color to blend
    ///   - intensity1: intensity of first color (default is 0.5)
    ///   - color2: second color to blend
    ///   - intensity2: intensity of second color (default is 0.5)
    /// - Returns: Color created by blending first and second colors.
    static func blend(_ color1: Color, intensity1: CGFloat = 0.5, with color2: Color,
                      intensity2: CGFloat = 0.5) -> Color {
        // http://stackoverflow.com/questions/27342715/blend-uicolors-in-swift
        let total = intensity1 + intensity2
        let level1 = intensity1 / total
        let level2 = intensity2 / total

        guard level1 > 0 else { return color2 }
        guard level2 > 0 else { return color1 }

        let components1: [CGFloat] = {
            let comps: [CGFloat] = color1.cgColor.components!
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()

        let components2: [CGFloat] = {
            let comps: [CGFloat] = color2.cgColor.components!
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()

        let red1 = components1[0]
        let red2 = components2[0]

        let green1 = components1[1]
        let green2 = components2[1]

        let blue1 = components1[2]
        let blue2 = components2[2]

        let alpha1 = color1.cgColor.alpha
        let alpha2 = color2.cgColor.alpha

        let red = level1 * red1 + level2 * red2
        let green = level1 * green1 + level2 * green2
        let blue = level1 * blue1 + level2 * blue2
        let alpha = level1 * alpha1 + level2 * alpha2

        return Color(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// UtilityPackage: Lighten a color.
    ///
    ///     let color = Color(red: r, green: g, blue: b, alpha: a)
    ///     let lighterColor: Color = color.lighten(by: 0.2)
    ///
    /// - Parameter percentage: Percentage by which to lighten the color.
    /// - Returns: A lightened color.
    func lighten(by percentage: CGFloat = 0.2) -> Color {
        // https://stackoverflow.com/questions/38435308/swift-get-lighter-and-darker-color-variations-for-a-given-uicolor
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return Color(red: min(red + percentage, 1.0),
                     green: min(green + percentage, 1.0),
                     blue: min(blue + percentage, 1.0),
                     alpha: alpha)
    }

    /// UtilityPackage: Darken a color.
    ///
    ///     let color = Color(red: r, green: g, blue: b, alpha: a)
    ///     let darkerColor: Color = color.darken(by: 0.2)
    ///
    /// - Parameter percentage: Percentage by which to darken the color.
    /// - Returns: A darkened color.
    func darken(by percentage: CGFloat = 0.2) -> Color {
        // https://stackoverflow.com/questions/38435308/swift-get-lighter-and-darker-color-variations-for-a-given-uicolor
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return Color(red: max(red - percentage, 0),
                     green: max(green - percentage, 0),
                     blue: max(blue - percentage, 0),
                     alpha: alpha)
    }
}

// MARK: - Initializers
public extension Color {
    /// UtilityPackage: Create Color from RGB values with optional transparency.
    ///
    /// - Parameters:
    ///   - red: red component.
    ///   - green: green component.
    ///   - blue: blue component.
    ///   - transparency: optional transparency value (default is 1).
    convenience init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        guard red >= 0, red <= 255 else { return nil }
        guard green >= 0, green <= 255 else { return nil }
        guard blue >= 0, blue <= 255 else { return nil }

        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }

    /// UtilityPackage: Create Color from hexadecimal value with optional transparency.
    ///
    /// - Parameters:
    ///   - hex: hex Int (example: 0xDECEB5).
    ///   - transparency: optional transparency value (default is 1).
    convenience init?(hex: Int, transparency: CGFloat = 1) {
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }

        let red = (hex >> 16) & 0xFF
        let green = (hex >> 8) & 0xFF
        let blue = hex & 0xFF
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }

    /// UtilityPackage: Create Color from hexadecimal string with optional transparency (if applicable).
    ///
    /// - Parameters:
    ///   - hexString: hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
    ///   - transparency: optional transparency value (default is 1).
    convenience init?(hexString: String, transparency: CGFloat = 1) {
        var string = ""
        let lowercaseHexString = hexString.lowercased()
        if lowercaseHexString.hasPrefix("0x") {
            string = lowercaseHexString.replacingOccurrences(of: "0x", with: "")
        } else if hexString.hasPrefix("#") {
            string = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            string = hexString
        }

        if string.count == 3 { // convert hex to 6 digit format if in short format
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }

        guard let hexValue = Int(string, radix: 16) else { return nil }

        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }

        let red = (hexValue >> 16) & 0xFF
        let green = (hexValue >> 8) & 0xFF
        let blue = hexValue & 0xFF
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }

    /// UtilityPackage: Create Color from hexadecimal string in the format ARGB (alpha-red-green-blue).
    ///
    /// - Parameters:
    ///   - argbHexString: hexadecimal string (examples: 7FEDE7F6, 0x7FEDE7F6, #7FEDE7F6, #f0ff, 0xFF0F, ..).
    convenience init?(argbHexString: String) {
        var string = argbHexString.replacingOccurrences(of: "0x", with: "").replacingOccurrences(of: "#", with: "")

        if string.count <= 4 { // convert hex to long format if in short format
            var str = ""
            for character in string {
                str.append(String(repeating: String(character), count: 2))
            }
            string = str
        }

        guard let hexValue = Int(string, radix: 16) else { return nil }

        let hasAlpha = string.count == 8

        let alpha = hasAlpha ? (hexValue >> 24) & 0xFF : 0xFF
        let red = (hexValue >> 16) & 0xFF
        let green = (hexValue >> 8) & 0xFF
        let blue = hexValue & 0xFF

        self.init(red: red, green: green, blue: blue, transparency: CGFloat(alpha) / 255)
    }

    /// UtilityPackage: Create Color from a complementary of a Color (if applicable).
    ///
    /// - Parameter color: color of which opposite color is desired.
    convenience init?(complementaryFor color: Color) {
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        let convertColorToRGBSpace: ((_ color: Color) -> Color?) = { color -> Color? in
            if color.cgColor.colorSpace!.model == CGColorSpaceModel.monochrome {
                let oldComponents = color.cgColor.components
                let components: [CGFloat] = [oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1]]
                let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
                let colorOut = Color(cgColor: colorRef!)
                return colorOut
            } else {
                return color
            }
        }

        let color = convertColorToRGBSpace(color)
        guard let componentColors = color?.cgColor.components else { return nil }

        let red: CGFloat = sqrt(pow(255.0, 2.0) - pow(componentColors[0] * 255, 2.0)) / 255
        let green: CGFloat = sqrt(pow(255.0, 2.0) - pow(componentColors[1] * 255, 2.0)) / 255
        let blue: CGFloat = sqrt(pow(255.0, 2.0) - pow(componentColors[2] * 255, 2.0)) / 255
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

// MARK: - Social
public extension Color {
    /// UtilityPackage: Brand identity color of popular social media platform.
    enum Social {
        // https://www.lockedowndesign.com/social-media-colors/
        /// UtilityPackage: red: 59, green: 89, blue: 152
        public static let facebook = Color(red: 59, green: 89, blue: 152)!

        /// UtilityPackage: red: 0, green: 182, blue: 241
        public static let twitter = Color(red: 0, green: 182, blue: 241)!

        /// UtilityPackage: red: 223, green: 74, blue: 50
        public static let googlePlus = Color(red: 223, green: 74, blue: 50)!

        /// UtilityPackage: red: 0, green: 123, blue: 182
        public static let linkedIn = Color(red: 0, green: 123, blue: 182)!

        /// UtilityPackage: red: 69, green: 187, blue: 255
        public static let vimeo = Color(red: 69, green: 187, blue: 255)!

        /// UtilityPackage: red: 179, green: 18, blue: 23
        public static let youtube = Color(red: 179, green: 18, blue: 23)!

        /// UtilityPackage: red: 195, green: 42, blue: 163
        public static let instagram = Color(red: 195, green: 42, blue: 163)!

        /// UtilityPackage: red: 203, green: 32, blue: 39
        public static let pinterest = Color(red: 203, green: 32, blue: 39)!

        /// UtilityPackage: red: 244, green: 0, blue: 131
        public static let flickr = Color(red: 244, green: 0, blue: 131)!

        /// UtilityPackage: red: 67, green: 2, blue: 151
        public static let yahoo = Color(red: 67, green: 2, blue: 151)!

        /// UtilityPackage: red: 67, green: 2, blue: 151
        public static let soundCloud = Color(red: 67, green: 2, blue: 151)!

        /// UtilityPackage: red: 44, green: 71, blue: 98
        public static let tumblr = Color(red: 44, green: 71, blue: 98)!

        /// UtilityPackage: red: 252, green: 69, blue: 117
        public static let foursquare = Color(red: 252, green: 69, blue: 117)!

        /// UtilityPackage: red: 255, green: 176, blue: 0
        public static let swarm = Color(red: 255, green: 176, blue: 0)!

        /// UtilityPackage: red: 234, green: 76, blue: 137
        public static let dribbble = Color(red: 234, green: 76, blue: 137)!

        /// UtilityPackage: red: 255, green: 87, blue: 0
        public static let reddit = Color(red: 255, green: 87, blue: 0)!

        /// UtilityPackage: red: 74, green: 93, blue: 78
        public static let devianArt = Color(red: 74, green: 93, blue: 78)!

        /// UtilityPackage: red: 238, green: 64, blue: 86
        public static let pocket = Color(red: 238, green: 64, blue: 86)!

        /// UtilityPackage: red: 170, green: 34, blue: 182
        public static let quora = Color(red: 170, green: 34, blue: 182)!

        /// UtilityPackage: red: 247, green: 146, blue: 30
        public static let slideShare = Color(red: 247, green: 146, blue: 30)!

        /// UtilityPackage: red: 0, green: 153, blue: 229
        public static let px500 = Color(red: 0, green: 153, blue: 229)!

        /// UtilityPackage: red: 223, green: 109, blue: 70
        public static let listly = Color(red: 223, green: 109, blue: 70)!

        /// UtilityPackage: red: 0, green: 180, blue: 137
        public static let vine = Color(red: 0, green: 180, blue: 137)!

        /// UtilityPackage: red: 0, green: 175, blue: 240
        public static let skype = Color(red: 0, green: 175, blue: 240)!

        /// UtilityPackage: red: 235, green: 73, blue: 36
        public static let stumbleUpon = Color(red: 235, green: 73, blue: 36)!

        /// UtilityPackage: red: 255, green: 252, blue: 0
        public static let snapchat = Color(red: 255, green: 252, blue: 0)!

        /// UtilityPackage: red: 37, green: 211, blue: 102
        public static let whatsApp = Color(red: 37, green: 211, blue: 102)!
    }
}

// MARK: - Material colors
public extension Color {
    // swiftlint:disable type_body_length
    /// UtilityPackage: Google Material design colors palette.
    enum Material {
        // https://material.google.com/style/color.html
        /// UtilityPackage: color red500
        public static let red = red500

        /// UtilityPackage: hex #FFEBEE
        public static let red50 = Color(hex: 0xFFEBEE)!

        /// UtilityPackage: hex #FFCDD2
        public static let red100 = Color(hex: 0xFFCDD2)!

        /// UtilityPackage: hex #EF9A9A
        public static let red200 = Color(hex: 0xEF9A9A)!

        /// UtilityPackage: hex #E57373
        public static let red300 = Color(hex: 0xE57373)!

        /// UtilityPackage: hex #EF5350
        public static let red400 = Color(hex: 0xEF5350)!

        /// UtilityPackage: hex #F44336
        public static let red500 = Color(hex: 0xF44336)!

        /// UtilityPackage: hex #E53935
        public static let red600 = Color(hex: 0xE53935)!

        /// UtilityPackage: hex #D32F2F
        public static let red700 = Color(hex: 0xD32F2F)!

        /// UtilityPackage: hex #C62828
        public static let red800 = Color(hex: 0xC62828)!

        /// UtilityPackage: hex #B71C1C
        public static let red900 = Color(hex: 0xB71C1C)!

        /// UtilityPackage: hex #FF8A80
        public static let redA100 = Color(hex: 0xFF8A80)!

        /// UtilityPackage: hex #FF5252
        public static let redA200 = Color(hex: 0xFF5252)!

        /// UtilityPackage: hex #FF1744
        public static let redA400 = Color(hex: 0xFF1744)!

        /// UtilityPackage: hex #D50000
        public static let redA700 = Color(hex: 0xD50000)!

        /// UtilityPackage: color pink500
        public static let pink = pink500

        /// UtilityPackage: hex #FCE4EC
        public static let pink50 = Color(hex: 0xFCE4EC)!

        /// UtilityPackage: hex #F8BBD0
        public static let pink100 = Color(hex: 0xF8BBD0)!

        /// UtilityPackage: hex #F48FB1
        public static let pink200 = Color(hex: 0xF48FB1)!

        /// UtilityPackage: hex #F06292
        public static let pink300 = Color(hex: 0xF06292)!

        /// UtilityPackage: hex #EC407A
        public static let pink400 = Color(hex: 0xEC407A)!

        /// UtilityPackage: hex #E91E63
        public static let pink500 = Color(hex: 0xE91E63)!

        /// UtilityPackage: hex #D81B60
        public static let pink600 = Color(hex: 0xD81B60)!

        /// UtilityPackage: hex #C2185B
        public static let pink700 = Color(hex: 0xC2185B)!

        /// UtilityPackage: hex #AD1457
        public static let pink800 = Color(hex: 0xAD1457)!

        /// UtilityPackage: hex #880E4F
        public static let pink900 = Color(hex: 0x880E4F)!

        /// UtilityPackage: hex #FF80AB
        public static let pinkA100 = Color(hex: 0xFF80AB)!

        /// UtilityPackage: hex #FF4081
        public static let pinkA200 = Color(hex: 0xFF4081)!

        /// UtilityPackage: hex #F50057
        public static let pinkA400 = Color(hex: 0xF50057)!

        /// UtilityPackage: hex #C51162
        public static let pinkA700 = Color(hex: 0xC51162)!

        /// UtilityPackage: color purple500
        public static let purple = purple500

        /// UtilityPackage: hex #F3E5F5
        public static let purple50 = Color(hex: 0xF3E5F5)!

        /// UtilityPackage: hex #E1BEE7
        public static let purple100 = Color(hex: 0xE1BEE7)!

        /// UtilityPackage: hex #CE93D8
        public static let purple200 = Color(hex: 0xCE93D8)!

        /// UtilityPackage: hex #BA68C8
        public static let purple300 = Color(hex: 0xBA68C8)!

        /// UtilityPackage: hex #AB47BC
        public static let purple400 = Color(hex: 0xAB47BC)!

        /// UtilityPackage: hex #9C27B0
        public static let purple500 = Color(hex: 0x9C27B0)!

        /// UtilityPackage: hex #8E24AA
        public static let purple600 = Color(hex: 0x8E24AA)!

        /// UtilityPackage: hex #7B1FA2
        public static let purple700 = Color(hex: 0x7B1FA2)!

        /// UtilityPackage: hex #6A1B9A
        public static let purple800 = Color(hex: 0x6A1B9A)!

        /// UtilityPackage: hex #4A148C
        public static let purple900 = Color(hex: 0x4A148C)!

        /// UtilityPackage: hex #EA80FC
        public static let purpleA100 = Color(hex: 0xEA80FC)!
//
        /// UtilityPackage: hex #E040FB
        public static let purpleA200 = Color(hex: 0xE040FB)!

        /// UtilityPackage: hex #D500F9
        public static let purpleA400 = Color(hex: 0xD500F9)!

        /// UtilityPackage: hex #AA00FF
        public static let purpleA700 = Color(hex: 0xAA00FF)!

        /// UtilityPackage: color deepPurple500
        public static let deepPurple = deepPurple500

        /// UtilityPackage: hex #EDE7F6
        public static let deepPurple50 = Color(hex: 0xEDE7F6)!

        /// UtilityPackage: hex #D1C4E9
        public static let deepPurple100 = Color(hex: 0xD1C4E9)!

        /// UtilityPackage: hex #B39DDB
        public static let deepPurple200 = Color(hex: 0xB39DDB)!

        /// UtilityPackage: hex #9575CD
        public static let deepPurple300 = Color(hex: 0x9575CD)!

        /// UtilityPackage: hex #7E57C2
        public static let deepPurple400 = Color(hex: 0x7E57C2)!

        /// UtilityPackage: hex #673AB7
        public static let deepPurple500 = Color(hex: 0x673AB7)!

        /// UtilityPackage: hex #5E35B1
        public static let deepPurple600 = Color(hex: 0x5E35B1)!

        /// UtilityPackage: hex #512DA8
        public static let deepPurple700 = Color(hex: 0x512DA8)!

        /// UtilityPackage: hex #4527A0
        public static let deepPurple800 = Color(hex: 0x4527A0)!

        /// UtilityPackage: hex #311B92
        public static let deepPurple900 = Color(hex: 0x311B92)!

        /// UtilityPackage: hex #B388FF
        public static let deepPurpleA100 = Color(hex: 0xB388FF)!

        /// UtilityPackage: hex #7C4DFF
        public static let deepPurpleA200 = Color(hex: 0x7C4DFF)!

        /// UtilityPackage: hex #651FFF
        public static let deepPurpleA400 = Color(hex: 0x651FFF)!

        /// UtilityPackage: hex #6200EA
        public static let deepPurpleA700 = Color(hex: 0x6200EA)!

        /// UtilityPackage: color indigo500
        public static let indigo = indigo500

        /// UtilityPackage: hex #E8EAF6
        public static let indigo50 = Color(hex: 0xE8EAF6)!

        /// UtilityPackage: hex #C5CAE9
        public static let indigo100 = Color(hex: 0xC5CAE9)!

        /// UtilityPackage: hex #9FA8DA
        public static let indigo200 = Color(hex: 0x9FA8DA)!

        /// UtilityPackage: hex #7986CB
        public static let indigo300 = Color(hex: 0x7986CB)!

        /// UtilityPackage: hex #5C6BC0
        public static let indigo400 = Color(hex: 0x5C6BC0)!

        /// UtilityPackage: hex #3F51B5
        public static let indigo500 = Color(hex: 0x3F51B5)!

        /// UtilityPackage: hex #3949AB
        public static let indigo600 = Color(hex: 0x3949AB)!

        /// UtilityPackage: hex #303F9F
        public static let indigo700 = Color(hex: 0x303F9F)!

        /// UtilityPackage: hex #283593
        public static let indigo800 = Color(hex: 0x283593)!

        /// UtilityPackage: hex #1A237E
        public static let indigo900 = Color(hex: 0x1A237E)!

        /// UtilityPackage: hex #8C9EFF
        public static let indigoA100 = Color(hex: 0x8C9EFF)!

        /// UtilityPackage: hex #536DFE
        public static let indigoA200 = Color(hex: 0x536DFE)!

        /// UtilityPackage: hex #3D5AFE
        public static let indigoA400 = Color(hex: 0x3D5AFE)!

        /// UtilityPackage: hex #304FFE
        public static let indigoA700 = Color(hex: 0x304FFE)!

        /// UtilityPackage: color blue500
        public static let blue = blue500

        /// UtilityPackage: hex #E3F2FD
        public static let blue50 = Color(hex: 0xE3F2FD)!

        /// UtilityPackage: hex #BBDEFB
        public static let blue100 = Color(hex: 0xBBDEFB)!

        /// UtilityPackage: hex #90CAF9
        public static let blue200 = Color(hex: 0x90CAF9)!

        /// UtilityPackage: hex #64B5F6
        public static let blue300 = Color(hex: 0x64B5F6)!

        /// UtilityPackage: hex #42A5F5
        public static let blue400 = Color(hex: 0x42A5F5)!

        /// UtilityPackage: hex #2196F3
        public static let blue500 = Color(hex: 0x2196F3)!

        /// UtilityPackage: hex #1E88E5
        public static let blue600 = Color(hex: 0x1E88E5)!

        /// UtilityPackage: hex #1976D2
        public static let blue700 = Color(hex: 0x1976D2)!

        /// UtilityPackage: hex #1565C0
        public static let blue800 = Color(hex: 0x1565C0)!

        /// UtilityPackage: hex #0D47A1
        public static let blue900 = Color(hex: 0x0D47A1)!

        /// UtilityPackage: hex #82B1FF
        public static let blueA100 = Color(hex: 0x82B1FF)!

        /// UtilityPackage: hex #448AFF
        public static let blueA200 = Color(hex: 0x448AFF)!

        /// UtilityPackage: hex #2979FF
        public static let blueA400 = Color(hex: 0x2979FF)!

        /// UtilityPackage: hex #2962FF
        public static let blueA700 = Color(hex: 0x2962FF)!

        /// UtilityPackage: color lightBlue500
        public static let lightBlue = lightBlue500

        /// UtilityPackage: hex #E1F5FE
        public static let lightBlue50 = Color(hex: 0xE1F5FE)!

        /// UtilityPackage: hex #B3E5FC
        public static let lightBlue100 = Color(hex: 0xB3E5FC)!

        /// UtilityPackage: hex #81D4FA
        public static let lightBlue200 = Color(hex: 0x81D4FA)!

        /// UtilityPackage: hex #4FC3F7
        public static let lightBlue300 = Color(hex: 0x4FC3F7)!

        /// UtilityPackage: hex #29B6F6
        public static let lightBlue400 = Color(hex: 0x29B6F6)!

        /// UtilityPackage: hex #03A9F4
        public static let lightBlue500 = Color(hex: 0x03A9F4)!

        /// UtilityPackage: hex #039BE5
        public static let lightBlue600 = Color(hex: 0x039BE5)!

        /// UtilityPackage: hex #0288D1
        public static let lightBlue700 = Color(hex: 0x0288D1)!

        /// UtilityPackage: hex #0277BD
        public static let lightBlue800 = Color(hex: 0x0277BD)!

        /// UtilityPackage: hex #01579B
        public static let lightBlue900 = Color(hex: 0x01579B)!

        /// UtilityPackage: hex #80D8FF
        public static let lightBlueA100 = Color(hex: 0x80D8FF)!

        /// UtilityPackage: hex #40C4FF
        public static let lightBlueA200 = Color(hex: 0x40C4FF)!

        /// UtilityPackage: hex #00B0FF
        public static let lightBlueA400 = Color(hex: 0x00B0FF)!

        /// UtilityPackage: hex #0091EA
        public static let lightBlueA700 = Color(hex: 0x0091EA)!

        /// UtilityPackage: color cyan500
        public static let cyan = cyan500

        /// UtilityPackage: hex #E0F7FA
        public static let cyan50 = Color(hex: 0xE0F7FA)!

        /// UtilityPackage: hex #B2EBF2
        public static let cyan100 = Color(hex: 0xB2EBF2)!

        /// UtilityPackage: hex #80DEEA
        public static let cyan200 = Color(hex: 0x80DEEA)!

        /// UtilityPackage: hex #4DD0E1
        public static let cyan300 = Color(hex: 0x4DD0E1)!

        /// UtilityPackage: hex #26C6DA
        public static let cyan400 = Color(hex: 0x26C6DA)!

        /// UtilityPackage: hex #00BCD4
        public static let cyan500 = Color(hex: 0x00BCD4)!

        /// UtilityPackage: hex #00ACC1
        public static let cyan600 = Color(hex: 0x00ACC1)!

        /// UtilityPackage: hex #0097A7
        public static let cyan700 = Color(hex: 0x0097A7)!

        /// UtilityPackage: hex #00838F
        public static let cyan800 = Color(hex: 0x00838F)!

        /// UtilityPackage: hex #006064
        public static let cyan900 = Color(hex: 0x006064)!

        /// UtilityPackage: hex #84FFFF
        public static let cyanA100 = Color(hex: 0x84FFFF)!

        /// UtilityPackage: hex #18FFFF
        public static let cyanA200 = Color(hex: 0x18FFFF)!

        /// UtilityPackage: hex #00E5FF
        public static let cyanA400 = Color(hex: 0x00E5FF)!

        /// UtilityPackage: hex #00B8D4
        public static let cyanA700 = Color(hex: 0x00B8D4)!

        /// UtilityPackage: color teal500
        public static let teal = teal500

        /// UtilityPackage: hex #E0F2F1
        public static let teal50 = Color(hex: 0xE0F2F1)!

        /// UtilityPackage: hex #B2DFDB
        public static let teal100 = Color(hex: 0xB2DFDB)!

        /// UtilityPackage: hex #80CBC4
        public static let teal200 = Color(hex: 0x80CBC4)!

        /// UtilityPackage: hex #4DB6AC
        public static let teal300 = Color(hex: 0x4DB6AC)!

        /// UtilityPackage: hex #26A69A
        public static let teal400 = Color(hex: 0x26A69A)!

        /// UtilityPackage: hex #009688
        public static let teal500 = Color(hex: 0x009688)!

        /// UtilityPackage: hex #00897B
        public static let teal600 = Color(hex: 0x00897B)!

        /// UtilityPackage: hex #00796B
        public static let teal700 = Color(hex: 0x00796B)!

        /// UtilityPackage: hex #00695C
        public static let teal800 = Color(hex: 0x00695C)!

        /// UtilityPackage: hex #004D40
        public static let teal900 = Color(hex: 0x004D40)!

        /// UtilityPackage: hex #A7FFEB
        public static let tealA100 = Color(hex: 0xA7FFEB)!

        /// UtilityPackage: hex #64FFDA
        public static let tealA200 = Color(hex: 0x64FFDA)!

        /// UtilityPackage: hex #1DE9B6
        public static let tealA400 = Color(hex: 0x1DE9B6)!

        /// UtilityPackage: hex #00BFA5
        public static let tealA700 = Color(hex: 0x00BFA5)!

        /// UtilityPackage: color green500
        public static let green = green500

        /// UtilityPackage: hex #E8F5E9
        public static let green50 = Color(hex: 0xE8F5E9)!

        /// UtilityPackage: hex #C8E6C9
        public static let green100 = Color(hex: 0xC8E6C9)!

        /// UtilityPackage: hex #A5D6A7
        public static let green200 = Color(hex: 0xA5D6A7)!

        /// UtilityPackage: hex #81C784
        public static let green300 = Color(hex: 0x81C784)!

        /// UtilityPackage: hex #66BB6A
        public static let green400 = Color(hex: 0x66BB6A)!

        /// UtilityPackage: hex #4CAF50
        public static let green500 = Color(hex: 0x4CAF50)!

        /// UtilityPackage: hex #43A047
        public static let green600 = Color(hex: 0x43A047)!

        /// UtilityPackage: hex #388E3C
        public static let green700 = Color(hex: 0x388E3C)!

        /// UtilityPackage: hex #2E7D32
        public static let green800 = Color(hex: 0x2E7D32)!

        /// UtilityPackage: hex #1B5E20
        public static let green900 = Color(hex: 0x1B5E20)!

        /// UtilityPackage: hex #B9F6CA
        public static let greenA100 = Color(hex: 0xB9F6CA)!

        /// UtilityPackage: hex #69F0AE
        public static let greenA200 = Color(hex: 0x69F0AE)!

        /// UtilityPackage: hex #00E676
        public static let greenA400 = Color(hex: 0x00E676)!

        /// UtilityPackage: hex #00C853
        public static let greenA700 = Color(hex: 0x00C853)!

        /// UtilityPackage: color lightGreen500
        public static let lightGreen = lightGreen500

        /// UtilityPackage: hex #F1F8E9
        public static let lightGreen50 = Color(hex: 0xF1F8E9)!

        /// UtilityPackage: hex #DCEDC8
        public static let lightGreen100 = Color(hex: 0xDCEDC8)!

        /// UtilityPackage: hex #C5E1A5
        public static let lightGreen200 = Color(hex: 0xC5E1A5)!

        /// UtilityPackage: hex #AED581
        public static let lightGreen300 = Color(hex: 0xAED581)!

        /// UtilityPackage: hex #9CCC65
        public static let lightGreen400 = Color(hex: 0x9CCC65)!

        /// UtilityPackage: hex #8BC34A
        public static let lightGreen500 = Color(hex: 0x8BC34A)!

        /// UtilityPackage: hex #7CB342
        public static let lightGreen600 = Color(hex: 0x7CB342)!

        /// UtilityPackage: hex #689F38
        public static let lightGreen700 = Color(hex: 0x689F38)!

        /// UtilityPackage: hex #558B2F
        public static let lightGreen800 = Color(hex: 0x558B2F)!

        /// UtilityPackage: hex #33691E
        public static let lightGreen900 = Color(hex: 0x33691E)!

        /// UtilityPackage: hex #CCFF90
        public static let lightGreenA100 = Color(hex: 0xCCFF90)!

        /// UtilityPackage: hex #B2FF59
        public static let lightGreenA200 = Color(hex: 0xB2FF59)!

        /// UtilityPackage: hex #76FF03
        public static let lightGreenA400 = Color(hex: 0x76FF03)!

        /// UtilityPackage: hex #64DD17
        public static let lightGreenA700 = Color(hex: 0x64DD17)!

        /// UtilityPackage: color lime500
        public static let lime = lime500

        /// UtilityPackage: hex #F9FBE7
        public static let lime50 = Color(hex: 0xF9FBE7)!

        /// UtilityPackage: hex #F0F4C3
        public static let lime100 = Color(hex: 0xF0F4C3)!

        /// UtilityPackage: hex #E6EE9C
        public static let lime200 = Color(hex: 0xE6EE9C)!

        /// UtilityPackage: hex #DCE775
        public static let lime300 = Color(hex: 0xDCE775)!

        /// UtilityPackage: hex #D4E157
        public static let lime400 = Color(hex: 0xD4E157)!

        /// UtilityPackage: hex #CDDC39
        public static let lime500 = Color(hex: 0xCDDC39)!

        /// UtilityPackage: hex #C0CA33
        public static let lime600 = Color(hex: 0xC0CA33)!

        /// UtilityPackage: hex #AFB42B
        public static let lime700 = Color(hex: 0xAFB42B)!

        /// UtilityPackage: hex #9E9D24
        public static let lime800 = Color(hex: 0x9E9D24)!

        /// UtilityPackage: hex #827717
        public static let lime900 = Color(hex: 0x827717)!

        /// UtilityPackage: hex #F4FF81
        public static let limeA100 = Color(hex: 0xF4FF81)!

        /// UtilityPackage: hex #EEFF41
        public static let limeA200 = Color(hex: 0xEEFF41)!

        /// UtilityPackage: hex #C6FF00
        public static let limeA400 = Color(hex: 0xC6FF00)!

        /// UtilityPackage: hex #AEEA00
        public static let limeA700 = Color(hex: 0xAEEA00)!

        /// UtilityPackage: color yellow500
        public static let yellow = yellow500

        /// UtilityPackage: hex #FFFDE7
        public static let yellow50 = Color(hex: 0xFFFDE7)!

        /// UtilityPackage: hex #FFF9C4
        public static let yellow100 = Color(hex: 0xFFF9C4)!

        /// UtilityPackage: hex #FFF59D
        public static let yellow200 = Color(hex: 0xFFF59D)!

        /// UtilityPackage: hex #FFF176
        public static let yellow300 = Color(hex: 0xFFF176)!

        /// UtilityPackage: hex #FFEE58
        public static let yellow400 = Color(hex: 0xFFEE58)!

        /// UtilityPackage: hex #FFEB3B
        public static let yellow500 = Color(hex: 0xFFEB3B)!

        /// UtilityPackage: hex #FDD835
        public static let yellow600 = Color(hex: 0xFDD835)!

        /// UtilityPackage: hex #FBC02D
        public static let yellow700 = Color(hex: 0xFBC02D)!

        /// UtilityPackage: hex #F9A825
        public static let yellow800 = Color(hex: 0xF9A825)!

        /// UtilityPackage: hex #F57F17
        public static let yellow900 = Color(hex: 0xF57F17)!

        /// UtilityPackage: hex #FFFF8D
        public static let yellowA100 = Color(hex: 0xFFFF8D)!

        /// UtilityPackage: hex #FFFF00
        public static let yellowA200 = Color(hex: 0xFFFF00)!

        /// UtilityPackage: hex #FFEA00
        public static let yellowA400 = Color(hex: 0xFFEA00)!

        /// UtilityPackage: hex #FFD600
        public static let yellowA700 = Color(hex: 0xFFD600)!

        /// UtilityPackage: color amber500
        public static let amber = amber500

        /// UtilityPackage: hex #FFF8E1
        public static let amber50 = Color(hex: 0xFFF8E1)!

        /// UtilityPackage: hex #FFECB3
        public static let amber100 = Color(hex: 0xFFECB3)!

        /// UtilityPackage: hex #FFE082
        public static let amber200 = Color(hex: 0xFFE082)!

        /// UtilityPackage: hex #FFD54F
        public static let amber300 = Color(hex: 0xFFD54F)!

        /// UtilityPackage: hex #FFCA28
        public static let amber400 = Color(hex: 0xFFCA28)!

        /// UtilityPackage: hex #FFC107
        public static let amber500 = Color(hex: 0xFFC107)!

        /// UtilityPackage: hex #FFB300
        public static let amber600 = Color(hex: 0xFFB300)!

        /// UtilityPackage: hex #FFA000
        public static let amber700 = Color(hex: 0xFFA000)!

        /// UtilityPackage: hex #FF8F00
        public static let amber800 = Color(hex: 0xFF8F00)!

        /// UtilityPackage: hex #FF6F00
        public static let amber900 = Color(hex: 0xFF6F00)!

        /// UtilityPackage: hex #FFE57F
        public static let amberA100 = Color(hex: 0xFFE57F)!

        /// UtilityPackage: hex #FFD740
        public static let amberA200 = Color(hex: 0xFFD740)!

        /// UtilityPackage: hex #FFC400
        public static let amberA400 = Color(hex: 0xFFC400)!

        /// UtilityPackage: hex #FFAB00
        public static let amberA700 = Color(hex: 0xFFAB00)!

        /// UtilityPackage: color orange500
        public static let orange = orange500

        /// UtilityPackage: hex #FFF3E0
        public static let orange50 = Color(hex: 0xFFF3E0)!

        /// UtilityPackage: hex #FFE0B2
        public static let orange100 = Color(hex: 0xFFE0B2)!

        /// UtilityPackage: hex #FFCC80
        public static let orange200 = Color(hex: 0xFFCC80)!

        /// UtilityPackage: hex #FFB74D
        public static let orange300 = Color(hex: 0xFFB74D)!

        /// UtilityPackage: hex #FFA726
        public static let orange400 = Color(hex: 0xFFA726)!

        /// UtilityPackage: hex #FF9800
        public static let orange500 = Color(hex: 0xFF9800)!

        /// UtilityPackage: hex #FB8C00
        public static let orange600 = Color(hex: 0xFB8C00)!

        /// UtilityPackage: hex #F57C00
        public static let orange700 = Color(hex: 0xF57C00)!

        /// UtilityPackage: hex #EF6C00
        public static let orange800 = Color(hex: 0xEF6C00)!

        /// UtilityPackage: hex #E65100
        public static let orange900 = Color(hex: 0xE65100)!

        /// UtilityPackage: hex #FFD180
        public static let orangeA100 = Color(hex: 0xFFD180)!

        /// UtilityPackage: hex #FFAB40
        public static let orangeA200 = Color(hex: 0xFFAB40)!

        /// UtilityPackage: hex #FF9100
        public static let orangeA400 = Color(hex: 0xFF9100)!

        /// UtilityPackage: hex #FF6D00
        public static let orangeA700 = Color(hex: 0xFF6D00)!

        /// UtilityPackage: color deepOrange500
        public static let deepOrange = deepOrange500

        /// UtilityPackage: hex #FBE9E7
        public static let deepOrange50 = Color(hex: 0xFBE9E7)!

        /// UtilityPackage: hex #FFCCBC
        public static let deepOrange100 = Color(hex: 0xFFCCBC)!

        /// UtilityPackage: hex #FFAB91
        public static let deepOrange200 = Color(hex: 0xFFAB91)!

        /// UtilityPackage: hex #FF8A65
        public static let deepOrange300 = Color(hex: 0xFF8A65)!

        /// UtilityPackage: hex #FF7043
        public static let deepOrange400 = Color(hex: 0xFF7043)!

        /// UtilityPackage: hex #FF5722
        public static let deepOrange500 = Color(hex: 0xFF5722)!

        /// UtilityPackage: hex #F4511E
        public static let deepOrange600 = Color(hex: 0xF4511E)!

        /// UtilityPackage: hex #E64A19
        public static let deepOrange700 = Color(hex: 0xE64A19)!

        /// UtilityPackage: hex #D84315
        public static let deepOrange800 = Color(hex: 0xD84315)!

        /// UtilityPackage: hex #BF360C
        public static let deepOrange900 = Color(hex: 0xBF360C)!

        /// UtilityPackage: hex #FF9E80
        public static let deepOrangeA100 = Color(hex: 0xFF9E80)!

        /// UtilityPackage: hex #FF6E40
        public static let deepOrangeA200 = Color(hex: 0xFF6E40)!

        /// UtilityPackage: hex #FF3D00
        public static let deepOrangeA400 = Color(hex: 0xFF3D00)!

        /// UtilityPackage: hex #DD2C00
        public static let deepOrangeA700 = Color(hex: 0xDD2C00)!

        /// UtilityPackage: color brown500
        public static let brown = brown500

        /// UtilityPackage: hex #EFEBE9
        public static let brown50 = Color(hex: 0xEFEBE9)!

        /// UtilityPackage: hex #D7CCC8
        public static let brown100 = Color(hex: 0xD7CCC8)!

        /// UtilityPackage: hex #BCAAA4
        public static let brown200 = Color(hex: 0xBCAAA4)!

        /// UtilityPackage: hex #A1887F
        public static let brown300 = Color(hex: 0xA1887F)!

        /// UtilityPackage: hex #8D6E63
        public static let brown400 = Color(hex: 0x8D6E63)!

        /// UtilityPackage: hex #795548
        public static let brown500 = Color(hex: 0x795548)!

        /// UtilityPackage: hex #6D4C41
        public static let brown600 = Color(hex: 0x6D4C41)!

        /// UtilityPackage: hex #5D4037
        public static let brown700 = Color(hex: 0x5D4037)!

        /// UtilityPackage: hex #4E342E
        public static let brown800 = Color(hex: 0x4E342E)!

        /// UtilityPackage: hex #3E2723
        public static let brown900 = Color(hex: 0x3E2723)!

        /// UtilityPackage: color grey500
        public static let grey = grey500

        /// UtilityPackage: hex #FAFAFA
        public static let grey50 = Color(hex: 0xFAFAFA)!

        /// UtilityPackage: hex #F5F5F5
        public static let grey100 = Color(hex: 0xF5F5F5)!

        /// UtilityPackage: hex #EEEEEE
        public static let grey200 = Color(hex: 0xEEEEEE)!

        /// UtilityPackage: hex #E0E0E0
        public static let grey300 = Color(hex: 0xE0E0E0)!

        /// UtilityPackage: hex #BDBDBD
        public static let grey400 = Color(hex: 0xBDBDBD)!

        /// UtilityPackage: hex #9E9E9E
        public static let grey500 = Color(hex: 0x9E9E9E)!

        /// UtilityPackage: hex #757575
        public static let grey600 = Color(hex: 0x757575)!

        /// UtilityPackage: hex #616161
        public static let grey700 = Color(hex: 0x616161)!

        /// UtilityPackage: hex #424242
        public static let grey800 = Color(hex: 0x424242)!

        /// UtilityPackage: hex #212121
        public static let grey900 = Color(hex: 0x212121)!

        /// UtilityPackage: color blueGrey500
        public static let blueGrey = blueGrey500

        /// UtilityPackage: hex #ECEFF1
        public static let blueGrey50 = Color(hex: 0xECEFF1)!

        /// UtilityPackage: hex #CFD8DC
        public static let blueGrey100 = Color(hex: 0xCFD8DC)!

        /// UtilityPackage: hex #B0BEC5
        public static let blueGrey200 = Color(hex: 0xB0BEC5)!

        /// UtilityPackage: hex #90A4AE
        public static let blueGrey300 = Color(hex: 0x90A4AE)!

        /// UtilityPackage: hex #78909C
        public static let blueGrey400 = Color(hex: 0x78909C)!

        /// UtilityPackage: hex #607D8B
        public static let blueGrey500 = Color(hex: 0x607D8B)!

        /// UtilityPackage: hex #546E7A
        public static let blueGrey600 = Color(hex: 0x546E7A)!

        /// UtilityPackage: hex #455A64
        public static let blueGrey700 = Color(hex: 0x455A64)!

        /// UtilityPackage: hex #37474F
        public static let blueGrey800 = Color(hex: 0x37474F)!

        /// UtilityPackage: hex #263238
        public static let blueGrey900 = Color(hex: 0x263238)!

        /// UtilityPackage: hex #000000
        public static let black = Color(hex: 0x000000)!

        /// UtilityPackage: hex #FFFFFF
        public static let white = Color(hex: 0xFFFFFF)!
    }
}

// MARK: - CSS colors
public extension Color {
    /// UtilityPackage: CSS colors.
    enum CSS {
        // http://www.w3schools.com/colors/colors_names.asp
        /// UtilityPackage: hex #F0F8FF
        public static let aliceBlue = Color(hex: 0xF0F8FF)!

        /// UtilityPackage: hex #FAEBD7
        public static let antiqueWhite = Color(hex: 0xFAEBD7)!

        /// UtilityPackage: hex #00FFFF
        public static let aqua = Color(hex: 0x00FFFF)!

        /// UtilityPackage: hex #7FFFD4
        public static let aquamarine = Color(hex: 0x7FFFD4)!

        /// UtilityPackage: hex #F0FFFF
        public static let azure = Color(hex: 0xF0FFFF)!

        /// UtilityPackage: hex #F5F5DC
        public static let beige = Color(hex: 0xF5F5DC)!

        /// UtilityPackage: hex #FFE4C4
        public static let bisque = Color(hex: 0xFFE4C4)!

        /// UtilityPackage: hex #000000
        public static let black = Color(hex: 0x000000)!

        /// UtilityPackage: hex #FFEBCD
        public static let blanchedAlmond = Color(hex: 0xFFEBCD)!

        /// UtilityPackage: hex #0000FF
        public static let blue = Color(hex: 0x0000FF)!

        /// UtilityPackage: hex #8A2BE2
        public static let blueViolet = Color(hex: 0x8A2BE2)!

        /// UtilityPackage: hex #A52A2A
        public static let brown = Color(hex: 0xA52A2A)!

        /// UtilityPackage: hex #DEB887
        public static let burlyWood = Color(hex: 0xDEB887)!

        /// UtilityPackage: hex #5F9EA0
        public static let cadetBlue = Color(hex: 0x5F9EA0)!

        /// UtilityPackage: hex #7FFF00
        public static let chartreuse = Color(hex: 0x7FFF00)!

        /// UtilityPackage: hex #D2691E
        public static let chocolate = Color(hex: 0xD2691E)!

        /// UtilityPackage: hex #FF7F50
        public static let coral = Color(hex: 0xFF7F50)!

        /// UtilityPackage: hex #6495ED
        public static let cornflowerBlue = Color(hex: 0x6495ED)!

        /// UtilityPackage: hex #FFF8DC
        public static let cornsilk = Color(hex: 0xFFF8DC)!

        /// UtilityPackage: hex #DC143C
        public static let crimson = Color(hex: 0xDC143C)!

        /// UtilityPackage: hex #00FFFF
        public static let cyan = Color(hex: 0x00FFFF)!

        /// UtilityPackage: hex #00008B
        public static let darkBlue = Color(hex: 0x00008B)!

        /// UtilityPackage: hex #008B8B
        public static let darkCyan = Color(hex: 0x008B8B)!

        /// UtilityPackage: hex #B8860B
        public static let darkGoldenRod = Color(hex: 0xB8860B)!

        /// UtilityPackage: hex #A9A9A9
        public static let darkGray = Color(hex: 0xA9A9A9)!

        /// UtilityPackage: hex #A9A9A9
        public static let darkGrey = Color(hex: 0xA9A9A9)!

        /// UtilityPackage: hex #006400
        public static let darkGreen = Color(hex: 0x006400)!

        /// UtilityPackage: hex #BDB76B
        public static let darkKhaki = Color(hex: 0xBDB76B)!

        /// UtilityPackage: hex #8B008B
        public static let darkMagenta = Color(hex: 0x8B008B)!

        /// UtilityPackage: hex #556B2F
        public static let darkOliveGreen = Color(hex: 0x556B2F)!

        /// UtilityPackage: hex #FF8C00
        public static let darkOrange = Color(hex: 0xFF8C00)!

        /// UtilityPackage: hex #9932CC
        public static let darkOrchid = Color(hex: 0x9932CC)!

        /// UtilityPackage: hex #8B0000
        public static let darkRed = Color(hex: 0x8B0000)!

        /// UtilityPackage: hex #E9967A
        public static let darkSalmon = Color(hex: 0xE9967A)!

        /// UtilityPackage: hex #8FBC8F
        public static let darkSeaGreen = Color(hex: 0x8FBC8F)!

        /// UtilityPackage: hex #483D8B
        public static let darkSlateBlue = Color(hex: 0x483D8B)!

        /// UtilityPackage: hex #2F4F4F
        public static let darkSlateGray = Color(hex: 0x2F4F4F)!

        /// UtilityPackage: hex #2F4F4F
        public static let darkSlateGrey = Color(hex: 0x2F4F4F)!

        /// UtilityPackage: hex #00CED1
        public static let darkTurquoise = Color(hex: 0x00CED1)!

        /// UtilityPackage: hex #9400D3
        public static let darkViolet = Color(hex: 0x9400D3)!

        /// UtilityPackage: hex #FF1493
        public static let deepPink = Color(hex: 0xFF1493)!

        /// UtilityPackage: hex #00BFFF
        public static let deepSkyBlue = Color(hex: 0x00BFFF)!

        /// UtilityPackage: hex #696969
        public static let dimGray = Color(hex: 0x696969)!

        /// UtilityPackage: hex #696969
        public static let dimGrey = Color(hex: 0x696969)!

        /// UtilityPackage: hex #1E90FF
        public static let dodgerBlue = Color(hex: 0x1E90FF)!

        /// UtilityPackage: hex #B22222
        public static let fireBrick = Color(hex: 0xB22222)!

        /// UtilityPackage: hex #FFFAF0
        public static let floralWhite = Color(hex: 0xFFFAF0)!

        /// UtilityPackage: hex #228B22
        public static let forestGreen = Color(hex: 0x228B22)!

        /// UtilityPackage: hex #FF00FF
        public static let fuchsia = Color(hex: 0xFF00FF)!

        /// UtilityPackage: hex #DCDCDC
        public static let gainsboro = Color(hex: 0xDCDCDC)!

        /// UtilityPackage: hex #F8F8FF
        public static let ghostWhite = Color(hex: 0xF8F8FF)!

        /// UtilityPackage: hex #FFD700
        public static let gold = Color(hex: 0xFFD700)!

        /// UtilityPackage: hex #DAA520
        public static let goldenRod = Color(hex: 0xDAA520)!

        /// UtilityPackage: hex #808080
        public static let gray = Color(hex: 0x808080)!

        /// UtilityPackage: hex #808080
        public static let grey = Color(hex: 0x808080)!

        /// UtilityPackage: hex #008000
        public static let green = Color(hex: 0x008000)!

        /// UtilityPackage: hex #ADFF2F
        public static let greenYellow = Color(hex: 0xADFF2F)!

        /// UtilityPackage: hex #F0FFF0
        public static let honeyDew = Color(hex: 0xF0FFF0)!

        /// UtilityPackage: hex #FF69B4
        public static let hotPink = Color(hex: 0xFF69B4)!

        /// UtilityPackage: hex #CD5C5C
        public static let indianRed = Color(hex: 0xCD5C5C)!

        /// UtilityPackage: hex #4B0082
        public static let indigo = Color(hex: 0x4B0082)!

        /// UtilityPackage: hex #FFFFF0
        public static let ivory = Color(hex: 0xFFFFF0)!

        /// UtilityPackage: hex #F0E68C
        public static let khaki = Color(hex: 0xF0E68C)!

        /// UtilityPackage: hex #E6E6FA
        public static let lavender = Color(hex: 0xE6E6FA)!

        /// UtilityPackage: hex #FFF0F5
        public static let lavenderBlush = Color(hex: 0xFFF0F5)!

        /// UtilityPackage: hex #7CFC00
        public static let lawnGreen = Color(hex: 0x7CFC00)!

        /// UtilityPackage: hex #FFFACD
        public static let lemonChiffon = Color(hex: 0xFFFACD)!

        /// UtilityPackage: hex #ADD8E6
        public static let lightBlue = Color(hex: 0xADD8E6)!

        /// UtilityPackage: hex #F08080
        public static let lightCoral = Color(hex: 0xF08080)!

        /// UtilityPackage: hex #E0FFFF
        public static let lightCyan = Color(hex: 0xE0FFFF)!

        /// UtilityPackage: hex #FAFAD2
        public static let lightGoldenRodYellow = Color(hex: 0xFAFAD2)!

        /// UtilityPackage: hex #D3D3D3
        public static let lightGray = Color(hex: 0xD3D3D3)!

        /// UtilityPackage: hex #D3D3D3
        public static let lightGrey = Color(hex: 0xD3D3D3)!

        /// UtilityPackage: hex #90EE90
        public static let lightGreen = Color(hex: 0x90EE90)!

        /// UtilityPackage: hex #FFB6C1
        public static let lightPink = Color(hex: 0xFFB6C1)!

        /// UtilityPackage: hex #FFA07A
        public static let lightSalmon = Color(hex: 0xFFA07A)!

        /// UtilityPackage: hex #20B2AA
        public static let lightSeaGreen = Color(hex: 0x20B2AA)!

        /// UtilityPackage: hex #87CEFA
        public static let lightSkyBlue = Color(hex: 0x87CEFA)!

        /// UtilityPackage: hex #778899
        public static let lightSlateGray = Color(hex: 0x778899)!

        /// UtilityPackage: hex #778899
        public static let lightSlateGrey = Color(hex: 0x778899)!

        /// UtilityPackage: hex #B0C4DE
        public static let lightSteelBlue = Color(hex: 0xB0C4DE)!

        /// UtilityPackage: hex #FFFFE0
        public static let lightYellow = Color(hex: 0xFFFFE0)!

        /// UtilityPackage: hex #00FF00
        public static let lime = Color(hex: 0x00FF00)!

        /// UtilityPackage: hex #32CD32
        public static let limeGreen = Color(hex: 0x32CD32)!

        /// UtilityPackage: hex #FAF0E6
        public static let linen = Color(hex: 0xFAF0E6)!

        /// UtilityPackage: hex #FF00FF
        public static let magenta = Color(hex: 0xFF00FF)!

        /// UtilityPackage: hex #800000
        public static let maroon = Color(hex: 0x800000)!

        /// UtilityPackage: hex #66CDAA
        public static let mediumAquaMarine = Color(hex: 0x66CDAA)!

        /// UtilityPackage: hex #0000CD
        public static let mediumBlue = Color(hex: 0x0000CD)!

        /// UtilityPackage: hex #BA55D3
        public static let mediumOrchid = Color(hex: 0xBA55D3)!

        /// UtilityPackage: hex #9370DB
        public static let mediumPurple = Color(hex: 0x9370DB)!

        /// UtilityPackage: hex #3CB371
        public static let mediumSeaGreen = Color(hex: 0x3CB371)!

        /// UtilityPackage: hex #7B68EE
        public static let mediumSlateBlue = Color(hex: 0x7B68EE)!

        /// UtilityPackage: hex #00FA9A
        public static let mediumSpringGreen = Color(hex: 0x00FA9A)!

        /// UtilityPackage: hex #48D1CC
        public static let mediumTurquoise = Color(hex: 0x48D1CC)!

        /// UtilityPackage: hex #C71585
        public static let mediumVioletRed = Color(hex: 0xC71585)!

        /// UtilityPackage: hex #191970
        public static let midnightBlue = Color(hex: 0x191970)!

        /// UtilityPackage: hex #F5FFFA
        public static let mintCream = Color(hex: 0xF5FFFA)!

        /// UtilityPackage: hex #FFE4E1
        public static let mistyRose = Color(hex: 0xFFE4E1)!

        /// UtilityPackage: hex #FFE4B5
        public static let moccasin = Color(hex: 0xFFE4B5)!

        /// UtilityPackage: hex #FFDEAD
        public static let navajoWhite = Color(hex: 0xFFDEAD)!

        /// UtilityPackage: hex #000080
        public static let navy = Color(hex: 0x000080)!

        /// UtilityPackage: hex #FDF5E6
        public static let oldLace = Color(hex: 0xFDF5E6)!

        /// UtilityPackage: hex #808000
        public static let olive = Color(hex: 0x808000)!

        /// UtilityPackage: hex #6B8E23
        public static let oliveDrab = Color(hex: 0x6B8E23)!

        /// UtilityPackage: hex #FFA500
        public static let orange = Color(hex: 0xFFA500)!

        /// UtilityPackage: hex #FF4500
        public static let orangeRed = Color(hex: 0xFF4500)!

        /// UtilityPackage: hex #DA70D6
        public static let orchid = Color(hex: 0xDA70D6)!

        /// UtilityPackage: hex #EEE8AA
        public static let paleGoldenRod = Color(hex: 0xEEE8AA)!

        /// UtilityPackage: hex #98FB98
        public static let paleGreen = Color(hex: 0x98FB98)!

        /// UtilityPackage: hex #AFEEEE
        public static let paleTurquoise = Color(hex: 0xAFEEEE)!

        /// UtilityPackage: hex #DB7093
        public static let paleVioletRed = Color(hex: 0xDB7093)!

        /// UtilityPackage: hex #FFEFD5
        public static let papayaWhip = Color(hex: 0xFFEFD5)!

        /// UtilityPackage: hex #FFDAB9
        public static let peachPuff = Color(hex: 0xFFDAB9)!

        /// UtilityPackage: hex #CD853F
        public static let peru = Color(hex: 0xCD853F)!

        /// UtilityPackage: hex #FFC0CB
        public static let pink = Color(hex: 0xFFC0CB)!

        /// UtilityPackage: hex #DDA0DD
        public static let plum = Color(hex: 0xDDA0DD)!

        /// UtilityPackage: hex #B0E0E6
        public static let powderBlue = Color(hex: 0xB0E0E6)!

        /// UtilityPackage: hex #800080
        public static let purple = Color(hex: 0x800080)!

        /// UtilityPackage: hex #663399
        public static let rebeccaPurple = Color(hex: 0x663399)!

        /// UtilityPackage: hex #FF0000
        public static let red = Color(hex: 0xFF0000)!

        /// UtilityPackage: hex #BC8F8F
        public static let rosyBrown = Color(hex: 0xBC8F8F)!

        /// UtilityPackage: hex #4169E1
        public static let royalBlue = Color(hex: 0x4169E1)!

        /// UtilityPackage: hex #8B4513
        public static let saddleBrown = Color(hex: 0x8B4513)!

        /// UtilityPackage: hex #FA8072
        public static let salmon = Color(hex: 0xFA8072)!

        /// UtilityPackage: hex #F4A460
        public static let sandyBrown = Color(hex: 0xF4A460)!

        /// UtilityPackage: hex #2E8B57
        public static let seaGreen = Color(hex: 0x2E8B57)!

        /// UtilityPackage: hex #FFF5EE
        public static let seaShell = Color(hex: 0xFFF5EE)!

        /// UtilityPackage: hex #A0522D
        public static let sienna = Color(hex: 0xA0522D)!

        /// UtilityPackage: hex #C0C0C0
        public static let silver = Color(hex: 0xC0C0C0)!

        /// UtilityPackage: hex #87CEEB
        public static let skyBlue = Color(hex: 0x87CEEB)!

        /// UtilityPackage: hex #6A5ACD
        public static let slateBlue = Color(hex: 0x6A5ACD)!

        /// UtilityPackage: hex #708090
        public static let slateGray = Color(hex: 0x708090)!

        /// UtilityPackage: hex #708090
        public static let slateGrey = Color(hex: 0x708090)!

        /// UtilityPackage: hex #FFFAFA
        public static let snow = Color(hex: 0xFFFAFA)!

        /// UtilityPackage: hex #00FF7F
        public static let springGreen = Color(hex: 0x00FF7F)!

        /// UtilityPackage: hex #4682B4
        public static let steelBlue = Color(hex: 0x4682B4)!

        /// UtilityPackage: hex #D2B48C
        public static let tan = Color(hex: 0xD2B48C)!

        /// UtilityPackage: hex #008080
        public static let teal = Color(hex: 0x008080)!

        /// UtilityPackage: hex #D8BFD8
        public static let thistle = Color(hex: 0xD8BFD8)!

        /// UtilityPackage: hex #FF6347
        public static let tomato = Color(hex: 0xFF6347)!

        /// UtilityPackage: hex #40E0D0
        public static let turquoise = Color(hex: 0x40E0D0)!

        /// UtilityPackage: hex #EE82EE
        public static let violet = Color(hex: 0xEE82EE)!

        /// UtilityPackage: hex #F5DEB3
        public static let wheat = Color(hex: 0xF5DEB3)!

        /// UtilityPackage: hex #FFFFFF
        public static let white = Color(hex: 0xFFFFFF)!

        /// UtilityPackage: hex #F5F5F5
        public static let whiteSmoke = Color(hex: 0xF5F5F5)!

        /// UtilityPackage: hex #FFFF00
        public static let yellow = Color(hex: 0xFFFF00)!

        /// UtilityPackage: hex #9ACD32
        public static let yellowGreen = Color(hex: 0x9ACD32)!
    }
}

// MARK: - Flat UI colors
public extension Color {
    /// UtilityPackage: Flat UI colors
    enum FlatUI {
        // http://flatuicolors.com.
        /// UtilityPackage: hex #1ABC9C
        public static let turquoise = Color(hex: 0x1ABC9C)!

        /// UtilityPackage: hex #16A085
        public static let greenSea = Color(hex: 0x16A085)!

        /// UtilityPackage: hex #2ECC71
        public static let emerald = Color(hex: 0x2ECC71)!

        /// UtilityPackage: hex #27AE60
        public static let nephritis = Color(hex: 0x27AE60)!

        /// UtilityPackage: hex #3498DB
        public static let peterRiver = Color(hex: 0x3498DB)!

        /// UtilityPackage: hex #2980B9
        public static let belizeHole = Color(hex: 0x2980B9)!

        /// UtilityPackage: hex #9B59B6
        public static let amethyst = Color(hex: 0x9B59B6)!

        /// UtilityPackage: hex #8E44AD
        public static let wisteria = Color(hex: 0x8E44AD)!

        /// UtilityPackage: hex #34495E
        public static let wetAsphalt = Color(hex: 0x34495E)!

        /// UtilityPackage: hex #2C3E50
        public static let midnightBlue = Color(hex: 0x2C3E50)!

        /// UtilityPackage: hex #F1C40F
        public static let sunFlower = Color(hex: 0xF1C40F)!

        /// UtilityPackage: hex #F39C12
        public static let flatOrange = Color(hex: 0xF39C12)!

        /// UtilityPackage: hex #E67E22
        public static let carrot = Color(hex: 0xE67E22)!

        /// UtilityPackage: hex #D35400
        public static let pumkin = Color(hex: 0xD35400)!

        /// UtilityPackage: hex #E74C3C
        public static let alizarin = Color(hex: 0xE74C3C)!

        /// UtilityPackage: hex #C0392B
        public static let pomegranate = Color(hex: 0xC0392B)!

        /// UtilityPackage: hex #ECF0F1
        public static let clouds = Color(hex: 0xECF0F1)!

        /// UtilityPackage: hex #BDC3C7
        public static let silver = Color(hex: 0xBDC3C7)!

        /// UtilityPackage: hex #7F8C8D
        public static let asbestos = Color(hex: 0x7F8C8D)!

        /// UtilityPackage: hex #95A5A6
        public static let concerte = Color(hex: 0x95A5A6)!
    }

    // swiftlint:enable type_body_length
}
#endif
