//
//  AllViewController.swift
//  Temadagar
//
//  Created by Alvar Lagerlöf on 23/07/16.
//  Copyright © 2016 Alvar Lagerlöf. All rights reserved.
//

import UIKit
import SwiftyJSON
import ImageLoader
import Alamofire

class AllViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var listArray = [ListItem]()
    var listArrayFiltered = [ListItem]()
    
    var titleArray = [String]()
    var dateArray = [String]()
    
    var resultSearchController = UISearchController()
    
    var refreshControl: UIRefreshControl!

    
    
    
    override func viewDidLoad() {
        
               
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
        self.tableView.hidden = true
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.activityIndicator.startAnimating()
        
        
        parseJSON("https://api.temadagar.ravla.org/v5/data/data_all.json")
        
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor(red: 244.0/255.0,
                                                 green: 244.0/255.0,
                                                 blue: 244.0/255.0,
                                                 alpha: 1.0)
        
        refreshControl.tintColor = UIColor.darkGrayColor()
        tableView.addSubview(refreshControl)
        
        
        // Search
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.resultSearchController.searchBar.showsCancelButton = false
        
        self.resultSearchController.searchBar.delegate = self
        self.resultSearchController.hidesNavigationBarDuringPresentation = false


        
        self.resultSearchController.searchBar.placeholder = "Sök"
        
        self.resultSearchController.searchBar.setShowsCancelButton(false, animated: false)
        
        self.navigationItem.titleView = resultSearchController.searchBar
        
    }
    
    
    func refresh(sender:AnyObject) {
        parseJSON("https://api.temadagar.ravla.org/v6/data/data_all.json")
    }
    

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.active) {
            return listArrayFiltered.count
        } else {
            return listArray.count - 1
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("allCell", forIndexPath: indexPath) as! AllViewCell
        
        if (self.resultSearchController.active) {
            cell.titleLabel.text = listArrayFiltered[indexPath.row].title
            cell.dateLabel.text = listArrayFiltered[indexPath.row].date
            
            cell.imagePreview.load("https://api.temadagar.ravla.org/v4/images/resized/\(listArrayFiltered[indexPath.row].id)_resized_w100_h100.jpg")

        } else {
            cell.titleLabel.text = listArray[indexPath.row].title
            cell.dateLabel.text = listArray[indexPath.row].date
            
            cell.imagePreview.load("https://api.temadagar.ravla.org/v4/images/resized/\(listArray[indexPath.row].id)_resized_w100_h100.jpg")

        }
        
        
        return cell
    }
    
    
    // Clicked a row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDayInfo", sender: self)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //self.resultSearchController.active = false
    }
    
    
    // Set segue data
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDayInfo") {
            
            let yourNextViewController = (segue.destinationViewController as! DayinfoViewController)
            let indexPath = self.tableView.indexPathForSelectedRow
            
            if (self.resultSearchController.active) {
                yourNextViewController.recivedTitle = listArrayFiltered[(indexPath?.row)!].title
                yourNextViewController.recivedId = listArrayFiltered[(indexPath?.row)!].id
                yourNextViewController.recivedDate = listArrayFiltered[(indexPath?.row)!].date
                yourNextViewController.recivedDescription = listArrayFiltered[(indexPath?.row)!].description
                yourNextViewController.recivedIntroduced = listArrayFiltered[(indexPath?.row)!].introduced
                yourNextViewController.recivedInternational = listArrayFiltered[(indexPath?.row)!].international
                yourNextViewController.recivedWebsite = listArrayFiltered[(indexPath?.row)!].website
                yourNextViewController.recivedFun_fact = listArrayFiltered[(indexPath?.row)!].fun_fact
                yourNextViewController.recivedPopularity = listArrayFiltered[(indexPath?.row)!].popularity
                yourNextViewController.recivedColor = listArrayFiltered[(indexPath?.row)!].color
            } else {
                yourNextViewController.recivedTitle = listArray[(indexPath?.row)!].title
                yourNextViewController.recivedId = listArray[(indexPath?.row)!].id
                yourNextViewController.recivedDate = listArray[(indexPath?.row)!].date
                yourNextViewController.recivedDescription = listArray[(indexPath?.row)!].description
                yourNextViewController.recivedIntroduced = listArray[(indexPath?.row)!].introduced
                yourNextViewController.recivedInternational = listArray[(indexPath?.row)!].international
                yourNextViewController.recivedWebsite = listArray[(indexPath?.row)!].website
                yourNextViewController.recivedFun_fact = listArray[(indexPath?.row)!].fun_fact
                yourNextViewController.recivedPopularity = listArray[(indexPath?.row)!].popularity
                yourNextViewController.recivedColor = listArray[(indexPath?.row)!].color

            }
            
            
        }
    }

    
    
    
    func parseJSON(url: String) {
        let baseURL = NSURL(string: url)
        
        Alamofire.request(.GET, baseURL!)
            .responseString { response in
                
                var readableJSON = JSON(data: response.result.value!.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                
                for i in 0...readableJSON["days"].count {
                    
                    let id = readableJSON["days"][i, "id"].stringValue
                    let title = readableJSON["days"][i, "title"].stringValue
                    var date = readableJSON["days"][i, "date"].stringValue
                    let description = readableJSON["days"][i, "description"].stringValue
                    let introduced = readableJSON["days"][i, "introduced"].stringValue
                    let international = readableJSON["days"][i, "international"].boolValue
                    let website = readableJSON["days"][i, "website"].stringValue
                    let fun_fact = readableJSON["days"][i, "fun_fact"].stringValue
                    let popularity = readableJSON["days"][i, "popularity"].stringValue
                    let color = readableJSON["days"][i, "color"].stringValue
                    
                    
                    // To NSDate
                    let dateformatter = NSDateFormatter()
                    dateformatter.dateFormat = "yyyy-MM-dd"
                    let nsDate = dateformatter.dateFromString(date)
                                        
                    // Back to string
                    dateformatter.dateFormat = "EEE d MMM, yyyy"
                    
                    if (nsDate != nil) {
                        date = dateformatter.stringFromDate(nsDate!)
                    }
                    
                    
                    
                    // Add to list
                    self.listArray += [ListItem(
                        id: id,
                        title: title,
                        date: date,
                        description: description,
                        introduced: introduced,
                        international: international,
                        website: website,
                        fun_fact: fun_fact,
                        popularity: popularity,
                        color: color)]
                    
                    
                    self.titleArray.append(readableJSON[i, "title"].stringValue)
                    self.dateArray.append(readableJSON[i, "date"].stringValue)
                }
                
                
                // Reload tableview and stop spinner
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.tableView.hidden = false
                self.tableView.reloadData()
                
                self.refreshControl.endRefreshing()

                
         }

    }
    
    
    @IBAction func addButton(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Föreslå dag", message: "Föreslå en dag som saknas", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Skicka", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Avbryt", style: .Cancel, handler: { (action: UIAlertAction!) in
        }))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Ditt förslag:"
        })
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Din mail:"
            textField.keyboardType = UIKeyboardType.EmailAddress
            
        })
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    /*
     ____    _____      _      ____     ____   _   _
     / ___|  | ____|    / \    |  _ \   / ___| | | | |
     \___ \  |  _|     / _ \   | |_) | | |     | |_| |
     ___) |  | |___   / ___ \  |  _ <  | |___  |  _  |
     |____/  |_____| /_/   \_\ |_| \_\  \____| |_| |_|
     
     */
    
    
    
    // Update list when searching
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.listArrayFiltered.removeAll(keepCapacity: false)
        
        //self.resultSearchController.searchBar.setShowsCancelButton(false, animated: false)
        
        for i in 0...listArray.count - 1 {
            if (searchController.searchBar.text == "") {
                self.listArrayFiltered = self.listArray
            } else {
                
                if (listArray[i].title.lowercaseString.containsString(searchController.searchBar.text!.lowercaseString)) {
                    listArrayFiltered.append(listArray[i])
                } else if (listArray[i].date.lowercaseString.containsString(searchController.searchBar.text!.lowercaseString)) {
                    listArrayFiltered.append(listArray[i])
                }
    
            }
            
        }
        
        // Sort based on search term
        if (searchController.searchBar.text != "") {
            
            var filtered = self.listArrayFiltered.filter {
                return $0.title.rangeOfString(searchController.searchBar.text!.lowercaseString, options: .CaseInsensitiveSearch) != nil
            }
            
            filtered = filtered.reverse()
                
            self.listArrayFiltered = filtered
            
        }
        
        self.tableView.reloadData()
    }

    
    
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        print("hide")
        ///self.resultSearchController.searchBar.setShowsCancelButton(false, animated: false)
        return true
        

    }
    

    
    
    // Dissmiss keyboard on scroll
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        resultSearchController.searchBar.endEditing(true)
    }

    
    // On cancel button clicked
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.resultSearchController.searchBar.setShowsCancelButton(false, animated: false)
        self.resultSearchController.searchBar.showsCancelButton = false
        self.resultSearchController.searchBar.endEditing(true)
        self.resultSearchController.active = false
    
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    }
    
    
    
}