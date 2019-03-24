//
//  CommentsVC.swift
//  FirestorePractice
//
//  Created by Bernard Hur on 24/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit
import Firebase

class CommentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCommentTxt: UITextField!
    @IBOutlet weak var keyboardView: UIView!
    
    // Variables
    var thought: Thought!
    var comments = [Comment]()
    var thoughtRef: DocumentReference!
    let firestore = Firestore.firestore()
    var username: String!
    var commentListener: ListenerRegistration!
    
    override func viewDidAppear(_ animated: Bool) {
        commentListener = firestore.collection(THOUGHTS_REF).document(self.thought.documentId)
            .collection(COMMENTS_REF)
            .order(by: TIMESTAMP, descending: false)
            .addSnapshotListener({ (snapshot, error) in
            
            guard let snapshot = snapshot else {
                debugPrint("Error Fetching comments: \(String(describing: error))")
                return
            }
            
            self.comments.removeAll()
            self.comments = Comment.parseData(snapshot: snapshot)
            self.tableView.reloadData()
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        commentListener.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension // 행당 높이 자동 설정
        
        thoughtRef = firestore.collection(THOUGHTS_REF).document(thought.documentId)
        
        if let name = Auth.auth().currentUser?.displayName {
            username = name
        }
        
        // 키보드 팝업 및 겹치는 뷰 위로 올리기
        self.view.bindToKeyboard()
    }
    
    @IBAction func addCommentTapped(_ sender: Any) {
        guard let commentTxt = addCommentTxt.text else { return }
        
        firestore.runTransaction({ (transaction, errorPointer) -> Any? in
            let thoughtDocument: DocumentSnapshot
            
            do {
                try thoughtDocument = transaction.getDocument(Firestore.firestore()
                    .collection(THOUGHTS_REF).document(self.thought.documentId))
            } catch let error as NSError {
                debugPrint("Fetch error: \(error.localizedDescription)")
                return nil
            }
            
            guard let oldNumComments = thoughtDocument.data()?[NUM_COMMENTS] as? Int else { return nil }
            
            transaction.updateData([NUM_COMMENTS : oldNumComments + 1], forDocument: self.thoughtRef)
            
            let newCommentRef = self.firestore.collection(THOUGHTS_REF).document(self.thought.documentId).collection("comments").document()
            
            transaction.setData([
                COMMENT_TXT : commentTxt,
                TIMESTAMP : FieldValue.serverTimestamp(),
                USERNAME : self.username,
                USER_ID : Auth.auth().currentUser?.uid ?? ""
                ], forDocument: newCommentRef)
            
            return nil
        }) { (object, error) in
            if let error = error {
                debugPrint("Transaction failed : \(error.localizedDescription)")
            } else {
                self.addCommentTxt.text = ""
                self.addCommentTxt.resignFirstResponder() // 텍스트 입력 및 등록 완료시 키보드 내려감
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentCell {
            
            cell.configureCell(comment: comments[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
