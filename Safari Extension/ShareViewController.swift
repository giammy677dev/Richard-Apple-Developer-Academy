//
//  ShareViewController.swift
//  Safari Extension
//
//  Created by Gian Marco Orlando on 17/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
   
    private var url: NSURL?
    private var text: String?
    private var wordCount: Int?{
        return (text?.words.count)
    }
    
    private var userDecks = [RoadmapSE]()
    private let boilerPipeAPIURLString = "https://boilerpipe-web.appspot.com/extract?extractor=ArticleExtractor&output=json&extractImages=&token=&url="
    fileprivate var selectedRoadmap: RoadmapSE?
    private var boilerPipeAnswer = BoilerpipeAnswer()
    private var fetchedFromBoilerPipe: Bool = false
    

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getURLAndText()
        
        for i in 1...3 {
            let roadmap = RoadmapSE()
            roadmap.title = "Roadmaps \(i)"
            userDecks.append(roadmap)
        }
        selectedRoadmap = userDecks.first
        
    }

    private func setupUI() {
        let imageView = UIImageView(image: UIImage(named: "vurb-icon-rounded"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        navigationController?.navigationBar.topItem?.titleView = imageView
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = UIColor(red:0.97, green:0.44, blue:0.12, alpha:1.00)
    }

    private func getURLAndText() {
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        let propertyList = String(kUTTypePropertyList)
        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, error) -> Void in
                guard let dictionary = item as? NSDictionary else { return }
                OperationQueue.main.addOperation {
                    let manager = NetworkManager()
                    if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                        let urlString = results["URL"] as? String,
                        let pageText = results["Text"] as? String,
                        let url = NSURL(string: urlString) {
                        
                            self.url = url
                            self.text = pageText
                            manager.httpRequest(url:URL(string: (self.boilerPipeAPIURLString)+(self.url?.absoluteString!)!)!, dataHandlerOnCompletion: {
                                (data) in
                                self.boilerPipeAnswer.extractFromData(data)
                                if(self.boilerPipeAnswer.status == "success"){
                                    self.fetchedFromBoilerPipe = true
                                    self.text = self.boilerPipeAnswer.response.content
                                }
                            } )
                        
                            print("[RawCount]" + "\(pageText.words.count)")
                    }
                }
            })
        } else {
            print("error")
        }
    }
    
    

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.

        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        if let deck = SLComposeSheetConfigurationItem() {
            deck.title = "Selected Roadmap"
            deck.value = selectedRoadmap?.title
            deck.tapHandler = {
                let vc = ShareSelectViewController()
                vc.userDecks = self.userDecks
                vc.delegate = self
                self.pushConfigurationViewController(vc)
            }
            return [deck]
        }
        return nil
    }
}

extension ShareViewController: ShareSelectViewControllerDelegate {
    
    func selected(roadmap: RoadmapSE) {
        selectedRoadmap = roadmap
        reloadConfigurationItems()
        popConfigurationViewController()
    }
}
