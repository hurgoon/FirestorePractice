//
//  Comment.swift
//  FirestorePractice
//
//  Created by Bernard Hur on 24/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import Foundation
import Firebase

class Comment {
    
    private(set) var username: String!
    private(set) var timestamp: Date!
    private(set) var commentTxt: String!
    private(set) var documentId: String!
    private(set) var userId: String!
    
    init(username: String, timestamp: Date, commentTxt: String, documentId: String, userId: String) {
        self.username = username
        self.timestamp = timestamp
        self.commentTxt = commentTxt
        self.documentId = documentId
        self.userId = userId
    }
    
    class func parseData(snapshot: QuerySnapshot?) -> [Comment] {
        var comments = [Comment]()
        
        guard let snap = snapshot else { return comments }
        for document in snap.documents {
            let data = document.data()
            let username = data[USERNAME] as? String ?? "Anonymous"
            let commentTxt = data[COMMENT_TXT] as? String ?? ""
            
            let timestamp = data[TIMESTAMP] as! Timestamp // 타입스탬프 파싱법
            let date: Date = timestamp.dateValue()
            
            let documentId = document.documentID // snapshot 안에 "documentID"는 고정 인스턴스(내가 안만듬)
            let userId = data[USER_ID] as? String ?? ""
            
            let newComment = Comment(username: username, timestamp: date, commentTxt: commentTxt, documentId: documentId, userId: userId)
            comments.append(newComment)
        }
        return comments
    }
}
