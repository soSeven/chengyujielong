//
//  PopView.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/10.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit

class PopView: ViewController {
    
    static let window: UIWindow = {
        let w = UIWindow(frame: UIScreen.main.bounds)
        w.windowLevel = .statusBar
        return w
    }()
    
    let backView = UIView()
    var customView: UIView?
    var needAd = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: UIDevice.screenHeight)
        view.frame = frame
        view.backgroundColor = .clear
        backView.frame = view.bounds
        backView.backgroundColor = UIColor(hex: "#000000").alpha(0.8)
        backView.alpha = 0
        view.addSubview(backView)
        hbd_barHidden = true
        
//        if needAd {
//            let banner = BannerAdView(controller: self, slotId: "945408286")
//            banner.x = 0
//            banner.y = backView.height - banner.height - UIDevice.safeAreaBottom
//            backView.addSubview(banner)
//        }
    
    }
    
    func show(view: UIView, needNav: Bool = false) {
        PopView.window.rootViewController = needNav ? NavigationController(rootViewController: self) : self
        PopView.window.isHidden = false
        customView = view
        view.x = (self.view.width - view.width)/2.0
        view.y = (UIDevice.screenHeight - view.height)/2.0
        self.view.addSubview(view)
        view.transform = .init(scaleX: 0.2, y: 0.2)
        view.alpha = 0
        UIView.animate(withDuration: 0.25) {
            view.transform = .identity
            self.backView.alpha = 1
            view.alpha = 1
        }
    }
    
    func hide(completion: (()->())? = nil) {
        UIView.animate(withDuration: 0.25, animations: {
            self.customView?.transform = .init(scaleX: 0.2, y: 0.2)
            self.backView.alpha = 0
            self.customView?.alpha = 0
        }, completion: { finish in
            self.customView = nil
            PopView.window.rootViewController = nil
            PopView.window.isHidden = true
            completion?()
        })
    }
    
    class func show(view: UIView, needAd: Bool = true, needNav: Bool = false) {
        let pop = PopView()
        pop.needAd = needAd
        pop.show(view: view, needNav: needNav)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

