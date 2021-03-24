//
//  UICaptuableTableView.swift
//  MakeUIImageFromUITableView
//
//  Created by Takahashi Tsubasa on 2021/03/21.
//

import UIKit

class UICapturableTableView: UITableView {
    
    //スクショを撮る前のY座標
    private var originalOffsetY: CGFloat!
    //断片的なスクリーンショットが入る配列
    private var captureImages: [UIImage] = []
    
    func generateContentImage() -> UIImage? {
        
        originalOffsetY = self.contentOffset.y
        self.isScrollEnabled = false
        self.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        
        var contentHeight = self.contentSize.height
        let visibleHeight = self.visibleSize.height
        
        while (contentHeight > 0) {
            //viewを合成して画像を生成
            UIGraphicsBeginImageContextWithOptions(superview!.frame.size, false, 0)
            superview!.layer.render(in: UIGraphicsGetCurrentContext()!)
            let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if let image = capturedImage {
                captureImages.append(image)
            }
            //現在表示されてる高さを全体から引く
            contentHeight -= visibleHeight
            self.contentOffset.y += visibleHeight
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
