//
//  MemoTableViewCell.swift
//  My Bow-Wow
//
//  Created by Eddie Ahn on 2020/07/01.
//  Copyright © 2020 Sang Wook Ahn. All rights reserved.
//

import UIKit

class MemoTableViewCell: UITableViewCell {

    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var regdate: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
