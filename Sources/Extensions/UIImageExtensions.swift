//
//  UIImageExtensions.swift
//  UtilityPackage
//
//  Created by Irshad Ahmad on 05/04/22.
//


#if canImport(UIKit)
import UIKit

// MARK: - Properties
public extension UIImage {
    /// UtilityPackage: Size in bytes of UIImage.
    var bytesSize: Int {
        return jpegData(compressionQuality: 1)?.count ?? 0
    }

    /// UtilityPackage: Size in kilo bytes of UIImage.
    var kilobytesSize: Int {
        return (jpegData(compressionQuality: 1)?.count ?? 0) / 1024
    }

    /// UtilityPackage: UIImage with .alwaysOriginal rendering mode.
    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }

    /// UtilityPackage: UIImage with .alwaysTemplate rendering mode.
    var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }

    #if canImport(CoreImage)
    /// UtilityPackage: Average color for this image.
    func averageColor() -> UIColor? {
        // https://stackoverflow.com/questions/26330924
        guard let ciImage = ciImage ?? CIImage(image: self) else { return nil }

        // CIAreaAverage returns a single-pixel image that contains the average color for a given region of an image.
        let parameters = [kCIInputImageKey: ciImage, kCIInputExtentKey: CIVector(cgRect: ciImage.extent)]
        guard let outputImage = CIFilter(name: "CIAreaAverage", parameters: parameters)?.outputImage else {
            return nil
        }

        // After getting the single-pixel image from the filter extract pixel's RGBA8 data
        var bitmap = [UInt8](repeating: 0, count: 4)
        let workingColorSpace: Any = cgImage?.colorSpace ?? NSNull()
        let context = CIContext(options: [.workingColorSpace: workingColorSpace])
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        // Convert pixel data to UIColor
        return UIColor(red: CGFloat(bitmap[0]) / 255.0,
                       green: CGFloat(bitmap[1]) / 255.0,
                       blue: CGFloat(bitmap[2]) / 255.0,
                       alpha: CGFloat(bitmap[3]) / 255.0)
    }
    #endif
}

// MARK: - Methods
public extension UIImage {
    /// UtilityPackage: Compressed UIImage from original UIImage.
    func compressed(quality: CGFloat = 0.5) -> UIImage? {
        guard let data = jpegData(compressionQuality: quality) else { return nil }
        return UIImage(data: data)
    }

    /// UtilityPackage: Compressed UIImage data from original UIImage.
    func compressedData(quality: CGFloat = 0.5) -> Data? {
        return jpegData(compressionQuality: quality)
    }

    /// UtilityPackage: UIImage Cropped to CGRect.
    ///
    /// - Parameter rect: CGRect to crop UIImage to.
    /// - Returns: cropped UIImage
    func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.width <= size.width, rect.size.height <= size.height else { return self }
        let scaledRect = rect.applying(CGAffineTransform(scaleX: scale, y: scale))
        guard let image = cgImage?.cropping(to: scaledRect) else { return self }
        return UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
    }

    /// UtilityPackage: UIImage scaled to height with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toHeight: new height.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toHeight / size.height
        let newWidth = size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, self.scale)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// UtilityPackage: UIImage scaled to width with respect to aspect ratio.
    func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, self.scale)
        draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// UtilityPackage: Creates a copy of the receiver rotated by the given angle.
    @available(tvOS 10.0, watchOS 3.0, *)
    func rotated(by angle: Measurement<UnitAngle>) -> UIImage? {
        let radians = CGFloat(angle.converted(to: .radians).value)

        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())

        UIGraphicsBeginImageContextWithOptions(roundedDestRect.size, false, scale)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }

        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)

        draw(in: CGRect(origin: CGPoint(x: -size.width / 2,
                                        y: -size.height / 2),
                        size: size))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// UtilityPackage: Creates a copy of the receiver rotated by the given angle (in radians).
    ///
    ///     // Rotate the image by 180°
    ///     image.rotated(by: .pi)
    ///
    /// - Parameter radians: The angle, in radians, by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    func rotated(by radians: CGFloat) -> UIImage? {
        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())

        UIGraphicsBeginImageContextWithOptions(roundedDestRect.size, false, scale)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }

        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)

        draw(in: CGRect(origin: CGPoint(x: -size.width / 2,
                                        y: -size.height / 2),
                        size: size))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// UtilityPackage: UIImage filled with color
    func filled(withColor color: UIColor) -> UIImage {
        #if !os(watchOS)
        if #available(tvOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.scale = scale
            let renderer = UIGraphicsImageRenderer(size: size, format: format)
            return renderer.image { context in
                color.setFill()
                context.fill(CGRect(origin: .zero, size: size))
            }
        }
        #endif

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return self }

        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = cgImage else { return self }
        context.clip(to: rect, mask: mask)
        context.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    /// UtilityPackage: UIImage tinted with color.
    func tint(_ color: UIColor, blendMode: CGBlendMode, alpha: CGFloat = 1.0) -> UIImage {
        let drawRect = CGRect(origin: .zero, size: size)

        #if !os(watchOS)
        if #available(tvOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.scale = scale
            return UIGraphicsImageRenderer(size: size, format: format).image { context in
                color.setFill()
                context.fill(drawRect)
                draw(in: drawRect, blendMode: blendMode, alpha: alpha)
            }
        }
        #endif

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        context?.fill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: alpha)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    /// UtilityPackage: UImage with background color.
    func withBackgroundColor(_ backgroundColor: UIColor) -> UIImage {
        #if !os(watchOS)
        if #available(tvOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.scale = scale
            return UIGraphicsImageRenderer(size: size, format: format).image { context in
                backgroundColor.setFill()
                context.fill(context.format.bounds)
                draw(at: .zero)
            }
        }
        #endif

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }

        backgroundColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        draw(at: .zero)

        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    /// UtilityPackage: UIImage with rounded corners.
    ///
    /// - Parameters:
    ///   - radius: corner radius (optional), resulting image will be round if unspecified.
    /// - Returns: UIImage with all corners rounded.
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0, radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)

        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// UtilityPackage: Base 64 encoded PNG data of the image.
    func pngBase64String() -> String? {
        return pngData()?.base64EncodedString()
    }

    /// UtilityPackage: Base 64 encoded JPEG data of the image.
    func jpegBase64String(compressionQuality: CGFloat) -> String? {
        return jpegData(compressionQuality: compressionQuality)?.base64EncodedString()
    }

    /// UtilityPackage: UIImage with color uses .alwaysOriginal rendering mode.
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func withAlwaysOriginalTintColor(_ color: UIColor) -> UIImage {
        return withTintColor(color, renderingMode: .alwaysOriginal)
    }
}

// MARK: - Initializers
public extension UIImage {
    /// UtilityPackage: Create UIImage from color and size.
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)

        defer {
            UIGraphicsEndImageContext()
        }

        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }

        self.init(cgImage: aCgImage)
    }

    convenience init?(base64String: String, scale: CGFloat = 1.0) {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        self.init(data: data, scale: scale)
    }

    convenience init?(url: URL, scale: CGFloat = 1.0) throws {
        let data = try Data(contentsOf: url)
        self.init(data: data, scale: scale)
    }
}

#endif
