//
//  UserAndTable.swift
//  App
//
//  Created by Artur Stepaniuk on 21/11/2019.
//

import FluentPostgreSQL

struct UserAndTable: PostgreSQLPivot {
    typealias Left = User
    typealias Right = Table
    
    static var leftIDKey: LeftIDKey = \.userID
    static var rightIDKey: RightIDKey = \.tableID
    
    var id: Int?
    var userID: Int
    var tableID: Int
}

extension UserAndTable: ModifiablePivot {
    init(_ left: User, _ right: Table) throws {
        userID = try left.requireID()
        tableID = try right.requireID()
    }
}

extension UserAndTable: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(UserAndTable.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.userID)
            builder.field(for: \.tableID)
            builder.reference(from: \.userID, to: \User.id)
            builder.reference(from: \.tableID, to: \Table.id)
        }
    }
}
