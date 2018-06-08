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
    var newTargetOffset: Float = 0
    var cellWidth: Float = 240
    var footerWidth: Float = 35
    var pageOffset: [Float] = []
    var currentPage = 0
    var lastOffset: Float = 0
    var firstTime = true
    var content: [Node] = [Node]()

    class var customCell: CustomCollectionViewCell {
        let cell = Bundle.main.loadNibNamed("CustomCollectionViewCell", owner: self, options: nil)?.last
        return cell as! CustomCollectionViewCell
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.pageOffset = [0, cellWidth, 2*cellWidth + footerWidth, 3*cellWidth + 2*footerWidth, 4*cellWidth + 3*footerWidth]

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 240, height: 159)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0  //between row

        collectionView.setCollectionViewLayout(layout, animated: false)

//        var longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
//        collectionView.addGestureRecognizer(longPressGesture)
//
        //register the xib for collection view cell
        let cellNib = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "CustomCollectionViewCell")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

//    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
//        switch(gesture.state) {
//
//        case .began:
//            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
//                break
//            }
//            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
//        case .changed:
//            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
//        case .ended:
//            collectionView.endInteractiveMovement()
//        default:
//            collectionView.cancelInteractiveMovement()
//        }
//    }

}

extension CollectionTableViewCell: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  content.count  //numbers of Nodes in Recent
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1    //number of horizontal row
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell

        cell?.linkLabel.text = content[indexPath.section].url.absoluteString
        cell?.titleLabel.text = content[indexPath.section].title
        cell?.minutesLeftLabel.text = "\(content[indexPath.section].extractedText.words.count / 270)"

        if indexPath.section == content.count - 1 {
            cell?.linkLabel.isHidden = true
            cell?.titleLabel.isHidden = true
            cell?.minutesLeftLabel.isHidden = true
            cell?.seeAllLbl.isHidden = false
        }

        if firstTime {
            if indexPath.section == 0 {
                cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
            firstTime = false
        }

        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 4 {  //See All Cell
            self.delegate.callSegueFromCell(identifier: "SeeAllSegue")
        }
    }

}

extension CollectionTableViewCell: UICollectionViewDelegate {
}

extension CollectionTableViewCell: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let pageWidth: Float =  20

        let widthSwipe: Float = Float(scrollView.contentOffset.x)
        let targetOffset: Float = Float(targetContentOffset.pointee.x)

        print("widthSwipe = \(widthSwipe)\ntargetOffset = \(targetOffset)")

        if widthSwipe > self.pageOffset[currentPage] + pageWidth {
            if currentPage < 4 {
                currentPage = currentPage + 1
                newTargetOffset = self.pageOffset[currentPage]
            }
        } else if widthSwipe < self.pageOffset[currentPage] - pageWidth {
            if currentPage > 0 {
                currentPage = currentPage - 1
                newTargetOffset = self.pageOffset[currentPage]
            }
        }
        targetContentOffset.pointee.x = CGFloat(widthSwipe)
        lastOffset = widthSwipe

        scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: scrollView.contentOffset.y), animated: true)

        print("velocity: \(velocity)")

        for i in 0...4 {
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
