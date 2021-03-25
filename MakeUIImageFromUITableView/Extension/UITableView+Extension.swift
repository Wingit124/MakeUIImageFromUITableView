//
//  UITableView+Extension.swift
//  MakeUIImageFromUITableView
//
//  Created by Takahashi Tsubasa on 2021/03/24.
//

import UIKit

extension UITableView {
    /// 全コンテンツのキャプチャ画像
    var contentImage: UIImage? {
        get {
            return generateContentImage()
        }
    }
    
    /// テーブルの全コンテンツのキャプチャ画像を生成する処理
    /// - Returns: 全コンテンツのキャプチャ画像
    private func generateContentImage() -> UIImage? {
        //テーブルの状態を変更
        let originalOffsetY = contentOffset.y
        isScrollEnabled = false
        scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        //キャプチャされた画像が入ってくる
        var captureImages: [UIImage] = []
        //コンテンツの高さ分スクロールを繰り返してキャプチャする
        var currentHeight: CGFloat = contentSize.height
        while currentHeight > 0 {
            //親ビューとの差を計算
            let topDiff = frame.minY - (superview?.frame.minY ?? 0)
            let leadingDiff = frame.minX - (superview?.frame.minX ?? 0)
            //トリミング後のサイズ
            let cllipingRect = CGRect(x: leadingDiff, y: topDiff, width: visibleSize.width, height: visibleSize.height)
            //キャプチャ後にトリミングして配列に詰める
            if let image = superview?.image?.clipping(to: cllipingRect) {
                captureImages.append(image)
            }
            //スクロールする
            currentHeight -= visibleSize.height
            contentOffset.y += visibleSize.height
        }
        //画像を結合
        UIGraphicsBeginImageContext(contentSize)
        var y: CGFloat = 0
        for image in captureImages {
            image.draw(at: CGPoint(x: 0, y: y))
            y += visibleSize.height
        }
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //テーブルの状態を元に戻す
        isScrollEnabled = true
        contentOffset.y = originalOffsetY
        //画像を返す
        return mergedImage
    }
    
    
}
