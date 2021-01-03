//
//  MenuTableViewCell.swift
//  letsPlank
//
//  Created by Rin on 2021/01/03.
//

import UIKit


class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
