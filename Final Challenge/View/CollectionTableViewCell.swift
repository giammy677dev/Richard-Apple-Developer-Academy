//
//  CollectionTableViewCell.swift
//  Final Challenge
//
//  Created by Geremia De Micco on 22/05/18.
//

/*
 Prior to calling the dequeueReusableCellWithReuseIdentifier:forIndexPath: method of the collection view, you must use this method or the registerClass:forCellWithReuseIdentifier: method to tell the collection view how to create a new cell of the given type. If a cell of the specified type is not currently in a reuse queue, the collection view uses the provided information to create a new cell object automatically.
 If you previously registered a class or nib file with the same reuse identifier, the object you specify in the nib parameter replaces the old entry. You may specify nil for nib if you want to unregister the nib file from the specified reuse identifier.
 */

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    class var customCell : CustomCollectionViewCell {
        let cell = Bundle.main.loadNibNamed("CustomCollectionViewCell", owner: self, options: nil)?.last
        return cell as! CustomCollectionViewCell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //register the xib for collection view cell
        let cellNib = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension CollectionTableViewCell: UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5    //numbers of Roadmaps in Recent
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1    //number of horizontal row
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell
        
        print("Cell")
        return cell!
    }
    
}

extension CollectionTableViewCell: UICollectionViewDelegate{
    
    
    
}

extension CollectionTableViewCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 140, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: 20, height: 10)
    }
}

