//
//  UIView+Extension.swift
//  MakeUIImageFromUITableView
//
//  Created by Takahashi Tsubasa on 2021/03/24.
//

import UIKit

extension UIView {
    /// viewのキャプチャ画像
    var image: UIImage? {
        get {
            return generateImage()
        }
    }
    /// viewの画像を生成する処理
    /// - Returns: viewのキャプチャ画像
    private func generateImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return capturedImage
    }
    
}
