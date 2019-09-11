//
//  CollectionViewCell.swift
//  CollectionViewDemo
//
//  Created by Spctn on 9/9/19.
//  Copyright © 2019 idocnet. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var imageMain: UIImageView!
    @IBOutlet weak var lblState: UILabel!
    
    var park: Park? {
        didSet {
            if let park = park {
                imageMain.image = UIImage(named: park.photo)
                lblState.text = park.name
            }
        }
    }
    
    var isEditing: Bool = false {
        didSet {
            imgCheck.isHidden = !isEditing
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isEditing {
                imgCheck.image = isSelected ? UIImage(named: "Checked") : UIImage(named: "Unchecked")
            }
        }
    }
}
