//
//  DataSource.swift
//  CollectionViewDemo
//
//  Created by Spctn on 9/10/19.
//  Copyright © 2019 idocnet. All rights reserved.
//

import Foundation

class DataSource {
    private var parks = [Park]()
    private var immutableParks = [Park]()
    private var sections = [String]()
    
    var count: Int {
        return parks.count
    }
    
    var numberOfSections: Int {
        return sections.count
    }
    
    init() {
        parks = loadParksFromDisk()
        immutableParks = parks
    }
    
    public func parkForItemAtIndexPath(_ indexPath: IndexPath) -> Park? {
        return parks[indexPath.item]
    }
    
    public func numberParkOfSection(section: Int) -> Int {
        return parksForSection(section).count
    }
    
    public func parkForSectionAtIndexPath(_ indexPath: IndexPath) -> Park? {
        return parksForSection(indexPath.section)[indexPath.row]
    }
    
    public func titleSectionAtIndexPath(_ indexPath: IndexPath) -> String {
        return parksForSection(indexPath.section)[indexPath.row].state
    }
    
    public func sectionAtIndexPath(_ indexPath: IndexPath) -> Section {
        let section = Section()
        let parks = parksForSection(indexPath.section)
        section.count = parks.count
        section.title = sections[indexPath.section]
        
        return section
    }
    
    public func indexPathForNewItemRandom() -> IndexPath {
        let index = Int.random(in: 0 ... immutableParks.count - 1)
        let parkCopy = immutableParks[index]
        let newPark = Park(copying: parkCopy)
        parks.append(newPark)
        parks.sort { (p1, p2) -> Bool in
            return p1.index < p2.index
        }
        
        return indexPathForPath(newPark)
    }
    
    public func indexPathForPath(_ park: Park) -> IndexPath {
        let section = sections.firstIndex(of: park.state)!
        var item = 0
        
        for (index, currentPark) in parksForSection(section).enumerated(){
            if currentPark === park {
                item = index
                break
            }
        }
        
        return IndexPath(row: item, section: section)
        
    }
    
    public func deleteParksAtIndexPaths(indexPaths: [IndexPath]) {
        var indexs = [Int]()
        
        for indexPath in indexPaths {
            indexs.append(absoluteIndexForIndexPath(indexPath))
        }
        
        var newParks = [Park]()
        for (index, currentParks) in parks.enumerated() {
            if !indexs.contains(index) {
                newParks.append(currentParks)
            }
        }
        
        parks = newParks
    }
    
    public func moveParkAtIndexPath(_ indexPath: IndexPath, toIndexPath newIndexPath: IndexPath) {
        if indexPath == newIndexPath {
            return
        }
        
        let index = absoluteIndexForIndexPath(indexPath)
        let newPark = parks[index]
        newPark.state = sections[newIndexPath.section]
        let newIndex = absoluteIndexForIndexPath(newIndexPath)
        
        parks.remove(at: index)
        parks.insert(newPark, at: newIndex)
    }
    
    private func loadParksFromDisk() -> [Park] {
        sections.removeAll(keepingCapacity: false)
        if let path = Bundle.main.path(forResource: "NationalParks", ofType: "plist") {
            if let dictArray = NSArray(contentsOfFile: path) {
                var nationalParks: [Park] = []
                for item in dictArray {
                    if let dict = item as? NSDictionary {
                        let name = dict["name"] as! String
                        let state = dict["state"] as! String
                        let date = dict["date"] as! String
                        let photo = dict["photo"] as! String
                        let index = dict["index"] as! Int
                        let park = Park(name: name, state: state, date: date, photo: photo, index: index)
                        if !sections.contains(state) {
                            sections.append(state)
                        }
                        
                        nationalParks.append(park)
                    }
                }
                
                return nationalParks
            }
        }
        
        return []
    }
    
    private func absoluteIndexForIndexPath(_ indexPath: IndexPath) -> Int{
        var index = 0
        
        for i in 0..<indexPath.section {
            index += numberParkOfSection(section: i)
        }
        
        index += indexPath.item
        
        return index
    }
    
    private func parksForSection(_ index: Int) -> [Park] {
        let section = sections[index]
        let parksOfSection = parks.filter{ (park: Park) -> Bool in
            return park.state == section
        }
        
        return parksOfSection
    }
}

