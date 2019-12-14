import FluentPostgreSQL
import Vapor

final class Comment: PostgreSQLModel {
    
    var id: Int?
    var cardId: Card.ID?
    var text: String
    var userId: User.ID?
    var history: Bool?

    init(id: Int? = nil, cardId: Card.ID, text: String, userId: User.ID, history: Bool? = false) {
        self.id = id
        self.text = text
        self.cardId = cardId
        self.userId = userId
        self.history = history
    }
}

extension Comment: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(Comment.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.cardId)
            builder.field(for: \.text)
            builder.field(for: \.userId)
            builder.field(for: \.history)
        }
    }
}

extension Comment: Content, Parameter { }

