//
//  ResourcesCollectionTableViewCell.swift
//  Final Challenge
//
//  Created by Geremia De Micco on 23/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

class ResourcesCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    class var customCell : ResourcesCustomCollectionViewCell {
        let cell = Bundle.main.loadNibNamed("ResourcesCustomCollectionViewCell", owner: self, options: nil)?.last
        return cell as! ResourcesCustomCollectionViewCell
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //register the xib for collection view cell
        let cellNib = UINib(nibName: "ResourcesCustomCollectionViewCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "ResourcesCustomCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension ResourcesCollectionTableViewCell: UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5    //numbers of Roadmaps in Recent
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1    //number of horizontal row
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResourcesCustomCollectionViewCell", for: indexPath) as? ResourcesCustomCollectionViewCell
        
        print("Cell")
        return cell!
    }
    
}

extension ResourcesCollectionTableViewCell: UICollectionViewDelegate{
    
    
    
}

extension ResourcesCollectionTableViewCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 140, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: 20, height: 10)
    }
}
