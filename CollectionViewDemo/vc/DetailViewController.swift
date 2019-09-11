//
//  DetailViewController.swift
//  CollectionViewDemo
//
//  Created by Spctn on 9/9/19.
//  Copyright © 2019 idocnet. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var imgMain: UIImageView!

    var park: Park?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let park = park {
            lblData.text = park.name
            imgMain.image = UIImage(named: park.photo)
        }
    }

}
