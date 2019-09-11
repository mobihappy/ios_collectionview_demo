//
//  ViewController.swift
//  CollectionViewDemo
//
//  Created by Spctn on 9/9/19.
//  Copyright © 2019 idocnet. All rights reserved.
//

import UIKit

class MainViewController: UICollectionViewController {
    @IBOutlet private weak var btnAdd: UIBarButtonItem!
    @IBOutlet private weak var btnDelete: UIBarButtonItem!
    
    private let dataSource = DataSource()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (view.frame.size.width - 4) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        layout.sectionHeadersPinToVisibleBounds = true
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        collectionView.refreshControl = refresh
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationController?.isToolbarHidden = true
        
        installsStandardGestureForInteractiveMovement = true
      
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        btnAdd.isEnabled = !editing
        collectionView.indexPathsForSelectedItems?.forEach({ (indexPath) in
            collectionView.deselectItem(at: indexPath, animated: true)
            })
        collectionView.allowsMultipleSelection = editing
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            cell.isEditing = editing
        }
        
        btnDelete.isEnabled = editing
        
        if !isEditing{
            navigationController?.isToolbarHidden = true
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            if let detailViewController = segue.destination as? DetailViewController {
//                if let cell = sender as? UICollectionViewCell {
//                    if let indexPath = collectionView.indexPath(for: cell){
//                        detailViewController.data = collectionData[indexPath.row]
//                    }
//                }
                
//                if let indexPath = collectionView.indexPathsForSelectedItems?.first {
//                   detailViewController.data = collectionData[indexPath.row]
//                }
                
                if let indexPath = sender as? IndexPath {
                    detailViewController.park = dataSource.parkForSectionAtIndexPath(indexPath)
                }
            }
        }
    }
    
    @IBAction private func addItem() {
//        collectionView.performBatchUpdates({
//            for _ in 0..<2 {
//                let text = "\(collectionData.count + 1) 🌱"
//                collectionData.append(text)
//                let indexPaths = [IndexPath(row: collectionData.count - 1, section: 0)]
//                collectionView.insertItems(at: indexPaths)
//            }
//        }, completion: nil)
        
        let indexPath = dataSource.indexPathForNewItemRandom()
        collectionView.insertItems(at: [indexPath])
        
    }
    
    @IBAction private func deleteSelects() {
        if let indexPaths = collectionView.indexPathsForSelectedItems {
            dataSource.deleteParksAtIndexPaths(indexPaths: indexPaths)
            collectionView.reloadData()
        }
    }
    
    @objc private func refresh(){
        addItem()
        collectionView.refreshControl?.endRefreshing()
    }
    
}

extension MainViewController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberParkOfSection(section: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.park = dataSource.parkForSectionAtIndexPath(indexPath)
        cell.isEditing = isEditing
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            performSegue(withIdentifier: "ShowDetailSegue", sender: indexPath)
        }else {
            navigationController?.isToolbarHidden = false
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isEditing {
            if let items = collectionView.indexPathsForSelectedItems, items.count == 0 {
                navigationController?.isToolbarHidden = true
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader
        
        cell.section = dataSource.sectionAtIndexPath(indexPath)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataSource.moveParkAtIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
        collectionView.reloadData()
    }
}


