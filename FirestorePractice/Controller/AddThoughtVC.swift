//
//  AddThoughtVC.swift
//  FirestorePractice
//
//  Created by Bernard Hur on 19/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit
import Firebase

class AddThoughtVC: UIViewController, UITextViewDelegate {

    // Outlets
    @IBOutlet private weak var categorySegment: UISegmentedControl!
    @IBOutlet private weak var userNameText: UITextField!
    @IBOutlet private weak var thoughtText: UITextView!
    @IBOutlet private weak var postButton: UIButton!
    
    // Variables
    private var selectedCategory = ThoughtCategory.funny.rawValue // rawValue까지 가야 "funny"가 나옴
    
    
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
        switch categorySegment.selectedSegmentIndex {
        case 0 :
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1 :
            selectedCategory = ThoughtCategory.serious.rawValue
        default:
            selectedCategory = ThoughtCategory.crazy.rawValue
        }
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let username = userNameText.text else { return }
        Firestore.firestore().collection(THOUGHTS_REF).addDocument(data: [
            CATEGORY : selectedCategory,
            NUM_COMMENTS : 0,
            NUM_LIKES : 0,
            THOUGHT_TEXT : thoughtText.text,
            TIMESTAMP : FieldValue.serverTimestamp(),
            USERNAME : username
        ]) { (error) in
            if let error = error {
                debugPrint("Error adding document: \(error)")
            } else { // if it is successful
                self.navigationController?.popViewController(animated: true) // 이전 ViewController로 돌아감
            }
        }
        
    }
    

}
