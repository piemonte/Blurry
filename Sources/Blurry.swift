//
//  Blurry.swift
//  Blurry
//
//  Copyright (c) 2016-present patrick piemonte (http://patrickpiemonte.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import UIKit
import CoreImage
import CoreGraphics

public struct BlurryOptions: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    static let unspecified = BlurryOptions(rawValue: 0)
    static let dithered    = BlurryOptions(rawValue: 1 << 0)
    static let hardEdged   = BlurryOptions(rawValue: 1 << 1)
    static let saturated   = BlurryOptions(rawValue: 1 << 2)
    static let brightened  = BlurryOptions(rawValue: 1 << 3)
    
    static let none: BlurryOptions = (rawValue: unspecified)
    static let pro: BlurryOptions = [.hardEdged, .saturated]
    static let all: BlurryOptions = [.dithered, .hardEdged, .saturated, .brightened]
}

public class Blurry: NSObject {
    
    public class func blurryImage(forImage image: UIImage, size: CGSize, blurRadius: CGFloat) -> UIImage? {
        return self.blurryImage(withOptions: .none, overlayColor: nil, forImage: image, size: size, blurRadius: blurRadius)
    }
    
    public class func blurryImage(withOptions options: BlurryOptions, forImage image: UIImage, size: CGSize, blurRadius: CGFloat) -> UIImage? {
        return self.blurryImage(withOptions: options, overlayColor: nil, forImage: image, size: size, blurRadius: blurRadius)
    }
    
    public class func blurryImage(withOptions options: BlurryOptions, overlayColor: UIColor?, forImage image: UIImage, size: CGSize, blurRadius: CGFloat) -> UIImage? {
        var outputImage: UIImage? = nil

        let imageOutset = options.contains(BlurryOptions.hardEdged) ? 0.0 : (blurRadius * 2.0)
        
        var bitsPerComponent: size_t = 8
        if let cgimage = image.cgImage {
            bitsPerComponent = cgimage.bitsPerComponent
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)

        if let bitmapContext = CGContext(data: nil, width: Int(size.width + (imageOutset * 2.0)), height: Int(size.height + (imageOutset * 2.0)), bitsPerComponent: bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) {
            
            if let cgimage = image.cgImage {
                bitmapContext.draw(cgimage, in: CGRect(x: imageOutset, y: imageOutset, width: size.width, height: size.height))
            }
            
            if let blurryCGImage = bitmapContext.makeImage() {
                struct Static {
                    // Note:
                    // To request that Core Image perform no color management, specify the NSNull object as the value for this key.
                    // https://developer.apple.com/reference/coreimage/kcicontextworkingcolorspace
                    static var cicontext: CIContext? = CIContext(options: [kCIContextWorkingColorSpace:NSNull()])
                }
                let imageRect = bitmapContext.boundingBoxOfClipPath
                var ciimage = CIImage(cgImage: blurryCGImage)
                
                // apply saturation
                if options.contains(.saturated) {
                    ciimage.applyingFilter("CIColorControls", withInputParameters: [kCIInputSaturationKey:2.0])
                }
                
                // apply brightness
                if options.contains(.brightened) {
                    ciimage.applyingFilter("CIColorControls", withInputParameters: [kCIInputBrightnessKey:6.0])
                }
                
                // apply blur through to edge
                if options.contains(.hardEdged) {
                    ciimage = ciimage.clampingToExtent()
                }
                
                ciimage = ciimage.applyingFilter("CIGaussianBlur", withInputParameters: [kCIInputRadiusKey:blurRadius])
                
                // apply overlay color
                if let color = overlayColor {
                    let constantColorImage = CIImage(color: CIColor(cgColor: color.cgColor))
                    ciimage = constantColorImage.compositingOverImage(ciimage)
                }
                
                // apply dither
                if options.contains(.dithered) {
                    if let randomFilter = CIFilter(name: "CIRandomGenerator"), let randomImage = randomFilter.outputImage {
                        let monochromeVec = CIVector(x: 1, y: 0, z: 0, w: 0)
                        let inputParams = ["inputRVector": monochromeVec,
                                           "inputGVector": monochromeVec,
                                           "inputBVector": monochromeVec,
                                           "inputAVector": CIVector(x: 0, y: 0, z: 0, w: 0.04)]
                        let noiseImage = randomImage.applyingFilter("CIColorMatrix", withInputParameters: inputParams)
                        ciimage = noiseImage.compositingOverImage(ciimage)
                    }
                }
                
                // create output image
                if let context = Static.cicontext, let blurryCGImage = context.createCGImage(ciimage, from: imageRect) {
                    outputImage = UIImage(cgImage: blurryCGImage)
                }
            }
            
        }
        return outputImage
    }
}
