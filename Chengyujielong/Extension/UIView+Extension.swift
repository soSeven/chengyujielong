//
//  UIView+Extension.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/27.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIView {
    
    func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) {
        
        let shadowLayer = CAShapeLayer()
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
        shadowLayer.path = cgPath //2
        shadowLayer.fillColor = fillColor.cgColor //3
        shadowLayer.shadowColor = shadowColor.cgColor //4
        shadowLayer.shadowPath = cgPath
        shadowLayer.shadowOffset = offSet //5
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        self.layer.addSublayer(shadowLayer)
    }
    
    
}

extension UIButton {
    
    func startCountDown(time: Int, countDown: @escaping (Int, UIButton)->(), completion: @escaping (UIButton)->()) {
        var count = time
        countDown(count, self)
        isUserInteractionEnabled = false
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            count -= 1
            if count <= 0 {
                self.isUserInteractionEnabled = true
                completion(self)
            } else {
                countDown(count, self)
            }
        }).disposed(by: rx.disposeBag)
    }
    
}
