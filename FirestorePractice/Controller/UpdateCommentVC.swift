//
//  UpdateCommentVC.swift
//  FirestorePractice
//
//  Created by Bernard Hur on 25/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit
import Firebase

class UpdateCommentVC: UIViewController {

    // Outlets
    @IBOutlet weak var commentTxt: UITextView!
    @IBOutlet weak var updateBtn: UIButton!
    
    // Variables
    var commentData: (comment: Comment, thought: Thought)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTxt.layer.cornerRadius = 10
        updateBtn.layer.cornerRadius = 10
        
        commentTxt.text = commentData.comment.commentTxt
    }
    
    @IBAction func updateTapped(_ sender: Any) {
        Firestore.firestore().collection(THOUGHTS_REF).document(commentData.thought.documentId)
        .collection(COMMENTS_REF).document(commentData.comment.documentId).updateData([
            COMMENT_TXT : commentTxt.text
        ]) { (error) in
            if let error = error {
                debugPrint("Unable to update comment: \(error.localizedDescription)")
            } else { // 성공하면 현재 뷰컨트롤러를 날린다
                self.navigationController?.popViewController(animated: false)
            }
        }
        
    }
    

}
