//
//  SingleStepTableViewController.swift
//  Final Challenge
//
//  Created by Geremia De Micco on 24/06/2018.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit
import SafariServices

class SingleStepTableViewController: UITableViewController, SFSafariViewControllerDelegate {

    var currentStep: Step?
    var delegate: MyCustomCellDelegator!

    //The following four lines of code defines the four color that will create the gradient for the background color
    let firstBackgroundColor = UIColor(red: 1, green: 247/255, blue: 68/255, alpha: 0.8 * 0.59)
    let secondBackgroundColor = UIColor(red: 1, green: 153/255, blue: 68/255, alpha: 0.7 * 0.59)
    let thirdBackgroundColor = UIColor(red: 252/255, green: 96/255, blue: 118/255, alpha: 1 * 0.41)
    let fourthBackgroundColor = UIColor(red: 253/255, green: 107/255, blue: 179/255, alpha: 1 * 0.41)

    override func viewDidLoad() {
        super.viewDidLoad()

        currentStep = CurrentData.shared.currentSingleStep
        //General settings
        self.navigationController?.navigationBar.prefersLargeTitles = true //display large title
        self.title = currentStep?.title

        setTableViewBackgroundGradient(sender: self, firstBackgroundColor, secondBackgroundColor, thirdBackgroundColor, fourthBackgroundColor) //It sets the background color
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (currentStep?.nodes.count)!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleNodeInSingleStepID", for: indexPath) as! SingleNodeTableViewCell

        cell.title.text = currentStep?.nodes[indexPath.section].title
        cell.numberOfArticleLeft.text = "\((currentStep?.nodes.count)!) Article Left"
        cell.numberOfMinutesLeft.text = "\((currentStep?.nodes.count)!*20) Min Left"
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134  //global Constant
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5   //global Constant
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentURL = currentStep?.nodes[indexPath.section].url
        let urlModified = URL(string: "http://\(currentURL)")
        openSafariViewController(url: urlModified!)
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
