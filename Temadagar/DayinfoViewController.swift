//
//  DayinfoViewController.swift
//  temadagar
//
//  Created by Alvar Lagerlöf on 25/07/16.
//  Copyright © 2016 Alvar Lagerlöf. All rights reserved.
//

import UIKit
import ImageLoader
import Alamofire

class DayinfoViewController: UITableViewController {

    var recivedId: String = ""
    var recivedTitle: String = ""
    var recivedDate: String = ""
    var recivedDescription: String = ""
    var recivedIntroduced: String = ""
    var recivedInternational: Bool = false
    var recivedWebsite: String = ""
    var recivedFun_fact: String = ""
    var recivedPopularity: String = ""
    var recivedColor: String = ""
    
 
    @IBOutlet var table: UITableView!
    @IBOutlet weak var imagePreview: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var internationalLabel: UILabel!
    @IBOutlet weak var introducedLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var funFactLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    @IBOutlet weak var funFactCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = recivedTitle
        table.estimatedRowHeight = 200.0
        table.rowHeight = UITableViewAutomaticDimension
    
        
        self.navigationController?.navigationBar.barTintColor = hexStringToUIColor(recivedColor)
        
        
        let url = "https://api.temadagar.ravla.org/v4/get_image.php?id=\(recivedId)&w=900&h=675"
        self.imagePreview.load(url)
        
        
        
        descriptionLabel.text = recivedDescription
        descriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.sizeToFit()
        
        funFactLabel.text = recivedFun_fact
        funFactLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        funFactLabel.numberOfLines = 0;
        funFactLabel.sizeToFit()
        
        dateLabel.text = recivedDate
        websiteLabel.text = recivedWebsite
        
        introducedLabel.text = "Sedan: \(recivedIntroduced)"
        
        if (recivedInternational) {
            internationalLabel.text = "Internationell"
        } else {
            internationalLabel.text = "Inte internationell"
        }
        
        
        self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
        
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    
    
    // Clicked a row
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.section == 3) {
            let url = NSURL(string: recivedWebsite)!
            UIApplication.sharedApplication().openURL(url)
        }

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonPressed(sender: UIButton) {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    @IBAction func moreButton(sender: AnyObject) {
        
        // 1
        let optionMenu: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        
        // Share
        let shareAction = UIAlertAction(title: "Dela", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            let message = "Kolla in \(self.recivedTitle) på Temadagar appen! Ladda ned på Google play eller iOS!"
            
            let vc = UIActivityViewController(activityItems: [message], applicationActivities: nil)
            self.presentViewController(vc, animated: true, completion: nil)
            
        })
        
        
        // Ge Feedback
        let feedbackAction = UIAlertAction(title: "Ge feedback", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let alert = UIAlertController(title: "Ge feedback", message: "T.ex. stavfel eller förslag på förbättringar", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Skicka", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                let feedback = alert.textFields![0] as UITextField
                let email = alert.textFields![1] as UITextField
                
                let feedbackString = feedback.text
                let emailString = email.text
                
                let parameters = [
                    "text" : "DayInfo.\(self.recivedId).\(self.recivedTitle): \(feedbackString)",
                    "email"    : emailString!
                ]
                
                Alamofire.request(.POST, "https://api.temadagar.ravla.org/v5/send_feedback.php", parameters: parameters).responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // HTTP URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
                }
                
            }))
            
            alert.addAction(UIAlertAction(title: "Avbryt", style: .Cancel, handler: { (action: UIAlertAction!) in }))
            
            alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.placeholder = "Ditt förslag:"
            })
            alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.placeholder = "Din mail:"
                textField.keyboardType = UIKeyboardType.EmailAddress
            })
            self.presentViewController(alert, animated: true, completion: nil)

        })
        
        
        // Cancel
        let cancelAction = UIAlertAction(title: "Avbryt", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        // 4
        optionMenu.addAction(shareAction)
        optionMenu.addAction(feedbackAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        optionMenu.popoverPresentationController?.sourceView = sender as? UIView
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    

}
