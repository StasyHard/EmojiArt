//
//  ViewController.swift
//  EmojiArt
//
//  Created by Anastasia Reyngardt on 01.04.2020.
//  Copyright © 2020 GermanyHome. All rights reserved.
//

import UIKit

class EmojiArtViewController: UIViewController  {

    @IBOutlet weak var dropZone: UIView! {
        didSet {
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    @IBOutlet weak var emojiArtView: EmojiArtView!
    
    var imageFetcher: ImageFetcher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension EmojiArtViewController: UIDropInteractionDelegate {
    
    //делегат выполняется только для изображений с url
    func dropInteraction(_ interaction: UIDropInteraction,
                         canHandle session: UIDropSession) -> Bool {
        return
            session.canLoadObjects(ofClass: NSURL.self) &&
            session.canLoadObjects(ofClass: UIImage.self)
    }
    
    //копирует изоброжение, которое попало в приложение
    func dropInteraction(_ interaction: UIDropInteraction,
                         sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                self.emojiArtView.backgroundImage = image
            }
        }
        session.loadObjects(ofClass: NSURL.self) { nsurls in
            if let url = nsurls.first as? URL {
                self.imageFetcher.fetch(url)
            }
        }
        
        session.loadObjects(ofClass: UIImage.self) { images in
            if let image = images.first as? UIImage {
                self.imageFetcher.backup = image
            }
        }
    }
    
}

