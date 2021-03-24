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
    
    private func generateContentImage() -> UIImage? {
        
        let originalOffsetY = self.contentOffset.y
        self.isScrollEnabled = false
        self.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        
        var contentHeight = self.contentSize.height
        let visibleHeight = self.visibleSize.height
        
        var captureImages: [UIImage] = []
        //コンテンツの高さ分スクロールを繰り返してキャプチャする
        while (contentHeight > 0) {
            if let image = superview?.image {
                captureImages.append(image)
            }
            //現在表示されてる高さを全体から引く
            contentHeight -= self.visibleSize.height
            self.contentOffset.y += self.visibleSize.height
        }
        //画像を結合
        UIGraphicsBeginImageContext(contentSize)
        var y: CGFloat = 0
        for image in captureImages {
            print(y)
            image.draw(at: CGPoint(x: 0, y: y))
            y += visibleHeight
        }
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.isScrollEnabled = true
        self.contentOffset.y = originalOffsetY
        
        return mergedImage
    }

    
}
