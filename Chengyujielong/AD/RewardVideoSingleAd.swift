////
////  RewardVideoSingleAd.swift
////  Chengyujielong
////
////  Created by liqi on 2020/9/30.
////  Copyright © 2020 Kaka. All rights reserved.
////
//
////import BUAdSDK
//import RxCocoa
//import RxSwift
//
//class RewardVideoSingleAd: NSObject {
//    
//    static let shared = RewardVideoSingleAd()
//    
//    static var adCount = 0
//    
//    var viewControler: UIViewController!
//
//    let ad: BUNativeExpressRewardedVideoAd
//    let gdAd: GDTRewardVideoAd
//    var completion: (()->())?
//    var failure: (()->())?
//    
//    var adDidDownloaded = false
//
//    override init() {
//        
//        /// 优量汇
//        gdAd = GDTRewardVideoAd.init(placementId: "1011735452950756")
//        gdAd.videoMuted = false // 设置激励视频是否静音
//        
//        /// 穿山甲
//        let model = BURewardedVideoModel()
//        if let uid = UserManager.shared.login.value.0?.id {
//            model.userId = "\(uid)"
//        }
//        ad = BUNativeExpressRewardedVideoAd(slotID: "945522879", rewardedVideoModel: model)
//        
//        super.init()
//        
//        gdAd.delegate = self
//        ad.delegate = self
//        
//        loadAd()
//    }
//    
//    private func isChange() -> Bool {
//        let danceRate = UserManager.shared.configure?.constField.csjAd ?? 0
//        let qqRate = UserManager.shared.configure?.constField.ylhAd ?? 0
//        RewardVideoAd.adCount += 1
//        return ((danceRate + qqRate) <= 0) || (RewardVideoAd.adCount % (danceRate + qqRate) < danceRate)
//    }
//    
//    func showAd(vc: UIViewController) {
//        
//        if isChange() {
//            
//            MobClick.event("video_pangolin_click", attributes: [
//                "channelId": UserManager.shared.user?.channelId ?? "0",
//                "channel":  UserManager.shared.user?.channel ?? "unknown"
//            ])
//            
//            if  self.adDidDownloaded {
//                self.adDidDownloaded = false
//                ad.show(fromRootViewController: vc)
//            } else if gdAd.isAdValid {
//                gdAd.show(fromRootViewController: vc)
//            } else {
//                showMsg(msg: "广告未加载完成")
//                failure?()
//                loadAd()
//            }
//        } else {
//            
//            MobClick.event("video_tencent_click", attributes: [
//                "channelId": UserManager.shared.user?.channelId ?? "0",
//                "channel":  UserManager.shared.user?.channel ?? "unknown"
//            ])
//            
//            if gdAd.isAdValid {
//                gdAd.show(fromRootViewController: vc)
//            } else if self.adDidDownloaded {
//                self.adDidDownloaded = false
//                ad.show(fromRootViewController: vc)
//            } else {
//                showMsg(msg: "广告未加载完成")
//                failure?()
//                loadAd()
//            }
//        }
//    }
//    
//    private func loadAd() {
//        
//        if !self.adDidDownloaded {
//            ad.loadData()
//        }
//        if !gdAd.isAdValid {
//            gdAd.load()
//        }
//        
//    }
//    
//    private func delayLoadAd() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.loadAd()
//        }
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
//extension RewardVideoSingleAd: BUNativeExpressRewardedVideoAdDelegate {
//    
//    func nativeExpressRewardedVideoAdDidDownLoadVideo(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
//        self.adDidDownloaded = true
//    }
//    
//    func nativeExpressRewardedVideoAdDidLoad(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
//        
//    }
//    
//    func nativeExpressRewardedVideoAdDidClose(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
//        
//        completion?()
//        completion = nil
//        failure = nil
//        delayLoadAd()
//    }
//    
//    func nativeExpressRewardedVideoAdDidPlayFinish(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, didFailWithError error: Error?) {
//        
//        if error != nil {
//            print(error!)
//            failure?()
//            failure = nil
//            completion = nil
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
//            failure?()
//            failure = nil
//            completion = nil
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
//            failure?()
//            failure = nil
//            completion = nil
//            MobClick.event("csj_load_fail", attributes: [
//                "errorMsg" : error!.localizedDescription
//            ])
//        } else {
//            
//        }
//
//    }
//    
//}
//
//extension RewardVideoSingleAd: GDTRewardedVideoAdDelegate {
//    
//    func gdt_rewardVideoAdDidLoad(_ rewardedVideoAd: GDTRewardVideoAd) {
//        
//        
//    }
//    
//    func gdt_rewardVideoAdDidClose(_ rewardedVideoAd: GDTRewardVideoAd) {
//        
//        completion?()
//        completion = nil
//        failure = nil
//        delayLoadAd()
//        
//    }
//    
//    func gdt_rewardVideoAd(_ rewardedVideoAd: GDTRewardVideoAd, didFailWithError error: Error) {
//        
//        print(error)
//        failure?()
//        failure = nil
//        completion = nil
//        MobClick.event("gdt_load_fail", attributes: [
//            "errorMsg" : error.localizedDescription
//        ])
//        
//    }
//    
//}
//
//
