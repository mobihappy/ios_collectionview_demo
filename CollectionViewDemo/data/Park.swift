//
//  Park.swift
//  CollectionViewDemo
//
//  Created by Spctn on 9/10/19.
//  Copyright © 2019 idocnet. All rights reserved.
//

import Foundation

class Park {
    var name: String
    var state: String
    var date: String
    var photo: String
    var index: Int
    
    init(name: String, state: String, date: String, photo: String, index: Int) {
        self.name = name
        self.state = state
        self.date = date
        self.photo = photo
        self.index = index
    }
    
    convenience init (copying park: Park){
        self.init(name: park.name, state: park.state, date: park.date, photo: park.photo, index: park.index)
    }
}
