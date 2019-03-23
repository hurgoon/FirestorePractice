//
//  ViewController.swift
//  FirestorePractice
//
//  Created by Bernard Hur on 19/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit
import Firebase

enum ThoughtCategory: String {
    case serious = "serious"
    case funny = "funny"
    case crazy = "crazy"
    case popular = "popular"
}

class MainVC: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    // Outlets
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    // Variables
    private var thoughts = [Thought]()
    private var thoughtsCollectionRef: CollectionReference!
    private var thoughtsListener: ListenerRegistration!
    private var selectedCategory = ThoughtCategory.funny.rawValue
    private var handle: AuthStateDidChangeListenerHandle? // 유저가 로그인 상태인지 아닌지 판단
    
    @IBAction func categoryChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        case 2:
            selectedCategory = ThoughtCategory.crazy.rawValue
        default:
            selectedCategory = ThoughtCategory.popular.rawValue
        }
        thoughtsListener.remove() // 카테고리가 선택되면 리스너 해제
        setListener()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signoutError as NSError {
            debugPrint("Error signing out: \(signoutError)")
        }
    }
    
    func setListener() {
        if selectedCategory == ThoughtCategory.popular.rawValue {
            thoughtsListener = thoughtsCollectionRef
                .order(by: NUM_LIKES, descending: true) // "true"는 최신이 위로
                .addSnapshotListener { (snapshot, error) in // 실시간으로 데이터 바뀜
                    if let error = error {
                        debugPrint("Error fetching docs: \(error)")
                    } else {
                        self.thoughts.removeAll()
                        
                        self.thoughts = Thought.parseData(snapshot: snapshot) // 하기부분을 Thought로 보내고 치환시킴
                        
                        //                        guard let snap = snapshot else { return }
                        //                        for document in snap.documents {
                        //                            let data = document.data()
                        //                            let username = data[USERNAME] as? String ?? "Anonymous"
                        //                            let timestamp = data[TIMESTAMP] as! Timestamp
                        //                            let date: Date = timestamp.dateValue()
                        //                            let thoughtText = data[THOUGHT_TEXT] as? String ?? ""
                        //                            let numLikes = data[NUM_LIKES] as? Int ?? 0
                        //                            let numComments = data[NUM_COMMENTS] as? Int ?? 0
                        //                            let documentId = document.documentID // "documentID"는 내장 인스턴스(내가 설정안함)
                        //
                        //                            let newThought = Thought(username: username, timestamp: date, thoughtText: thoughtText, numLikes: numLikes, numComments: numComments, documentId: documentId)
                        //                            self.thoughts.append(newThought)
                        //                        }
                        self.tableView.reloadData()
                    }
            }
        } else {
            thoughtsListener = thoughtsCollectionRef
                .whereField(CATEGORY, isEqualTo: selectedCategory)
                .order(by: TIMESTAMP, descending: true) // "true"는 최신이 위로
                .addSnapshotListener { (snapshot, error) in // 실시간으로 데이터 바뀜
                    if let error = error {
                        debugPrint("Error fetching docs: \(error)")
                    } else {
                        self.thoughts.removeAll()
                        
                        self.thoughts = Thought.parseData(snapshot: snapshot) // 치환
                        
                        self.tableView.reloadData()
                    }
            }
        }
        //        thoughtsListener = thoughtsCollectionRef
        //            .whereField(CATEGORY, isEqualTo: selectedCategory)
        //            .order(by: TIMESTAMP, descending: true) // "true"는 최신이 위로
        //            .addSnapshotListener { (snapshot, error) in // 실시간으로 데이터 바뀜
        //            if let error = error {
        //                debugPrint("Error fetching docs: \(error)")
        //            } else {
        //                self.thoughts.removeAll()
        //                guard let snap = snapshot else { return }
        //                for document in snap.documents {
        //                    let data = document.data()
        //                    let username = data[USERNAME] as? String ?? "Anonymous"
        //                    let timestamp = data[TIMESTAMP] as! Timestamp
        //                    let date: Date = timestamp.dateValue()
        //                    let thoughtText = data[THOUGHT_TEXT] as? String ?? ""
        //                    let numLikes = data[NUM_LIKES] as? Int ?? 0
        //                    let numComments = data[NUM_COMMENTS] as? Int ?? 0
        //                    let documentId = document.documentID // "documentID"는 내장 인스턴스(내가 설정안함)
        //
        //                    let newThought = Thought(username: username, timestamp: date, thoughtText: thoughtText, numLikes: numLikes, numComments: numComments, documentId: documentId)
        //                    self.thoughts.append(newThought)
        //                }
        //                self.tableView.reloadData()
        //            }
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil { // 유저가 로그인이 아닌 상황
                let storyboard = UIStoryboard(name: "Main", bundle: nil) // "Main"은 그냥 정한 것...
                let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginVC, animated: true, completion: nil)
            } else { // 유저가 로그인인 상황
                self.setListener()
            }
        })
        
        //        thoughtsListener = thoughtsCollectionRef.addSnapshotListener { (snapshot, error) in // 실시간으로 데이터 바뀜
        //            if let error = error {
        //                debugPrint("Error fetching docs: \(error)")
        //            } else {
        //                self.thoughts.removeAll()
        //                guard let snap = snapshot else { return }
        //                for document in snap.documents {
        //                    let data = document.data()
        //                    let username = data[USERNAME] as? String ?? "Anonymous"
        //                    let timestamp = data[TIMESTAMP] as? Date ?? Date()
        //                    let thoughtText = data[THOUGHT_TEXT] as? String ?? ""
        //                    let numLikes = data[NUM_LIKES] as? Int ?? 0
        //                    let numComments = data[NUM_COMMENTS] as? Int ?? 0
        //                    let documentId = document.documentID // "documentID"는 내장 인스턴스(내가 설정안함)
        //
        //                    let newThought = Thought(username: username, timestamp: timestamp, thoughtText: thoughtText, numLikes: numLikes, numComments: numComments, documentId: documentId)
        //                    self.thoughts.append(newThought)
        //                }
        //                self.tableView.reloadData()
        //            }
        //        }
        
        //        thoughtsCollectionRef.getDocuments { (snapshot, error) in
        //            if let error = error {
        //                debugPrint("Error fetching docs: \(error)")
        //            } else {
        //                guard let snap = snapshot else { return }
        //                for document in snap.documents {
        //                    let data = document.data()
        //                    let username = data[USERNAME] as? String ?? "Anonymous"
        //                    let timestamp = data[TIMESTAMP] as? Date ?? Date()
        //                    let thoughtText = data[THOUGHT_TEXT] as? String ?? ""
        //                    let numLikes = data[NUM_LIKES] as? Int ?? 0
        //                    let numComments = data[NUM_COMMENTS] as? Int ?? 0
        //                    let documentId = document.documentID // "documentID"는 내장 인스턴스(내가 설정안함)
        //
        //                    let newThought = Thought(username: username, timestamp: timestamp, thoughtText: thoughtText, numLikes: numLikes, numComments: numComments, documentId: documentId)
        //                    self.thoughts.append(newThought)
        //                }
        //                self.tableView.reloadData()
        //            }
        //        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension // 행당 높이 자동 설정
        
        thoughtsCollectionRef = Firestore.firestore().collection(THOUGHTS_REF)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if thoughtsListener != nil { // 리스너가 설정 안되어 있을 경우는 크래쉬 됨
            thoughtsListener.remove()
        }
        
        if handle != nil {
            Auth.auth().removeStateDidChangeListener(handle!)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "thoughtCell", for: indexPath) as? ThoughtCell {
            
            cell.configureCell(thought: thoughts[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toComments", sender: thoughts[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComments" {
            if let destinationVC = segue.destination as? CommentsVC {
                if let thought = sender as? Thought {
                    destinationVC.thought = thought
                }
            }
        }
    }
    
}

