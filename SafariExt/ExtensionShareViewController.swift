//
//  ExtensionShareViewController.swift
//  SafariExt
//
//  Created by Andrea Belcore on 20/06/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit
import MobileCoreServices

@objc (ExtensionShareViewController)
class ExtensionShareViewController: UIViewController {

    var isUserEditingContent = false
    var didUserEditContent = false
    let DBInterface = DatabaseInterface.shared
    weak var resourceToSave: Node?

    //Variables for data gathering
    private var url: NSURL?
    private var text: String?
    private var pageTitle: String?
    private let boilerPipeAPIURLString = "https://boilerpipe-web.appspot.com/extract?extractor=ArticleExtractor&output=json&extractImages=&token=&url="
    private var boilerPipeAnswer = BoilerpipeAnswer()
    private var fetchedFromBoilerPipe: Bool = false

    @IBOutlet weak var savedLinkView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mainCycle()
        getData()

        // Do any additional setup after loading the view.
    }

    @IBAction func editDetails(_ sender: Any) {
        isUserEditingContent = true
        // TODO: Show the view to edit node data, edit data and then dismiss+save
    }

    func dismissSaveAction() {
        //extensionContext!.cancelRequest(withError: NSError())
        // TODO: Save the current node
        DBInterface.save(resourceToSave!)

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

extension ExtensionShareViewController {

    func getData() {
        // TODO: Gather data from the page and put it in the node
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        let propertyList = String(kUTTypePropertyList)
        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, _) -> Void in
                guard let dictionary = item as? NSDictionary else { return }
                OperationQueue.main.addOperation {
                    let manager = NetworkManager()
                    if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                        let urlString = results["URL"] as? String,
                        let pageText = results["Text"] as? String,
                        let url = NSURL(string: urlString) {

                        self.url = url
                        self.text = pageText

                        do {
                            var content = try String(contentsOf: url as URL)
                            self.title = content.slice(from: "<title>", to: "</title>")
                        } catch let error {
                            //Error in title fetching
                            self.pageTitle = ""
                            print(error)
                        }

                        self.resourceToSave = Node(url: self.url as! URL, title: self.title!, id: DatabaseInterface.shared.createUniqueUUID(), parent: K.readingListStepID, tags: "#untagged", text: pageText, propExtracted: false, creationTime: Date(), propRead: false, propFlagged: false)

                        manager.httpRequest(url: URL(string: (self.boilerPipeAPIURLString)+(self.url?.absoluteString!)!)!, dataHandlerOnCompletion: {
                            (data) in
                            self.boilerPipeAnswer.extractFromData(data)

                            if(self.boilerPipeAnswer.status == "success") {
                                self.fetchedFromBoilerPipe = true
                                self.text = self.boilerPipeAnswer.response.content
                                self.resourceToSave?.extractedText = self.text!
                                self.resourceToSave?.isTextProperlyExtracted = true

                            }

                        })

                        print("[RawCount]" + "\(pageText.words.count)")
                    }
                }
            })
        } else {
            print("error")
        }
    }
}
