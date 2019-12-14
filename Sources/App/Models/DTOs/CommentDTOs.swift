//
//  CommentDTOs.swift
//  App
//
//  Created by Artur Stepaniuk on 21/11/2019.
//

import Vapor

struct CreateCommentRequest: Content {
    var cardId: Card.ID
    var text: String
}

struct UpdateCommentTextRequest: Content {
    var text: String
}

struct UpdateCommentHistoryRequest: Content {
    var history: Bool
}

struct CommentWithOwnershipStatus: Content {
    var id: Int?
    var cardId: Card.ID?
    var text: String
    var history: Bool?
    var userId: User.ID?
    var ownedByUser: Bool
    var ownerName: String
    
}
