//
//  PlayView.swift
//  Chengyujielong
//
//  Created by liqi on 2020/10/9.
//  Copyright © 2020 Kaka. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SwifterSwift

class PlayView: UIView {
    
    private var currentItem: PlayViewItem?
    
    let playModel: PlayModel
    private var items = [PlayViewItem]()
    private var group = [PlayGroupViewModel]()
    
    var pushAction: ((PlayWordViewModel)->())?
    var successAction: (()->())?
    
    private var rightGroupCount = 0

    init(playModel: PlayModel) {
        self.playModel = playModel
        super.init(frame: .zero)
        setup()
    }
    
    func setup() {
        
        if !(playModel.word.count == playModel.posx.count && playModel.word.count == playModel.posy.count) {
            print("ERROR: 题目数量不对")
            return
        }
        
//        backgroundColor = .orange
        
//        let originScaleWidth = playModel.maxWidth / (CGFloat(playModel.width) * (playModel.itemWidth) + CGFloat(playModel.width - 1) * (playModel.margin))
//        let originScaleHeight = playModel.maxHeight / (CGFloat(playModel.height) * (playModel.itemWidth) + CGFloat(playModel.width - 1) * (playModel.margin))
//        let originScale = CGFloat.minimum(originScaleWidth, originScaleHeight)

        let margin = playModel.margin
        var startX: CGFloat = 0
        var startY: CGFloat = 0
        let width = playModel.itemWidth
        let height = playModel.itemWidth
        
        self.width = CGFloat(playModel.width) * (margin + width) - margin
        self.height = CGFloat(playModel.height) * (margin + height) - margin
        self.x = (playModel.maxWidth - self.width)/2.0
        self.y = (playModel.maxHeight - self.height)/2.0
        
        for x in 0..<playModel.width {
            startY = 0
            startX = CGFloat(x) * (margin + width)
            for y in 0..<playModel.height {
                startY = CGFloat(y) * (margin + height)
                let item = PlayViewItem(scale: playModel.originScale)
                item.didClickItem = {[weak self] i in
                    guard let self = self else { return }
                    self.onClickItem(i: i)
                }
                item.viewModel.x = x
                item.viewModel.y = y
                item.width = width
                item.height = height
                item.x = startX
                item.y = startY
                addSubview(item)
                items.append(item)
            }
        }
        
        for (idx, word) in playModel.word.enumerated() {
            let x = playModel.posx[idx]
            let y = playModel.height - playModel.posy[idx] - 1
            let i = items.first { item -> Bool in
                return item.viewModel.x == x && item.viewModel.y == y
            }
            if let item = i {
//                print("word:", word)
                item.viewModel.rightText = word
                if playModel.answer.contains(idx) {
                    item.viewModel.type.accept(.write)
                    item.viewModel.text.accept(nil)
                } else {
                    item.viewModel.type.accept(.finish)
                    item.viewModel.text.accept(word)
                }
            }
        }
        
        var rightCh = [String]()
        // 组成成语
        for ch in playModel.idiom {
            var group1 = [[PlayViewItem]]()
            for word in ch.charactersArray {
                let e = items.filter { item -> Bool in
                    item.viewModel.rightText.contains(word)
                }
                if !e.isEmpty {
                    group1.append(e)
                }
            }
            if group1.isEmpty {
                continue
            }
            
            let first = group1[0]
            for item in first {
                var finishedX = [PlayWordViewModel]()
                var finishedY = [PlayWordViewModel]()
                for g in group1 {
                    let rowX = g.first(where: {$0.viewModel.x == item.viewModel.x && !finishedX.contains($0.viewModel) }).map{$0.viewModel}
                    let rowY = g.first(where: {$0.viewModel.y == item.viewModel.y && !finishedY.contains($0.viewModel) }).map{$0.viewModel}
                    if let rowX = rowX {
                        finishedX.append(rowX)
                    }
                    if let rowY = rowY {
                        finishedY.append(rowY)
                    }
                }
                if finishedX.count == ch.charactersArray.count {
                    let groupViewModel = PlayGroupViewModel(items: finishedX, text: ch)
                    finishedX.forEach{ $0.groupViewModel.append(groupViewModel) }
                    group.append(groupViewModel)
                    rightCh.append(ch)
                    break
                }
                
                if finishedY.count == ch.charactersArray.count {
                    let groupViewModel = PlayGroupViewModel(items: finishedY, text: ch)
                    finishedY.forEach{ $0.groupViewModel.append(groupViewModel) }
                    group.append(groupViewModel)
                    rightCh.append(ch)
                    break
                }
            }
        }
        
//        print(rightCh)
        if rightCh.count < playModel.idiom.count {
            /// 有错误的成语
            let wrongCh = playModel.idiom.removeAll(rightCh)
//            print(wrongCh)
            for ch in wrongCh {
                var group1 = [[PlayViewItem]]()
                for word in ch.charactersArray {
                    let e = items.filter { item -> Bool in
                        item.viewModel.rightText.contains(word)
                    }
                    if !e.isEmpty {
                        group1.append(e)
                    }
                }
                if group1.isEmpty {
                    continue
                }
                
                /// 选出 x, y 最相同的
                var finishedMaxX = [PlayWordViewModel]()
                var finishedMaxY = [PlayWordViewModel]()
                
                for first in group1 {
                    for item in first {
                        var finishedX = [PlayWordViewModel]()
                        var finishedY = [PlayWordViewModel]()
                        for g in group1 {
                            let rowX = g.first(where: {$0.viewModel.x == item.viewModel.x && !finishedX.contains($0.viewModel) }).map{$0.viewModel}
                            let rowY = g.first(where: {$0.viewModel.y == item.viewModel.y && !finishedY.contains($0.viewModel) }).map{$0.viewModel}
                            if let rowX = rowX {
                                finishedX.append(rowX)
                            }
                            if let rowY = rowY {
                                finishedY.append(rowY)
                            }
                        }
                        
                        if finishedX.count > finishedMaxX.count {
                            finishedMaxX = finishedX
                        }
                        if finishedY.count > finishedMaxY.count {
                            finishedMaxY = finishedY
                        }
                        
                    }
                }
                
//                print("x:", finishedMaxX.count, finishedMaxX)
//                print("y:", finishedMaxY.count, finishedMaxY)
                
                if finishedMaxX.count > finishedMaxY.count {
                    // x相同
                    let sorted = finishedMaxX.sorted(by: {$0.y < $1.y})
                    let minY = sorted[0].y
                    let maxY = sorted.last!.y
                    
                    var startY = minY - 1
                    if startY < 0 {
                        startY = 0
                    }
                    var endY = maxY + 1
                    if endY >= playModel.height {
                        endY = maxY
                    }
                    
                    let range = (startY...endY).map{$0}
                    let sameX = sorted[0].x
                    for y in range {
                        let yItem = items.first { ite -> Bool in
                            ite.viewModel.y == y && ite.viewModel.x == sameX && (ite.viewModel.type.value != .empty)
                        }
                        if let yItem = yItem {
                            if finishedMaxX.contains(yItem.viewModel) {
                                continue
                            }
                            finishedMaxX.append(yItem.viewModel)
                        }
                    }
                    
                    if finishedMaxX.count == ch.charactersArray.count {
                        let finishSorted = finishedMaxX.sorted(by: {$0.y < $1.y})
                        let groupViewModel = PlayGroupViewModel(items: finishSorted, text: ch)
                        finishSorted.forEach{ $0.groupViewModel.append(groupViewModel) }
                        group.append(groupViewModel)
                        rightCh.append(ch)
                        break
                    }
                    
                } else {
                    // y相同
                    let sorted = finishedMaxY.sorted(by: {$0.x < $1.x})
                    let minX = sorted[0].y
                    let maxX = sorted.last!.y
                    
                    var startX = minX - 1
                    if startX < 0 {
                        startX = 0
                    }
                    var endX = maxX + 1
                    if endX >= playModel.width {
                        endX = maxX
                    }
                    
                    let range = (startX...endX).map{$0}
                    let sameY = sorted[0].x
                    for x in range {
                        let xItem = items.first { ite -> Bool in
                            ite.viewModel.y == sameY && ite.viewModel.x == x && (ite.viewModel.type.value != .empty)
                        }
                        if let xItem = xItem {
                            if finishedMaxY.contains(xItem.viewModel) {
                                continue
                            }
                            finishedMaxY.append(xItem.viewModel)
                        }
                    }
                    
                    if finishedMaxY.count == ch.charactersArray.count {
                        let finishSorted = finishedMaxY.sorted(by: {$0.y < $1.y})
                        let groupViewModel = PlayGroupViewModel(items: finishSorted, text: ch)
                        finishSorted.forEach{ $0.groupViewModel.append(groupViewModel) }
                        group.append(groupViewModel)
                        rightCh.append(ch)
                        break
                    }
                }
            }
        }
        
        let rights = group.filter { g -> Bool in
            let finished = g.items.filter{$0.type.value == .right || $0.type.value == .finish }
            return finished.count == g.items.count
        }
        rights.forEach { r in
            for (idx, item) in r.items.enumerated() {
                item.type.accept(.right)
                item.animation.accept((true, 0.1 * Float(idx)))
            }
        }
        group.removeAll(rights)
        
        selectRecentItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func selectRecentItem() {
        
        currentItem?.viewModel.selected.accept(false)
        
        if let current = currentItem {
            
            let groups = current.viewModel.groupViewModel
            var groupWrites = [PlayViewItem]()
            for g in groups {
                let writes = g.items.filter{$0.type.value == .write}
                let writesItem = items.filter{writes.contains($0.viewModel)}
                groupWrites.append(contentsOf: writesItem)
            }
            
            if groupWrites.count > 0 {
                groupWrites.forEach{ $0.viewModel.distance = pow(Float($0.viewModel.x - current.viewModel.x), 2) + pow(Float($0.viewModel.y - current.viewModel.y), 2)}
                let write = groupWrites.sorted { (a, b) -> Bool in
                    return a.viewModel.distance < b.viewModel.distance
                }
                if let first = write.first {
                    currentItem = first
                    currentItem?.viewModel.selected.accept(true)
                    return
                }
            }
            
            let writeItems = items.filter{$0.viewModel.type.value == .write}
            writeItems.forEach{ $0.viewModel.distance = pow(Float($0.viewModel.x - current.viewModel.x), 2) + pow(Float($0.viewModel.y - current.viewModel.y), 2)}
            let write = writeItems.sorted { (a, b) -> Bool in
                return a.viewModel.distance < b.viewModel.distance
            }
            if let first = write.first {
                currentItem = first
                currentItem?.viewModel.selected.accept(true)
                return
            }
            
        }
        
        let write = items.filter{$0.viewModel.type.value == .write}.sorted { (a, b) -> Bool in
            return a.viewModel.y < b.viewModel.y
        }.sorted { (a, b) -> Bool in
            return a.viewModel.x < b.viewModel.x
        }
        currentItem = write.first
        currentItem?.viewModel.selected.accept(true)
        
    }
    
    private func onClickItem(i: PlayViewItem) {
        if self.currentItem == i {
            let type = i.viewModel.type.value
            switch type {
            case .wait, .wrong:
                if let acceptVm = i.acceptViewModel {
                    i.viewModel.text.accept(nil)
                    i.viewModel.type.accept(.write)
                    self.pushAction?(acceptVm)
                }
            default:
                break
            }
        } else {
            self.currentItem?.viewModel.selected.accept(false)
            let type = i.viewModel.type.value
            switch type {
            case .wrong:
                if let acceptVm = i.acceptViewModel {
                    i.viewModel.text.accept(nil)
                    i.viewModel.type.accept(.write)
                    self.pushAction?(acceptVm)
                }
            default:
                break
            }
            self.currentItem = i
            self.currentItem?.viewModel.selected.accept(true)
        }
    }
    
    func getCurrentRightText() -> String? {
        
        if let c = currentItem {
            return c.viewModel.rightText
        }
        return nil
        
    }
    
    func clearWrongs() {
        items.filter { i -> Bool in
            let type = i.viewModel.type.value
            return type == .wrong
        }.forEach { i in
            if let ac = i.acceptViewModel {
                i.viewModel.text.accept(nil)
                i.viewModel.type.accept(.write)
                i.acceptViewModel = nil
                self.pushAction?(ac)
            }
        }
    }
    
    func accept(answer: PlayWordViewModel) {
        if let c = currentItem {
            if let acceptVm = c.acceptViewModel, acceptVm != answer {
                self.pushAction?(acceptVm)
            }
            c.acceptViewModel = answer
            c.viewModel.text.accept(answer.rightText)
            if c.viewModel.rightText == answer.rightText  {
                var isWait = true
                var isNeedAudio = false
                for g in c.viewModel.groupViewModel {
                    let notFinished = g.items.filter{$0 != c.viewModel}.filter({$0.type.value == .write || $0.type.value == .wrong || $0.type.value == .empty})
                    if notFinished.isEmpty {
                        for (idx, item) in g.items.enumerated() {
                            isWait = false
                            item.type.accept(.right)
                            item.animation.accept((true, 0.1 * Float(idx)))
                        }
                        isNeedAudio = true
                        rightGroupCount += 1
                    }
                }
                if isNeedAudio {
                    YBPlayAudio.successClick()
                }
                if rightGroupCount == group.count {
                    successAction?()
                } else {
                    if isWait {
                        c.viewModel.type.accept(.wait)
                    }
                    selectRecentItem()
                }
            } else {
                c.viewModel.type.accept(.wrong)
                var isNeedAudio = false
                for g in c.viewModel.groupViewModel {
                    let notFinished = g.items.filter{$0 != c.viewModel}.filter({$0.type.value == .write || $0.type.value == .empty})
                    if notFinished.isEmpty {
                        for item in g.items {
                            item.animation.accept((false, 0))
                        }
                        isNeedAudio = true
                    }
                }
                if isNeedAudio {
                    YBPlayAudio.failureClick()
                }
            }
        }
    }
}
