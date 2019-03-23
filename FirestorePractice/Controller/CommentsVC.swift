//
//  CommentsVC.swift
//  FirestorePractice
//
//  Created by Bernard Hur on 24/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit

class CommentsVC: UIViewController {

    // Outlets
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var addCommentTxt: UITextField!
    @IBOutlet weak var keyboardView: UIView!
    
    // Variables
    var thought: Thought!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    @IBAction func addCommentTapped(_ sender: Any) {
    }
    

}
