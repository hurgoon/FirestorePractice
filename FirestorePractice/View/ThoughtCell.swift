//
//  ThoughtCell.swift
//  FirestorePractice
//
//  Created by Bernard Hur on 21/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit
import Firebase

protocol ThoughtDelegate {
    func thoughtOptionTapped(thought: Thought)
}

class ThoughtCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var thoughtTextLabel: UILabel!
    @IBOutlet weak var likesImage: UIImageView!
    @IBOutlet weak var likesNumLabel: UILabel!
    @IBOutlet weak var commentsNumLbl: UILabel!
    @IBOutlet weak var optionsMenu: UIImageView!
    
    // Variables
    private var thought: Thought!
    private var delegate: ThoughtDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Like이미지 제스쳐 입히기
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likesImage.addGestureRecognizer(tap)
        likesImage.isUserInteractionEnabled = true
    }
    
    @objc func likeTapped() {
        // Method 1
//        Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId).setData([NUM_LIKES : thought.numLikes + 1], merge: true)
        
        // Method 2
        Firestore.firestore().document("thoughts/\(thought.documentId!)").updateData([NUM_LIKES : thought.numLikes + 1])
    }

    func configureCell(thought: Thought, delegate: ThoughtDelegate?) {
        optionsMenu.isHidden = true
        self.thought = thought
        self.delegate = delegate
        
        usernameLabel.text = thought.username
        thoughtTextLabel.text = thought.thoughtText
        likesNumLabel.text = String(thought.numLikes)
        commentsNumLbl.text = String(thought.numComments)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestamp = formatter.string(from: thought.timestamp)
        timestampLabel.text = timestamp
        
        if thought.userId == Auth.auth().currentUser?.uid { // 현재 저장되어 있는 thought의 유저ID가 접속자의 uid와 동일하면 하기 진행
            optionsMenu.isHidden = false
            optionsMenu.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(thoughtOptionsTapped) )
            optionsMenu.addGestureRecognizer(tap)
        }
    }
    
    @objc func thoughtOptionsTapped() {
        delegate?.thoughtOptionTapped(thought: thought)
    }
}
