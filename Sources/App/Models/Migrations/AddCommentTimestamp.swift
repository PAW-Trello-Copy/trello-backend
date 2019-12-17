//
//  AddCommentTimestamp.swift
//  App
//
//  Created by Artur Stepaniuk on 17/12/2019.
//

import FluentPostgreSQL
import Vapor

struct AddCommentTimestamp: PostgreSQLMigration {
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return PostgreSQLDatabase.update(Comment.self, on: conn) { builder in
            builder.deleteField(for: \.timestamp)
        }
    }
    
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.update(Comment.self, on: conn) { builder in
            builder.field(for: \.timestamp)
        }
    }
}

