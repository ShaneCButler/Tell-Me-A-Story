//
//  StickerCollectionViewController.swift
//  Tell me a Story
//
//  Created by Shane Butler on 16/03/2018.
//  Copyright © 2018 Shane Butler. All rights reserved.
//

import UIKit

protocol StickerCollectionViewControllerDelegate: class {
    func pickedSticker(_ stickerCollectionViewController: StickerCollectionViewController)
}

class StickerCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var emojiList: [[String]] = []
    var selectedItem: String!
    
    let emojiRanges = [
        0x1F601...0x1F64F,
        0x1F600...0x1F636,
        0x2702...0x27B0,
        0x1F680...0x1F6C0,
        0x1F170...0x1F251
    ]
    
    var emojis: [String] = []
    weak var delegate: StickerCollectionViewControllerDelegate?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        for range in emojiRanges {
            for i in range {
                let c = String(describing: UnicodeScalar(i)!)
                emojis.append(c)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        
        let Button = cell.viewWithTag(1) as! UILabel
        Button.text = emojis[indexPath.row]
        
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = emojis[indexPath.item]
        self.delegate?.pickedSticker(self)
        dismiss(animated: true, completion: nil)
        
    }

}

