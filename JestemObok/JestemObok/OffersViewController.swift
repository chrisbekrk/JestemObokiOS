//
//  OffersViewController.swift
//  JestemObok
//
//  Created by Krystian Bylica on 22.04.2017.
//  Copyright © 2017 Krystian Bylica. All rights reserved.
//

import UIKit
import CoreLocation

class OffersViewController: UIViewController,LocationServiceDelegate,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!

    var offersList = [Offer]()
    
    var selectedOffer = Offer()
    
    var lastLocation:CLLocation?
    
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
        self.lastLocation = currentLocation
        self.tableView.reloadData()
        
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
                            
                           
                            var newOfferArray = [Offer]()
                            for offerObject in object{
                                let newOffer = Offer()
                                let location = offerObject["location"] as! [String:Any]
                                newOffer.address = location["address"] as! String
                                newOffer.rating = offerObject["rating"] as! Double
                                newOffer.latitude = location["lat"] as? Double
                                newOffer.longitude = location["lon"] as? Double
                                newOffer.price = offerObject["price"] as! Int
                                newOffer.username = offerObject["username"] as! String
                                newOffer.size = offerObject["size"] as! String
                                
                                let productsObjs = offerObject["products"] as! [[String:Any]]
                                for productsObj in productsObjs{
                                    let newProduct = Product()
                                    newProduct.name = productsObj["name"] as! String
                                    newProduct.quantity = productsObj["quantity"] as! Int
                                    newOffer.products.append(newProduct)
                                }
                                newOfferArray.append(newOffer)
                            }
                            
                            if newOfferArray.count == 0{
                                self?.tableView.isHidden = true
                            }else{
                                self?.tableView.isHidden = false
                                self?.offersList = newOfferArray
                                self?.tableView.reloadData()
                            }
                            //let tramsArray = object["vehicles"] as! [[String:Any]]
                            //print(object)
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.offersList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "offerCell", for: indexPath)
        
        let name = cell.viewWithTag(1) as? UILabel
        let starLabel = cell.viewWithTag(2) as? UILabel
        let address = cell.viewWithTag(3) as? UILabel
        let distance = cell.viewWithTag(4) as? UILabel
        let shopping = cell.viewWithTag(5) as? UILabel

        let offer = self.offersList[indexPath.row]
        
        name?.text = offer.username
        starLabel?.text = "\(offer.rating)"
        address?.text = offer.address
        
        if let lastloc = self.lastLocation{
            let firstLoc = CLLocation(latitude: offer.latitude!, longitude: offer.longitude!)
            let distanceobj = lastloc.distance(from: firstLoc)
            distance?.text = "\((Int(distanceobj)/10)*10) m"

        }else{
            distance?.text = "Brak lokalizacji :("
        }
        shopping?.text = offer.size

        //cell.textLabel?.text = self.stopObj[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedOffer = self.offersList[indexPath.row]
    
        self.performSegue(withIdentifier: "showDeails", sender: self)

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let nextVC = segue.destination as? OfferDetailsViewController {
            nextVC.selectedOffer = self.selectedOffer
            nextVC.lastLocation = self.lastLocation
        }
        
    }
 

}
