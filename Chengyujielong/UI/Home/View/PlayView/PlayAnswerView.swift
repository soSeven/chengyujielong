//
//  PlayAnswerView.swift
//  Chengyujielong
//
//  Created by liqi on 2020/10/9.
//  Copyright © 2020 Kaka. All rights reserved.
//

import UIKit

class PlayAnswerView: UIView {
    
    let playModel: PlayModel
    var didClickItem: ((PlayWordViewModel) -> ())?
    private var items = [PlayViewItem]()

    init(playModel: PlayModel) {
        self.playModel = playModel
        super.init(frame: .zero)
        setup()
    }
    
    func setup() {
        
//        backgroundColor = .systemPink
        
//        let originScaleWidth = playModel.maxWidth / (CGFloat(playModel.width) * (playModel.itemWidth) + CGFloat(playModel.width - 1) * (playModel.margin))
//        let originScaleHeight = playModel.maxHeight / (CGFloat(playModel.height) * (playModel.itemWidth) + CGFloat(playModel.width - 1) * (playModel.margin))
//        let originScale = CGFloat.minimum(originScaleWidth, originScaleHeight)
        
        let margin = playModel.margin
        var startX: CGFloat = 0
        var startY: CGFloat = 0
        let width = playModel.itemWidth
        let height = playModel.itemWidth
        var maxRow = 2
        for (idx, word) in playModel.answer.enumerated() {
            let y = idx / playModel.width
            let x = idx % playModel.width
            startX = CGFloat(x) * (margin + width)
            startY = CGFloat(y) * (margin + height)
            let item = PlayViewItem(scale: playModel.originScale)
            item.didClickItem = {[weak self] i in
                guard let self = self else { return }
                YBPlayAudio.writeClick()
                self.didClickItem?(i.viewModel)
                i.isHidden = true
            }
            item.viewModel.x = x
            item.viewModel.y = y
            item.width = width
            item.height = height
            item.x = startX
            item.y = startY
            item.viewModel.rightText = playModel.word[word]
            item.viewModel.type.accept(.read)
            item.viewModel.text.accept(playModel.word[word])
            addSubview(item)
            items.append(item)
            if y + 1 > maxRow {
                maxRow = y + 1
            }
        }
        
        self.height = height * CGFloat(maxRow) + margin * CGFloat(maxRow - 1)
        self.width = CGFloat(playModel.width) * (margin + width) - margin
        self.x = (playModel.maxWidth - self.width)/2.0
        self.y = playModel.maxHeight - self.height
    }
    
    func accept(model: PlayWordViewModel) {
        items.filter{$0.viewModel == model}.forEach{$0.isHidden = false}
    }
    
    func item(with text: String) -> PlayWordViewModel? {
        for i in items {
            if i.viewModel.rightText == text {
                i.isHidden = true
                return i.viewModel
            }
        }
        return nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
