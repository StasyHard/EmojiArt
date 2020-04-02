//
//  EmogiArtView.swift
//  EmojiArt
//
//  Created by Anastasia Reyngardt on 02.04.2020.
//  Copyright © 2020 GermanyHome. All rights reserved.
//

import UIKit

class EmojiArtView: UIView {

    var backgroundImage: UIImage? { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: rect)
    }

}
