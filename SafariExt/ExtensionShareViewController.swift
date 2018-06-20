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
    @IBOutlet weak var savedLinkView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        savedLinkView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .curveEaseOut],
                       animations: {self.savedLinkView.alpha = CGFloat(1)},
                       completion: {(_) in DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                        if (!self.isUserEditingContent) {
                            self.dismissButtonTap()
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

        // Do any additional setup after loading the view.
    }
    func dismissButtonTap() {
        //extensionContext!.cancelRequest(withError: NSError())
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .curveEaseOut], animations: {self.savedLinkView.alpha = CGFloat(0)}, completion: nil)
        extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
