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

    var delegate: MyCustomCellDelegator!
    var category: Int = 0
    var newTargetOffset: Float = 0
    var cellWidth: Float = 240
    var footerWidth: Float = 35
    var pageOffset: [Float] = []
    var currentPage = 0
    var lastOffset: Float = 0
    var numberMaxOfRoadmapsInPreview = 4
    var numberOfRoadmapsInPreview = 0
    var firstTime: Bool = true
    var seeAllFirstTime: Bool = true
    var doNothing: Bool = false
    var swipe: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()

        for i in 0...numberMaxOfRoadmapsInPreview {
            if i == 0 {
                self.pageOffset.append(Float(i)*cellWidth)
            } else {
                self.pageOffset.append(Float(i)*cellWidth + Float(i-1)*footerWidth)
            }
        }
        for elem in self.pageOffset {
            print("\(elem)")
        }

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 240, height: 159)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0  //between row

        collectionView.setCollectionViewLayout(layout, animated: false)

        //register the xib for collection view cell
        let cellNib = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "CustomCollectionViewCell")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension CollectionTableViewCell: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        numberOfRoadmapsInPreview = CurrentData.shared.roadmapsInCategories[Category(rawValue: Int16(self.category))!]!
        return numberOfRoadmapsInPreview //numbers of roadmpas in Category
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1    //number of horizontal row
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell

        cell?.titleLabel.text = CurrentData.shared.roadmapsForCategory(category: Category(rawValue: Int16(self.category))!).safeCall(indexPath.section)?.title

        //zoom first cell at first start
        if indexPath.section == 0 && currentPage == 0 {
            print("First cell zoomed")
            cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }

        //custom SEEALL as last cell in collection
        if indexPath.section == 4 {
            cell?.linkLabel.isHidden = true
            cell?.titleLabel.isHidden = true
            cell?.minutesLeftLabel.isHidden = true
            cell?.seeAllLbl.isHidden = false
        } else {
            cell?.linkLabel.isHidden = false
            cell?.titleLabel.isHidden = false
            cell?.minutesLeftLabel.isHidden = false
            cell?.seeAllLbl.isHidden = true
        }

//        print("Section = \(indexPath.section)")

        return cell!
    }

    override func prepareForReuse() {
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == numberMaxOfRoadmapsInPreview {  //See All Cell
            self.delegate.callSegueFromCell(identifier: "SeeAllSegue")
        }
    }

}

extension CollectionTableViewCell: UICollectionViewDelegate {
}

extension CollectionTableViewCell: UIScrollViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let widthSwipe: Float = Float(scrollView.contentOffset.x)

        print("\n\nwidthSwipe = \(widthSwipe) è > di = \(self.pageOffset[currentPage])")
        print("a quale pagina ero prima? : \(currentPage)")

        if widthSwipe > self.pageOffset[currentPage] {  //right swipe
            print("RIGHT SWIPE")
            swipe = true
            if currentPage < numberMaxOfRoadmapsInPreview {
                if currentPage == numberOfRoadmapsInPreview - 1 {

                } else {
                    currentPage = currentPage + 1
                    newTargetOffset = self.pageOffset[currentPage]
                }
            }
        } else if currentPage == numberOfRoadmapsInPreview - 1 {   //left swipe
            print("Tentativo di Left SWIPE")
            if (widthSwipe + 40) < self.pageOffset[currentPage] {
                print("Tentativo di Left SWIPE RIUSCITO!")
                swipe = true
                doNothing = false
                currentPage = currentPage - 1
                newTargetOffset = self.pageOffset[currentPage]
            }

        } else if widthSwipe < self.pageOffset[currentPage] {   //left swipe
            print("LEFT SWIPE")
            swipe = true
            if currentPage > 0 {
                doNothing = false
                currentPage = currentPage - 1
                newTargetOffset = self.pageOffset[currentPage]
            }
        }

        if swipe {
            swipe = false
            print("Ora sono alla pagina: \(currentPage)")
            print("NewOffset: \(newTargetOffset)")
            if currentPage == numberOfRoadmapsInPreview - 1 {
                newTargetOffset = newTargetOffset - footerWidth
            }

            targetContentOffset.pointee.x = CGFloat(widthSwipe)
            scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: scrollView.contentOffset.y), animated: true)

            if !doNothing {
                print("velocity: \(velocity)\n\n")

                for i in 0...numberMaxOfRoadmapsInPreview {
                    if i == Int(self.currentPage) {
                        UIView.animate(withDuration: 0.4, animations: {
                            let cell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: i))
                            cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                        }, completion: nil)

                    } else {
                        UIView.animate(withDuration: 0.4, animations: {
                            let cell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: i))
                            cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
                        }, completion: nil)
                    }
                }

            } else {
                UIView.animate(withDuration: 0.4, animations: {
                    let cell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: self.numberMaxOfRoadmapsInPreview))
                    cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }, completion: nil)
                UIView.animate(withDuration: 0.4, animations: {
                    let cell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: self.numberMaxOfRoadmapsInPreview - 1))
                    cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
                doNothing = false
            }
            if currentPage == numberOfRoadmapsInPreview - 1 {
                print("DO NOTHING")
                doNothing = true
            }
        }
    }

}

extension CollectionTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: 159)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        if section == 0 {
            return CGSize(width: 34, height: 159)
        } else {
            return CGSize(width: 0, height: 159)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 35, height: 159)
    }

}
