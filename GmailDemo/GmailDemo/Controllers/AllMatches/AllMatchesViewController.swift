//
//  AllMatchesViewController.swift
//  GmailDemo
//
//  Created by Suman on 25/09/21.
//

import UIKit
import MapKit
import SideMenu
import CoreData

class AllMatchesViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noDataLabel: UILabel!
    lazy var presenter = AllMatchesPresenter(self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.getAllMatches()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupView() {
        if let menu = storyboard?.instantiateViewController(withIdentifier: "MenuController") as? MenuController {
            let leftMenuNavigationController = SideMenuNavigationController(rootViewController: menu)
            leftMenuNavigationController.menuWidth = self.view.frame.width - 100
            leftMenuNavigationController.blurEffectStyle = .dark
            SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
        }
        
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        noDataLabel.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.matchesChangedNotification(notification:)), name: .matchesChangedNotification, object: nil)
    }
    
    @objc func matchesChangedNotification(notification: Notification) {
        self.title = NetworkManager.shared.selectedMenuIndex == 0 ? "All Matches" : "Saved Matches"
        self.tableView.reloadData()
        self.noDataLabel.isHidden = self.presenter.getMatchesData().count != 0
    }
    
    @IBAction func menuClicked(_ sender: Any) {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    private func openMap(lat: Double, long: Double, name: String) {
        let coordinate = CLLocationCoordinate2DMake(lat, long)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
}

extension AllMatchesViewController: AllMatchesDelegate {
    func updateMatchData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.noDataLabel.isHidden = self.presenter.getMatchesData().count != 0
        }
    }
    
    func finishWithError(_ error: String) {
        DispatchQueue.main.async {
            self.showAlert(message: error)
        }
    }
}

extension AllMatchesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getMatchesData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MatchesViewCell") as? MatchesViewCell {
            let venue = presenter.getMatchesData()[indexPath.row]
            cell.configureCell(venue)
            cell.favouriteClicked = {
                self.presenter.updateMatchesForFavourite(venue.venueId ?? "")
            }
            
            cell.locationClicked = {
                if let lat = venue.location?.lat, let lng = venue.location?.lng, lat != 0.0, lng != 0.0 {
                    self.openMap(lat: lat, long: lng, name: venue.name ?? "")
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
