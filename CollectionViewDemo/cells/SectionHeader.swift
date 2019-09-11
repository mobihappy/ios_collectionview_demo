//
//  SectionHeader.swift
//  CollectionViewDemo
//
//  Created by Spctn on 9/10/19.
//  Copyright © 2019 idocnet. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var imgState: UIImageView!
    @IBOutlet private weak var lblCount: UILabel!
    
    var section: Section? {
        didSet {
            lblTitle.text = section?.title
            imgState.image = UIImage(named: section?.title ?? "")
            lblCount.text = "\(section?.count ?? 0)"
            
        }
    }
    
    var title: String? {
        didSet {
            lblTitle.text = title
        }
    }
        
}
