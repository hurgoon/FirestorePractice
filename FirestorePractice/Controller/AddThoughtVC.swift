//
//  AddThoughtVC.swift
//  FirestorePractice
//
//  Created by Bernard Hur on 19/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit

class AddThoughtVC: UIViewController, UITextViewDelegate {

    // Outlets
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var thoughtText: UITextView!
    @IBOutlet weak var postButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postButton.layer.cornerRadius = 4
        thoughtText.layer.cornerRadius = 4
        thoughtText.text = "My random thought..."
        thoughtText.textColor = .lightGray
        thoughtText.delegate = self
    }
    
    // 텍스트뷰에 입력 시작되면 실행됨
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
    }
    
    @IBAction func categoryChanged(_ sender: Any) {
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
    }
    

}
