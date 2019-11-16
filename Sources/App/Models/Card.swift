import FluentPostgreSQL
import Vapor

final class Card: PostgreSQLModel {
    
    var id: Int?
    var listId: List.ID?
    var title: String
    var description: String?

    init(id: Int? = nil, title: String, listId: List.ID, description: String? = nil) {
        self.id = id
        self.title = title
        self.listId = listId
        self.description = description
    }
}

extension Card: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(Card.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.listId)
            builder.field(for: \.title)
            builder.field(for: \.description)
        }
    }
}

extension Card: Content, Parameter { }
