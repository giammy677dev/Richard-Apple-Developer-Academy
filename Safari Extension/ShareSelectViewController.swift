//
//  ShareSelectViewController.swift
//  Safari Extension
//
//  Created by Gian Marco Orlando on 17/05/18.
//  Copyright © 2018 Gian Marco Orlando. All rights reserved.
//

import UIKit

protocol ShareSelectViewControllerDelegate: class {
    func selected(roadmap: Roadmap)
}

class ShareSelectViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.RoadmapCell)
        return tableView
    }()
    var userDecks = [Roadmap]()
    weak var delegate: ShareSelectViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        title = "Select Roadmaps"
        view.addSubview(tableView)
    }
}

extension ShareSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDecks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.RoadmapCell, for: indexPath)
        cell.textLabel?.text = userDecks[indexPath.row].title
        cell.backgroundColor = .clear
        return cell
    }
}

extension ShareSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selected(roadmap: userDecks[indexPath.row])
    }
}

private extension ShareSelectViewController {
    struct Identifiers {
        static let RoadmapCell = "deckCell"
    }
}
