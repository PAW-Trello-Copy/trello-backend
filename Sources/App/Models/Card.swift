import FluentPostgreSQL
import Vapor

final class Card: PostgreSQLModel {
    
    var id: Int?
    var listId: List.ID?
    var title: String
    var description: String?
    var archived: Bool?

     var labels: Siblings<Card, Label, CardAndLabel> {
        return siblings()
    }

    init(id: Int? = nil, title: String, listId: List.ID, description: String? = nil, archived: Bool? = false) {
        self.id = id
        self.title = title
        self.listId = listId
        self.description = description
        self.archived = archived
    }
}

extension Card: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(Card.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.listId)
            builder.field(for: \.title)
            builder.field(for: \.description)
            builder.field(for: \.archived)
        }
    }
}

extension Card: Content, Parameter { }

