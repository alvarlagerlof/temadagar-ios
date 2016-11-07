//
//  NewViewCell.swift
//  temadagar
//
//  Created by Alvar Lagerlöf on 06/09/16.
//  Copyright © 2016 Alvar Lagerlöf. All rights reserved.
//

import UIKit

class NewViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
