//
//  ShareViewController.swift
//  SafariExt
//
//  Created by Andrea Belcore on 19/06/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit
import Social

class NewShareViewController: SLComposeServiceViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        print(self.textView.text!)
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.

        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
