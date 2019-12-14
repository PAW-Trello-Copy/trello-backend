//
//  List.swift
//  App
//
//  Created by Artur Stepaniuk on 03/11/2019.
//

import FluentPostgreSQL
import Vapor

final class Label: PostgreSQLModel {
    
    var id: Int?
    var tableId: Table.ID?
    var title: String
    var color: String?

    var cards: Siblings<Label, Card, CardAndLabel> {
        return siblings()
    }

    init(id: Int? = nil, title: String, tableId: Table.ID, color: String) {
        self.id = id
        self.title = title
        self.tableId = tableId
        self.color = color
    }
}

extension Label: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(Label.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.tableId)
            builder.field(for: \.title)
            builder.field(for: \.color)
        }
    }
}

extension Label: Content, Parameter { }
