//
//  MusicPlayer.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/17.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa

class MusicPlayer: NSObject {
    
    static let shared = MusicPlayer()
    private var player: AVPlayer?
    private var currentUrl: String?
    weak var currentViewControler: HomeViewController?
    private var isPlay = false
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: OperationQueue.main) { [weak self] no in
            guard let self = self else { return }
            self.stop()
//            if let player = self?.player {
//                player.currentItem?.seek(to: CMTime.zero)
//                player.play()
//            }
        }
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.main) { [weak self] no in
            guard let self = self else { return }
            if let url = self.currentUrl {
                self.play(url: url)
            }
        }
        Observable<Int>.interval(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            guard let vc = self.currentViewControler else { return }
//            if vc.isViewLoaded , let _ = vc.view.window, vc.isAppear, PopView.window.isHidden {
//                self.play()
//            } else {
//                self.stop()
//            }
            if vc.isViewLoaded , let _ = vc.view.window, PopView.window.isHidden {
                self.play()
            } else {
                self.stop()
            }
        }).disposed(by: rx.disposeBag)
    }
    
    func play(url: String) {
        stop()
        currentUrl = url
    }
    
    func stop() {
        player?.pause()
        player = nil
        isPlay = false
    }
    
    func play() {
        if isPlay {
            return
        }
        if let c = currentUrl {
            player = nil
            if let u = URL(string: c) {
                player = AVPlayer(url: u)
                player?.play()
                isPlay = true
            }
        }
    }
    
    
}
