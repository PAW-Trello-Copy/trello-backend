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

