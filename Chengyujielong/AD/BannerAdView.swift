////
////  BannerAdView.swift
////  CrazyMusic
////
////  Created by LiQi on 2020/8/18.
////  Copyright © 2020 LQ. All rights reserved.
////
//
//import UIKit
////import BUAdSDK
//import RxSwift
//import RxCocoa
//
//class BannerAdView: UIView  {
//    
//    var bannderAdView: BUNativeExpressBannerView?
//    let slotId: String
//    weak var controller: UIViewController?
//    
//    init(controller: UIViewController?, slotId: String) {
//        self.controller = controller
//        self.slotId = slotId
//        let scale:CGFloat = 640.0/100.0
//        let width = UIDevice.screenWidth
//        let height = width/scale
//        let frame = CGRect(x: 0, y: 0, width: width, height: height)
//        super.init(frame: frame)
//        backgroundColor = .white
//        Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
//            guard let self = self else { return }
//            self.loadBannerAd()
//        }).disposed(by: rx.disposeBag)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - 广告
//    private func loadBannerAd() {
//        let width = UIDevice.screenWidth
//        let scale:CGFloat = 640.0/100.0
//        let size = CGSize(width: width, height: width/scale)
//        if let vc = controller {
//            bannderAdView = BUNativeExpressBannerView(slotID: slotId, rootViewController: vc, adSize: size, isSupportDeepLink: true)
//            bannderAdView?.frame = CGRect(origin: .init(x: 0, y: 0), size: size)
//            bannderAdView?.delegate = self
//            bannderAdView?.loadAdData()
//        }
//    }
//    
//}
//
//extension BannerAdView: BUNativeExpressBannerViewDelegate {
//
//    func nativeExpressBannerAdViewDidLoad(_ bannerAdView: BUNativeExpressBannerView) {
//        subviews.forEach{ $0.removeFromSuperview() }
//        addSubview(bannerAdView)
//    }
//
//    func nativeExpressBannerAdView(_ bannerAdView: BUNativeExpressBannerView, didLoadFailWithError error: Error?) {
////        print(error)
//    }
//}
