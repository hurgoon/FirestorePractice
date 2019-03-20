//
//  ThoughtCell.swift
//  FirestorePractice
//
//  Created by Bernard Hur on 21/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit

class ThoughtCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var thoughtTextLabel: UILabel!
    @IBOutlet weak var likesImage: UIImageView!
    @IBOutlet weak var likesNumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(thought: Thought) {
        
        
    }
    
}
