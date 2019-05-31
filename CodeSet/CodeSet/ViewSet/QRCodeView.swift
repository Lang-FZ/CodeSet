//
//  QRCodeView.swift
//  OnceNaive_Swift
//
//  Created by LangFZ on 2019/5/31.
//  Copyright © 2019 LangFZ. All rights reserved.
//

import UIKit
import CoreImage
import CoreGraphics
import Photos

// MARK: -

class QRCodeView: UIImageView {

    //filter
    private lazy var filter: CIFilter = {
        let filter = CIFilter.init(name: "CIQRCodeGenerator") ?? CIFilter.init()
        filter.setDefaults()
        return filter
    }()
    
    
    public var url: String = "" {
        didSet {
            createQRCodeView(url)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension QRCodeView {
    
    private func createQRCodeView(_ url:String) {

        let data = url.data(using: String.Encoding.utf8)
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        
        self.image = get_HD_QRCode_Image(filter.outputImage ?? CIImage.init(), self.frame.size, UIColor.black, UIColor.clear)
        filter.setDefaults()
    }
    
    private func get_HD_QRCode_Image(_ image:CIImage, _ size:CGSize, _ qr_code_color:UIColor, _ bg_color:UIColor) -> UIImage {
        
        let color_filter = CIFilter.init(name: "CIFalseColor", parameters: [
            "inputImage"    :   image,
            "inputColor0"   :   CIColor.init(cgColor: qr_code_color.cgColor),
            "inputColor1"   :   CIColor.init(cgColor: bg_color.cgColor)
            ])
        
        guard let qr_image = color_filter?.outputImage else { return UIImage.init() }
        guard let cg_image = CIContext.init(options: nil).createCGImage(qr_image, from: qr_image.extent) else { return UIImage.init() }
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.interpolationQuality = CGInterpolationQuality.none
        context?.scaleBy(x: 1, y: -1)
        context?.draw(cg_image, in: context?.boundingBoxOfClipPath ?? qr_image.extent)
        
        guard let code_image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage.init() }
        UIGraphicsEndImageContext()
        
        return code_image
    }
}

