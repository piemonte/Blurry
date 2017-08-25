//
//  ViewController.swift
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

class ViewController: UIViewController {
    
    // MARK: UIViewController
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    // MARK: - view lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if let sampleImage = UIImage(named: "sampleImage") {
            let overlayColor = UIColor(white: 1, alpha: 0.75)
            let blurredImage = Blurry.blurryImage(withOptions: BlurryOptions.pro, overlayColor: overlayColor, forImage: sampleImage, size: sampleImage.size, blurRadius: 12.0)
            let blurredImageView = UIImageView(image: blurredImage)
            blurredImageView.contentMode = .scaleAspectFill
            blurredImageView.frame = self.view.bounds
            self.view.addSubview(blurredImageView)
        }
        
    }
}

