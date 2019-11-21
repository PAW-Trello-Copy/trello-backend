//
//  Table.swift
//  App
//
//  Created by Artur Stepaniuk on 01/11/2019.
//

import FluentPostgreSQL
import Vapor

final class Table: PostgreSQLModel {
    
    var id: Int?
    var title: String
    
    var users: Siblings<Table, User, UserAndTable> {
        return siblings()
    }

     init(id: Int? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

extension Table: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(Table.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.title)
        }
    }
}

extension Table: Content, Parameter { }
