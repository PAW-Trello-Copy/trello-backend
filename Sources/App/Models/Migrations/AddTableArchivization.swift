//
//  AddTableArchivization.swift
//  App
//
//  Created by Artur Stepaniuk on 30/11/2019.
//

import FluentPostgreSQL
import Vapor

struct AddTableArchivization: PostgreSQLMigration {
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return PostgreSQLDatabase.update(Table.self, on: conn) { builder in
            builder.deleteField(for: \.archived)
        }
    }
    
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.update(Table.self, on: conn) { builder in
            builder.field(for: \.archived)
        }
    }
}
