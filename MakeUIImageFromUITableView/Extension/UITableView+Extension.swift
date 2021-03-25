//
//  UITableView+Extension.swift
//  MakeUIImageFromUITableView
//
//  Created by Takahashi Tsubasa on 2021/03/24.
//

import UIKit

extension UITableView {
    
    var contentImage: UIImage? {
        get {
            return generateContentImage()
        }
    }
    
    private var contentBottom: CGFloat {
        return contentSize.height - bounds.height
    }
    
    private func generateContentImage() -> UIImage? {
        
        let originalOffsetY = contentOffset.y
        isScrollEnabled = false
        scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        
        var captureImages: [UIImage] = []
        //コンテンツの高さ分スクロールを繰り返してキャプチャする
        while true {
            
            if let image = superview?.image { captureImages.append(image) }
            
            if contentOffset.y < (contentBottom - bounds.height) {
                contentOffset.y += bounds.height
            } else {
                contentOffset.y = contentBottom
                if let image = superview?.image { captureImages.append(image) }
                break
            }
        }
        //画像を結合
        UIGraphicsBeginImageContext(contentSize)
        var y: CGFloat = 0
        for image in captureImages {
            image.draw(at: CGPoint(x: 0, y: y))
            y = min(y + bounds.height, contentBottom)
        }
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        isScrollEnabled = true
        contentOffset.y = originalOffsetY
        
        return mergedImage
    }
    
    
}
