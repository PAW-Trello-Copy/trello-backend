//
//  List.swift
//  App
//
//  Created by Artur Stepaniuk on 03/11/2019.
//

import FluentPostgreSQL
import Vapor

final class List: PostgreSQLModel {
    
    var id: Int?
    var tableId: Table.ID?
    var title: String

    init(id: Int? = nil, title: String, tableId: Table.ID) {
        self.id = id
        self.title = title
    }
}

extension List: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(List.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.tableId)
            builder.field(for: \.title)
        }
    }
}

extension List: Content, Parameter { }
