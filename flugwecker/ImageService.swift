//
//  ImageService.swift
//  flugwecker
//
//  Created by Udo von Eynern on 25.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

func VEResizeImage(sourceImage: UIImage, targetSize: CGSize) -> UIImage {
    
    
    var newImage:UIImage
    
    var imageSize = sourceImage.size
    var width = Float(imageSize.width)
    var height = Float(imageSize.height)
    
    var targetWidth = Float(targetSize.width)
    var targetHeight = Float(targetSize.height)
    
    var scaleFactor:Float
    var scaledWidth = targetWidth
    var scaledHeight = targetHeight
    
    var thumbnailPoint = CGPointMake(0, 0)
    
    if CGSizeEqualToSize(imageSize, targetSize) == false {
        var widthFactor:Float = Float(targetWidth / width)
        var heightFactor:Float = Float(targetHeight / height)
        
        if widthFactor > heightFactor {
            scaleFactor = widthFactor
        } else {
            scaleFactor = heightFactor
        }
        
        scaledWidth = Float(width * scaleFactor)
        scaledHeight = Float(height * scaleFactor)
        
        if widthFactor > heightFactor {
            thumbnailPoint.y = CGFloat(Float(targetHeight - scaledHeight) * Float(0.5))
        } else {
            thumbnailPoint.x = CGFloat(Float(targetWidth - scaledWidth) * Float(0.5))
        }
    }
    
    UIGraphicsBeginImageContext(targetSize)
    
    var thumbnailRect:CGRect = CGRectZero
    thumbnailRect.origin = thumbnailPoint
    thumbnailRect.size.width  = CGFloat(scaledWidth)
    thumbnailRect.size.height = CGFloat(scaledHeight)
    
    sourceImage.drawInRect(thumbnailRect)
    
    newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}