import FluentPostgreSQL
import Vapor

final class Comment: PostgreSQLModel {
    
    var id: Int?
    var cardId: Card.ID?
    var text: String
    var userId: User.ID?

    init(id: Int? = nil, cardId: Card.ID, text: String, userId: User.ID) {
        self.id = id
        self.text = text
        self.cardId = cardId
        self.userId = userId
    }
}

extension Comment: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(Comment.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.cardId)
            builder.field(for: \.text)
            builder.field(for: \.userId)
        }
    }
}

extension Comment: Content, Parameter { }

