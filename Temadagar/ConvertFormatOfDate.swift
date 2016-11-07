//
//  ConvertFormatOfDate.swift
//  temadagar
//
//  Created by Alvar Lagerlöf on 07/09/16.
//  Copyright © 2016 Alvar Lagerlöf. All rights reserved.
//

import Foundation

extension NSString {
    
    class func convertFormatOfDate(date: String, originalFormat: String, destinationFormat: String) -> String! {
        
        
        // Orginal format :
        let dateOriginalFormat = NSDateFormatter()
        dateOriginalFormat.dateFormat = originalFormat
        
        // Destination format :
        let dateDestinationFormat = NSDateFormatter()
        dateDestinationFormat.dateFormat = destinationFormat
        
        // Convert current String Date to NSDate
        let dateFromString = dateOriginalFormat.dateFromString(date)
        
        // Convert new NSDate created above to String with the good format
        let dateFormated = dateDestinationFormat.stringFromDate(dateFromString!)
        
        return dateFormated
        
    }
}