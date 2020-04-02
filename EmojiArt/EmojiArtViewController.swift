//
//  ViewController.swift
//  EmojiArt
//
//  Created by Anastasia Reyngardt on 01.04.2020.
//  Copyright © 2020 GermanyHome. All rights reserved.
//

import UIKit

class EmojiArtViewController: UIViewController  {

     //MARK: - IBOutlets
    @IBOutlet weak var dropZone: UIView! {
        didSet {
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(emojiArtView)
        }
    }
    
    @IBOutlet weak var emogiCollectionView: UICollectionView! {
        didSet {
            emogiCollectionView.dataSource = self
            emogiCollectionView.delegate = self
        }
    }
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
     //MARK: - Properties
    var emojiArtView = EmojiArtView()
    var imageFetcher: ImageFetcher!
    var emojiArtBackgroundImage: UIImage? {
        get {
            return emojiArtView.backgroundImage
        }
        set {
            scrollView?.zoomScale = 1.0
            emojiArtView.backgroundImage = newValue
            let size = newValue?.size ?? CGSize.zero
            emojiArtView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView?.contentSize = size
            scrollViewHeight?.constant = scrollView.contentSize.height
            scrollViewWidth?.constant = scrollView.contentSize.width
            if let dropZone = self.dropZone, size.width > 0, size.height > 0 {
                scrollView?.zoomScale = max(dropZone.bounds.size.width / size.width, dropZone.bounds.size.height / size.height)
            }
        }
    }
    
    var emojis = "🐒🦆🐝🦋🐌🐢🦎🦍🐆🌞🌻🌧❄️⚽️🐥".map { String($0) }
    
}

 //MARK: - UIScrollViewDelegate
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
                self.emojiArtBackgroundImage = image
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

 //MARK: - UIScrollViewDelegate
extension EmojiArtViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return emojiArtView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeight.constant = scrollView.contentSize.height
        scrollViewWidth.constant = scrollView.contentSize.width
    }
}

extension EmojiArtViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
        
        return cell
    }
    
     //MARK: - UICollectionViewDelegate

    //MARK: - UICollectionViewDelegateFlowLayout
    
}


