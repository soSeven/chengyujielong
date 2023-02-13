//
//  ListAdAnimationView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/22.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit

class ListAdAnimationView: UIView {
    
    var bgView: UIView!
    var adContentView: UIView!
    
    var isAnimating = false
    var isFirst = true
    
    init(slotId: String?, w: CGFloat) {
        
//        let adView = ListAdView(slotId: slotId, w: w - 20)
        let adView = UIView(frame: .init(x: 0, y: 0, width: 200, height: 100))
        let frame = CGRect(x: 0, y: 0, width: adView.width + 20, height: adView.height + 20)
        super.init(frame: frame)
        bgView = UIView()
        bgView.frame = bounds
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = .clear
        backgroundColor = .clear
        addSubview(bgView)
        
        adContentView = UIView()
        adContentView.backgroundColor = .clear
        adContentView.size = adView.size
        adContentView.x = 10
        adContentView.y = 10
        addSubview(adContentView)
        adContentView.addSubview(adView)
        adView.frame = adContentView.bounds
        
        createAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    deinit {
        print("deinit \(self)")
    }
    
    func createAnimation() {
        
        let m: CGFloat = 5
        let rect = CGRect(x: 0, y: 0, width: bgView.bounds.width - 2*m, height: bgView.bounds.height - 2*m)
        
        let path1 = UIBezierPath()
        for _ in 0...10000 {
            path1.move(to: .init(x: 0, y: 0))
            path1.addLine(to: .init(x: rect.width, y: 0))
            path1.addLine(to: .init(x: rect.width, y: rect.height))
            path1.addLine(to: .init(x: 0, y: rect.height))
            path1.addLine(to: .init(x: 0, y: 0))
        }
        path1.close()
        
        let path2 = UIBezierPath()
        for _ in 0...10000 {
            path2.move(to: .init(x: rect.width, y: rect.height))
            path2.addLine(to: .init(x: 0, y: rect.height))
            path2.addLine(to: .init(x: 0, y: 0))
            path2.addLine(to: .init(x: rect.width, y: 0))
            path2.addLine(to: .init(x: rect.width, y: rect.height))
        }
        path2.close()
        
        lineAnimation(path: path1, rect: rect)
        lineAnimation(path: path2, rect: rect)
    }
    
    func lineAnimation(path: UIBezierPath, rect: CGRect) {
        
        //创建彩虹渐变层
        let gradientLayer =  CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x:0, y:0)
        gradientLayer.endPoint = CGPoint(x:1, y:1)
        gradientLayer.frame = bgView.bounds
        
        var rainBowColors:[CGColor] = []
        var hue:CGFloat = 0
        while hue <= 360 {
            let color = UIColor(hue: 1.0*hue/360.0, saturation: 1.0, brightness: 1.0,
                                alpha: 1.0)
            rainBowColors.append(color.cgColor)
            hue += 1
        }
        gradientLayer.colors = rainBowColors
        
        //添加渐变层
        bgView.layer.insertSublayer(gradientLayer, at: 0)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = rect
        shapeLayer.path = path.cgPath
        shapeLayer.strokeEnd = 0
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.position = bgView.center
        shapeLayer.shadowRadius = 4
        shapeLayer.lineCap = .round
        bgView.layer.addSublayer(shapeLayer)
        
        let gap = 0.3 / 10000
        let max =  1 - gap
        
        let aniStart = CABasicAnimation(keyPath: "strokeStart")
        aniStart.fromValue = 0
        aniStart.toValue = max
        
        let aniEnd = CABasicAnimation(keyPath: "strokeEnd")
        aniEnd.fromValue = 0 + gap
        aniEnd.toValue = max + gap
        
        let group = CAAnimationGroup()
        group.duration = 10000
        group.repeatCount = HUGE
        group.fillMode = .forwards
        group.animations = [aniEnd, aniStart]
        group.isRemovedOnCompletion = false
        
        shapeLayer.add(group, forKey: nil)
        
        gradientLayer.mask = shapeLayer
    }
    
}
