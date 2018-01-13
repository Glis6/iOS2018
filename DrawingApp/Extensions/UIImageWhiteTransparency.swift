//
//  UIImageWhiteTransparency.swift
//  DrawingApp
//
//  Created by Gilles Vercammen on 1/4/18.
//  Copyright © 2018 Gilles Vercammen. All rights reserved.
//

import UIKit

extension UIImage {
    func changeWhiteColorTransparent() -> UIImage {
        if cgImage == nil {
            return self
        }
        let rawImageRef = cgImage
        
        let colorMasking: [CGFloat] = [220, 255, 220, 255, 220, 255];
        
        UIGraphicsBeginImageContext(size);
        let context = UIGraphicsGetCurrentContext()
        let maskedImageRef = rawImageRef?.copy(maskingColorComponents: colorMasking)
        
        context?.translateBy(x: 0.0, y: size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.draw(maskedImageRef!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
}
