//
//  Thought.swift
//  FirestorePractice
//
//  Created by Bernard Hur on 21/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import Foundation

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

}
