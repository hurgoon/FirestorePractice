//
//  CommentCell.swift
//  FirestorePractice
//
//  Created by Bernard Hur on 24/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var usernameTxt: UILabel!
    @IBOutlet weak var timestampTxt: UILabel!
    @IBOutlet weak var commentTxt: UILabel!

    func configureCell(comment: Comment) {
        usernameTxt.text = comment.username
        commentTxt.text =  comment.commentTxt
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestamp = formatter.string(from: comment.timestamp)
        timestampTxt.text = timestamp
    }
}
