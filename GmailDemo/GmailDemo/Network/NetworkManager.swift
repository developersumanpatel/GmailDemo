//
//  NetworkManager.swift
//  GmailDemo
//
//  Created by Suman on 25/09/21.
//

import Foundation
class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    var selectedMenuIndex: Int = 0
    
    func getAllMatches(completionHandler: @escaping (Bool, Any?) -> Void) {
        guard let url = URL(string: "https://api.foursquare.com/v2/venues/search?ll=40.7484,-73.9857&oauth_token=NPKYZ3WZ1VYMNAZ2FLX1WLECAWSMUVOQZOIDBN53F3LVZBPQ&v=20180616") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completionHandler(false, error?.localizedDescription ?? "No data")
                return
            }
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if let jsonResponse = jsonResult as? [String: Any] {
                    completionHandler(true, jsonResponse)
                }
            } catch {
                debugPrint(error)
            }
            
        }.resume()
    }
}
