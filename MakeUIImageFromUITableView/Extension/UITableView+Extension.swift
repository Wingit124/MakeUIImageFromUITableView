//
//  UITableView+Extension.swift
//  MakeUIImageFromUITableView
//
//  Created by Takahashi Tsubasa on 2021/03/24.
//

import UIKit

extension UITableView {
    /// テーブルをキャプチャする前の状態を保持するストラクト
    private struct OriginalState {
        let contentOffset: CGPoint
        let isUserInteractionEnabled: Bool
        let showsVerticalScrollIndicator: Bool
    }
    /// 全コンテンツのキャプチャ画像
    var contentImage: UIImage? {
        get {
            return generateContentImage()
        }
    }
    /// テーブルの全コンテンツのキャプチャ画像を生成する処理
    /// - Returns: 全コンテンツのキャプチャ画像
    private func generateContentImage() -> UIImage? {
        //テーブルの状態を保存
        let originalState = OriginalState(contentOffset: contentOffset,
                                          isUserInteractionEnabled: isUserInteractionEnabled,
                                          showsVerticalScrollIndicator: showsVerticalScrollIndicator)
        //スクリーンショット用に状態を変更
        contentOffset.y = 0
        isUserInteractionEnabled = false
        showsVerticalScrollIndicator = false
        //キャプチャされた画像が入ってくる
        var captureImages: [UIImage] = []
        //コンテンツの高さ分スクロールを繰り返してキャプチャする
        var currentY: CGFloat = contentSize.height
        while currentY > 0 {
            //親ビューとの差を計算
            let topDiff = frame.minY - (superview?.frame.minY ?? 0)
            let leadingDiff = frame.minX - (superview?.frame.minX ?? 0)
            //トリミングに使うサイズ
            let cllipingRect = CGRect(x: leadingDiff, y: topDiff, width: visibleSize.width, height: visibleSize.height)
            //親ビューをキャプチャ後にトリミングして配列に詰める
            if let image = superview?.image?.clipping(to: cllipingRect) {
                captureImages.append(image)
            }
            //スクロールする
            currentY -= visibleSize.height
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
        contentOffset = originalState.contentOffset
        isUserInteractionEnabled = originalState.isUserInteractionEnabled
        showsVerticalScrollIndicator = originalState.showsVerticalScrollIndicator
        //画像を返す
        return mergedImage
    }
    
    
}
