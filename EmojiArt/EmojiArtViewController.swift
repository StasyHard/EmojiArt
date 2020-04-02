//
//  ViewController.swift
//  EmojiArt
//
//  Created by Anastasia Reyngardt on 01.04.2020.
//  Copyright © 2020 GermanyHome. All rights reserved.
//

import UIKit

class EmojiArtViewController: UIViewController, UIDropInteractionDelegate {

    @IBOutlet weak var dropZone: UIView! {
        didSet {
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    @IBOutlet weak var emojiArtView: EmojiArtView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

