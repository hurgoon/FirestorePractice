//
//  Thought.swift
//  FirestorePractice
//
//  Created by Bernard Hur on 21/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import Foundation
import Firebase

class Thought {
    
    private(set) var username: String! // private(set) 어디서든지 불러서 쓸수 있으나, 변경은 해당 클래스 안에서만 가능
    private(set) var timestamp: Date!
    private(set) var thoughtText: String!
    private(set) var numLikes: Int!
    private(set) var numComments: Int!
    private(set) var documentId: String!
    
    init(username: String, timestamp: Date, thoughtText: String, numLikes: Int, numComments: Int, documentId: String) {
        
        self.username = username
        self.timestamp = timestamp
        self.thoughtText = thoughtText
        self.numLikes = numLikes
        self.numComments = numComments
        self.documentId = documentId
    }
    
    class func parseData(snapshot: QuerySnapshot?) -> [Thought] {
        var thoughts = [Thought]()
        
        guard let snap = snapshot else { return thoughts }
        for document in snap.documents {
            let data = document.data()
            let username = data[USERNAME] as? String ?? "Anonymous"
            
            let timestamp = data[TIMESTAMP] as! Timestamp // 타임스템프 가져오는 방법
            let date: Date = timestamp.dateValue()
            
            let thoughtText = data[THOUGHT_TEXT] as? String ?? ""
            let numLikes = data[NUM_LIKES] as? Int ?? 0
            let numComments = data[NUM_COMMENTS] as? Int ?? 0
            let documentId = document.documentID // "documentID"는 내장 인스턴스(내가 설정안함)
            
            let newThought = Thought(username: username, timestamp: date, thoughtText: thoughtText, numLikes: numLikes, numComments: numComments, documentId: documentId)
            thoughts.append(newThought)
        }
        
        return thoughts
    }

}
