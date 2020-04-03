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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addInteraction(UIDropInteraction(delegate: self))
    }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: rect)
    }

}

 //MARK: - UIDropInteractionDelegate
extension EmojiArtView: UIDropInteractionDelegate {
 
    func dropInteraction(_ interaction: UIDropInteraction,
                         canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction,
                         sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction,
                         performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSAttributedString.self) { providers in
            let dropPoint = session.location(in: self)
            for attributedString in providers as? [NSAttributedString] ?? [] {
                self.addLabel(with: attributedString, centeredAt: dropPoint)
            }
        }
    }
    
    private func addLabel(with attributedString: NSAttributedString, centeredAt point: CGPoint) {
        let label = UILabel()
        label.backgroundColor = .clear
        label.attributedText = attributedString
        label.sizeToFit()
        label.center = point
        addEmojiArtGestureRecognizers(to: label)
        addSubview(label)
    }
    
}
