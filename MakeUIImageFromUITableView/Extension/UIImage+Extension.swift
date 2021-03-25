//
//  UIImage+Extension.swift
//  MakeUIImageFromUITableView
//
//  Created by Takahashi Tsubasa on 2021/03/25.
//

import UIKit

extension UIImage {
    /// 画像を指定したサイズでトリミングする関数
    /// - Parameter to: トリミング後のサイズ
    /// - Returns: トリミング後の画像
    func clipping(to: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, scale)
        draw(at: CGPoint(x: -to.origin.x, y: -to.origin.y))
        let trimImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return trimImage
    }
    
}
