//
//  OfferDetailsViewController.swift
//  JestemObok
//
//  Created by Krystian Bylica on 23.04.2017.
//  Copyright © 2017 Krystian Bylica. All rights reserved.
//

import UIKit
import CoreLocation

class OfferDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedOffer = Offer()
    
    var lastLocation:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + selectedOffer.products.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell")
        
        if indexPath.row == 0{
            let name = cell?.viewWithTag(1) as? UILabel
            let starLabel = cell?.viewWithTag(2) as? UILabel
            let address = cell?.viewWithTag(3) as? UILabel
            let distance = cell?.viewWithTag(4) as? UILabel
            let shopping = cell?.viewWithTag(5) as? UILabel
            
            let offer = self.selectedOffer
            
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
            
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "productCell")
            cell?.textLabel?.text = self.selectedOffer.products[indexPath.row-1].name
            cell?.detailTextLabel?.text = "\(self.selectedOffer.products[indexPath.row-1].quantity)"

            //productCell
        }
        
        //cell.textLabel?.text = self.stopObj[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 317.0
        }else{
            return 50.0
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
