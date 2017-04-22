//
//  OffersViewController.swift
//  JestemObok
//
//  Created by Krystian Bylica on 22.04.2017.
//  Copyright © 2017 Krystian Bylica. All rights reserved.
//

import UIKit
import CoreLocation

class OffersViewController: UIViewController,LocationServiceDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!

    var offersList = [Offer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LocationManager.sharedInstance.delegate = self

        self.getOffers()
        
       
        // Do  any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tracingLocation(_ currentLocation: CLLocation) {
        
        
    }
    
    func getOffers(){
       
        let urlString = URL(string: "https://95e9cb8f.ngrok.io/api/v1/offers/list")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let usableData = data {
                        
                        do {
                            let parsedData = try JSONSerialization.jsonObject(with: usableData, options: .allowFragments)
                            //print(parsedData)
                            
                            // let stopsArray = parsedData["stopPoints"] as! [[String:Any]]
                            let object = parsedData as! [[String:Any]]
                            
                            if object.count == 0{
                                self?.tableView.isHidden = true
                            }else{
                                self?.tableView.isHidden = false
                            }
                            let newOfferArray = [Offer]()
                            for offerObject in object{
                                let newOffer = Offer()
                                let location = offerObject["location"] as! [String:Any]
                                newOffer.address = location["address"] as! String
                                newOffer.rating = offerObject["rating"] as! Double
                                newOffer.latitude = location["lat"] as! Double
                                newOffer.longitude = location["lon"] as! Double
                            }
                            
                            //let tramsArray = object["vehicles"] as! [[String:Any]]
                            print(object)
                            //self?.delegate?.refreshTrams(tramsArray)
                            
                        } catch let error as NSError {
                            print("Details of JSON parsing error:\n \(error)")
                        }
                        
                        print(usableData) //JSONSerialization
                    }
                }
            }
            task.resume()
        }
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
