//
//  MenuController.swift
//  GmailDemo
//
//  Created by Suman on 25/09/21.
//

import UIKit

class MenuController: UIViewController {
    @IBOutlet var tableView: UITableView!
    private var menuOptions: [String] = ["All Matches", "Saved Matches"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 70
    }
}

extension MenuController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell.textLabel?.text = menuOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NetworkManager.shared.selectedMenuIndex = indexPath.row
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .matchesChangedNotification, object: nil)
        }
    }
}
