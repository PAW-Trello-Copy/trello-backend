//
//  AddCardArchivization.swift
//  App
//
//  Created by Artur Stepaniuk on 30/11/2019.
//

import FluentPostgreSQL
import Vapor

struct AddCommentHistory: PostgreSQLMigration {
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return PostgreSQLDatabase.update(Comment.self, on: conn) { builder in
            builder.deleteField(for: \.history)
        }
    }
    
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.update(Comment.self, on: conn) { builder in
            builder.field(for: \.history)
        }
    }
}
