//
//  ExtensionViewController.swift
//  SafariExt
//
//  Created by Andrea Belcore on 20/06/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

@objc (ExtensionShareViewController)
class ExtensionShareViewController: UIViewController {

    var isUserEditingContent = false
    let DBInterface = DatabaseInterface.shared
    weak var resourceToSave: Node?

    @IBOutlet weak var savedLinkView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mainCycle()
        getData()

        // Do any additional setup after loading the view.
    }

    func getData() {
        // TODO: Gather data from the page and put it in the node
    }

    @IBAction func editDetails(_ sender: Any) {
        isUserEditingContent = true
        // TODO: Show the view to edit node data, edit data and then dismiss+save
    }

    func dismissSaveAction() {
        //extensionContext!.cancelRequest(withError: NSError())
        // TODO: Save the current node

        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {self.savedLinkView.alpha = CGFloat(0)}, completion: {(_) in self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)}
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mainCycle() {
        savedLinkView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .curveEaseOut],
                       animations: {self.savedLinkView.alpha = CGFloat(1)},
                       completion: {(_) in DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                        if (!self.isUserEditingContent) {
                            self.dismissSaveAction()
                        }

                       })

        })
        savedLinkView.layer.cornerRadius = 8
        savedLinkView.clipsToBounds = true
        savedLinkView.layer.shadowPath = UIBezierPath(roundedRect: savedLinkView.bounds, cornerRadius: savedLinkView.layer.cornerRadius).cgPath
        savedLinkView.layer.shadowColor = UIColor.black.cgColor
        savedLinkView.layer.shadowOpacity = 0.5
        savedLinkView.layer.shadowOffset = CGSize(width: 0, height: 0)
        savedLinkView.layer.shadowRadius = 10
        savedLinkView.layer.masksToBounds = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
