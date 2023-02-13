////
////  RewardVideoAd.swift
////  CrazyMusic
////
////  Created by LiQi on 2020/8/13.
////  Copyright © 2020 LQ. All rights reserved.
////
//
//import Foundation
////import BUAdSDK
//import RxCocoa
//import RxSwift
//
//class RewardVideoAd: NSObject {
//    
//    static var adCount = 0
//
//    var ad: BUNativeExpressRewardedVideoAd?
//    var gdAd: GDTRewardVideoAd?
//    var completion: (()->())?
//    var failure: (()->())?
//    let slotId: String
//    let gdSlotId: String
//    let needLoad: Bool
//
//    init(slotId: String?, gdSlotId: String?, needLoad: Bool = false) {
//        
//        self.slotId = "945522446"
//        self.gdSlotId = "1011735452950756"
//        self.needLoad = needLoad
//        super.init()
//        loadAd()
//        
//    }
//    
//    private func isChange() -> Bool {
//        let danceRate = 10
//        let qqRate = 0
//        RewardVideoAd.adCount += 1
//        return ((danceRate + qqRate) <= 0) || (RewardVideoAd.adCount % (danceRate + qqRate) < danceRate)
//    }
//    
//    func showAd(vc: UIViewController) {
//        
//        if isChange() {
//            if let ad = ad, ad.isAdValid {
//                ad.show(fromRootViewController: vc)
//            } else if let ad = gdAd, ad.isAdValid {
//                ad.show(fromRootViewController: vc)
//            } else {
//                failure?()
//            }
//        } else {
//            if let ad = gdAd, ad.isAdValid {
//                ad.show(fromRootViewController: vc)
//            } else if let ad = ad, ad.isAdValid {
//                ad.show(fromRootViewController: vc)
//            } else {
//                failure?()
//            }
//        }
//        
//    }
//    
//    func loadAd() {
//    
//        loadBuAd()
//        loadGdAd()
//        
//    }
//    
//    // MARK: -
//    
//    private func loadGdAd() {
//        
//        gdAd = GDTRewardVideoAd.init(placementId: gdSlotId)
//        gdAd?.delegate = self
//        gdAd?.videoMuted = false // 设置激励视频是否静音
//        gdAd?.load()
//        
//    }
//    
//    private func showGdAd(vc: UIViewController) {
//        
//        guard let ad = self.gdAd else {
//            return
//        }
//        let channel = UserManager.shared.user?.channel ?? ""
//        MobClick.event("video_tencent_click", attributes: [
//            "channel" : channel
//        ])
//        
//        if ad.isAdValid {
//            ad.show(fromRootViewController: vc)
//        } else {
//            showMsg(msg: "广告未加载完成")
//            loadAd()
//        }
//        
//    }
//    
//    // MARK: -
//
//    private func loadBuAd() {
//        
//        let model = BURewardedVideoModel()
//        if let uid = UserManager.shared.login.value.0?.id {
//            model.userId = "\(uid)"
//        }
//        ad = BUNativeExpressRewardedVideoAd(slotID: self.slotId, rewardedVideoModel: model)
//        ad?.delegate = self
//        ad?.loadData()
//        
//    }
//        
//    private func showBuAd(vc: UIViewController) {
//        
//        guard let ad = self.ad else {
//            return
//        }
//        
//        let channel = UserManager.shared.user?.channel ?? ""
//        MobClick.event("video_pangolin_click", attributes: [
//            "channel" : channel
//        ])
//        
//        if ad.isAdValid {
//            ad.show(fromRootViewController: vc)
//        } else {
//            showMsg(msg: "广告未加载完成")
//            loadAd()
//        }
//        
//    }
//    
//    private func showMsg(msg: String) {
//        
//        if let view = UIApplication.shared.windows.last {
//            Observable.just(msg).bind(to: view.rx.toastText()).disposed(by: self.rx.disposeBag)
//        }
//        
//    }
//    
//}
//
//extension RewardVideoAd: BUNativeExpressRewardedVideoAdDelegate {
//    
//    func nativeExpressRewardedVideoAdDidLoad(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
//        
//    }
//    
//    func nativeExpressRewardedVideoAdDidClose(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
//        
//        completion?()
//        MobClick.event("award_success")
//        let userId = UserManager.shared.user?.id ?? "0"
//        MobClick.event("award_type", attributes: [
//            "type": "0",
//            "userId": userId
//        ])
//        if needLoad {
//            loadAd()
//        }
//    }
//    
//    func nativeExpressRewardedVideoAdDidPlayFinish(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, didFailWithError error: Error?) {
//        
//        if error != nil {
//            print(error!)
////            showMsg(msg: "播放广告失败")
//            failure?()
//            failure = nil
//        } else {
//            
//        }
//        
//    }
//
//    func nativeExpressRewardedVideoAdViewRenderFail(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, error: Error?) {
//        
//        if error != nil {
//            print(error!)
////            showMsg(msg: "渲染广告失败")
//            failure?()
//            failure = nil
//        } else {
//            
//        }
//        
//    }
//
//    func nativeExpressRewardedVideoAd(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, didFailWithError error: Error?) {
//        
//        if error != nil {
//            print(error!)
////            showMsg(msg: "加载广告失败")
//            MobClick.event("award_failure")
//            failure?()
//            failure = nil
//        } else {
//            
//        }
//
//    }
//    
//}
//
//extension RewardVideoAd: GDTRewardedVideoAdDelegate {
//    
//    func gdt_rewardVideoAdDidLoad(_ rewardedVideoAd: GDTRewardVideoAd) {
//        
//        
//    }
//    
//    func gdt_rewardVideoAdDidClose(_ rewardedVideoAd: GDTRewardVideoAd) {
//        
//        completion?()
//        MobClick.event("award_success")
//        MobClick.event("gdt_award_success")
//        let userId = UserManager.shared.user?.id ?? "0"
//        MobClick.event("award_type", attributes: [
//            "type": "1",
//            "userId": userId
//        ])
//        if needLoad {
//            loadAd()
//        }
//    }
//    
//    func gdt_rewardVideoAd(_ rewardedVideoAd: GDTRewardVideoAd, didFailWithError error: Error) {
//        
////        showMsg(msg: "加载广告失败")
//        MobClick.event("award_failure")
//        print(error)
//        failure?()
//        failure = nil
//        
//    }
//    
//}
