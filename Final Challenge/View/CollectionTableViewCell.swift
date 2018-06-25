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
import SafariServices

class CollectionTableViewCell: UITableViewCell, SFSafariViewControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    //setup properties:
    var delegate: MyCustomCellDelegator!
    var newTargetOffset: Float = 0
    var cellWidth: Float = 240
    var footerWidth: Float = 35
    var pageOffset: [Float] = []
    var currentPage = 0
    var lastOffset: Float = 0
    var doNothing: Bool = false
    var swipe: Bool = false
    var numberMaxOfElemInPreview = 4

    //roadmaps properties:
    var category: Int = 0
    var numberOfRoadmapsInPreview = 0

    //resources properties:
    var currentTag: String = ""
    var numberOfResourcesInPreview = 0

    //switch
    var currentTabItem: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()

        for i in 0...numberMaxOfElemInPreview {
            if i == 0 {
                self.pageOffset.append(Float(i)*cellWidth)
            } else {
                self.pageOffset.append(Float(i)*cellWidth + Float(i-1)*footerWidth)
            }
        }
//        for elem in self.pageOffset {
//            print("\(elem)")
//        }

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

        numberOfRoadmapsInPreview = CurrentData.shared.roadmapsInCategories[Category(rawValue: Int16(self.category))!]!

        numberOfResourcesInPreview = CurrentData.shared.resourcesForTag(tag: self.currentTag).count

        if numberOfRoadmapsInPreview != 0 {
            currentTabItem = "Roadmaps"
        } else {
            currentTabItem = "Resources"
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension CollectionTableViewCell: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        numberOfRoadmapsInPreview = CurrentData.shared.roadmapsInCategories[Category(rawValue: Int16(self.category))!]!

        numberOfResourcesInPreview = CurrentData.shared.resourcesForTag(tag: self.currentTag).count

        if numberOfRoadmapsInPreview != 0 {
            print("numero di roadmaps: \(numberOfRoadmapsInPreview)")
            if numberOfRoadmapsInPreview > 5 {
                numberOfRoadmapsInPreview = 5
            }
            if numberOfRoadmapsInPreview > numberMaxOfElemInPreview {
                return numberMaxOfElemInPreview + 1
            }
            return numberOfRoadmapsInPreview //numbers of roadmpas in Category
        } else {
            print("numero di resources: \(numberOfResourcesInPreview)")
            if numberOfResourcesInPreview > 5 {
                numberOfResourcesInPreview = 5
            }
            if numberOfResourcesInPreview > numberMaxOfElemInPreview {
                return numberMaxOfElemInPreview + 1
            }
            return numberOfResourcesInPreview //numbers of roadmpas in Category
        }

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1    //number of horizontal row
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell

        if numberOfRoadmapsInPreview > 0 {
            cell?.titleLabel.text = CurrentData.shared.roadmapsForCategory(category: Category(rawValue: Int16(self.category))!).safeCall(indexPath.section)?.title
        } else {
            cell?.titleLabel.text = CurrentData.shared.resourcesForTag(tag: self.currentTag)[indexPath.section].title
        }

        //zoom first cell at first start
        if indexPath.section == 0 && currentPage == 0 {
//            print("First cell zoomed")
            cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }

        //custom SEEALL as last cell in collection
        if indexPath.section == 4 && currentTag != "Recent"{
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

        UIView.animate(withDuration: 0.4, animations: {
            let cell = self.collectionView.cellForItem(at: indexPath)
            cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)

        if numberOfRoadmapsInPreview > 0 {
            if indexPath.section == numberMaxOfElemInPreview {  //See All Cell
                self.delegate.callSegueFromCell(identifier: "SeeAllSegue")
            } else {
                CurrentData.shared.currentSingleRoadmap = CurrentData.shared.roadmapsForCategory(category: Category(rawValue: Int16(self.category))!)[indexPath.section]
                self.delegate.callSegueFromCell(identifier: "SingleRoadmapSegue")

            }
        } else {
            let currentURL = CurrentData.shared.resourcesForTag(tag: self.currentTag)[indexPath.section].url
            let urlModified = URL(string: "http://\(currentURL)")
            openSafariViewController(url: urlModified!)
        }
    }

    func openSafariViewController(url: URL) {
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false //when you scrolling down, the status bar collapse or not!

        let webSafariVC = SFSafariViewController(url: url, configuration: configuration)
        webSafariVC.preferredBarTintColor = UIColor(hex: 0xFFCB98)
        webSafariVC.preferredControlTintColor = UIColor.blue
        webSafariVC.dismissButtonStyle = .close //customize back button

        webSafariVC.delegate = self //ViewController become the Delegate, and from this moment the Delegator webSafariVC will can use the protocol implemented by the delegate ViewController
        self.delegate.callSVC(svc: webSafariVC)
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
            if currentPage < numberMaxOfElemInPreview {
                switch currentTabItem {
                case "Roadmaps":
                    if currentPage == numberOfRoadmapsInPreview  - 1 {

                    } else {
                        currentPage = currentPage + 1
                        newTargetOffset = self.pageOffset[currentPage]
                    }
                case "Resources":
                    if currentPage == numberOfResourcesInPreview  - 1 {

                    } else {
                        currentPage = currentPage + 1
                        newTargetOffset = self.pageOffset[currentPage]
                    }
                default:
                    print("[ERROR]: NO TABITEM")
                }

            }
        } else if currentPage == numberOfRoadmapsInPreview - 1 || currentPage == numberOfResourcesInPreview - 1 {   //left swipe Roadmaps
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
            if currentPage == numberOfRoadmapsInPreview  - 1 || currentPage == numberOfResourcesInPreview  - 1 {
                newTargetOffset = newTargetOffset - footerWidth
                print("ULTIMA PAG")
            }

            targetContentOffset.pointee.x = CGFloat(widthSwipe)
            scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: scrollView.contentOffset.y), animated: true)

            if !doNothing {
                print("velocity: \(velocity)\n\n")

                for i in 0...numberMaxOfElemInPreview {
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
                    let cell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: self.numberMaxOfElemInPreview))
                    cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }, completion: nil)
                UIView.animate(withDuration: 0.4, animations: {
                    let cell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: self.numberMaxOfElemInPreview - 1))
                    cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
                doNothing = false
            }
            if currentPage == numberOfRoadmapsInPreview  - 1 || currentPage == numberOfResourcesInPreview  - 1 {
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
