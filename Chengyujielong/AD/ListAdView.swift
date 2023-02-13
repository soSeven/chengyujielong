////
////  ListAdView.swift
////  CrazyMusic
////
////  Created by LiQi on 2020/8/13.
////  Copyright © 2020 LQ. All rights reserved.
////
//
//import UIKit
////import BUAdSDK
//
//class ListAdView: UIView {
//    
//    var feedAd: BUNativeExpressAdManager?
//    let slotId: String?
//
//    init(slotId: String?, w: CGFloat) {
//        self.slotId = slotId
//        let height: CGFloat = 284/375 * w
//        let frame = CGRect(x: 0, y: 0, width: w, height: height)
//        super.init(frame: frame)
//        loadFeedAd()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func loadFeedAd() {
//
//        let imgSize = BUSize(by: .feed690_388)
//
//        let slot = BUAdSlot()
//        slot.id = "945516953"
//        slot.adType = .feed
//        slot.imgSize = imgSize
//        slot.position = .feed
//        slot.isSupportDeepLink = true
//
//        let width: CGFloat = self.width
//        let height: CGFloat = 284/375 * width
//        let size = CGSize(width: width, height: height)
//
//        feedAd = BUNativeExpressAdManager(slot: slot, adSize: size)
//        feedAd?.delegate = self
//        feedAd?.loadAd(1)
//
//    }
//    
//}
//
//extension ListAdView: BUNativeExpressAdViewDelegate {
//
//    func nativeExpressAdSuccess(toLoad nativeExpressAd: BUNativeExpressAdManager, views: [BUNativeExpressAdView]) {
//
//        if let adView = views.first {
//            addSubview(adView)
//            adView.rootViewController = parentViewController
//            adView.render()
//
//        }
//    }
//
//    func nativeExpressAdFail(toLoad nativeExpressAd: BUNativeExpressAdManager, error: Error?) {
//        print(error)
//    }
//}
