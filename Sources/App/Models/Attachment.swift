//
//  Attachment.swift
//  App
//
//  Created by Artur Stepaniuk on 01/12/2019.
//

import FluentPostgreSQL
import Vapor

final class Attachment: PostgreSQLModel {
    
    var id: Int?
    var authorId: User.ID
    var cardId: Card.ID?
    var commentId: Comment.ID?
    var title: String
    var data: Data
    var creationDate: Date
    var ext: String?
    
    init(id: Int? = nil, authorId: User.ID, cardId: Card.ID? = nil, commentId: Comment.ID? = nil, title: String, data: Data, creationDate: Date = Date(), ext: String? = nil) {
        self.id = id
        self.authorId = authorId
        self.cardId = cardId
        self.commentId = commentId
        self.title = title
        self.data = data
        self.creationDate = creationDate
    }
}

extension Attachment: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return PostgreSQLDatabase.create(Attachment.self, on: connection) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.authorId)
            builder.field(for: \.cardId)
            builder.field(for: \.commentId)
            builder.field(for: \.title)
            builder.field(for: \.data)
            builder.field(for: \.creationDate)
            builder.field(for: \.ext)
        }
    }
}

extension Attachment: Content, Parameter { }
