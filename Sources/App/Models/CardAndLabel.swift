//
//  UserAndTable.swift
//  App
//
//  Created by Artur Stepaniuk on 21/11/2019.
//

import FluentPostgreSQL

struct CardAndLabel: PostgreSQLPivot {
    typealias Left = Card
    typealias Right = Label
    
    static var leftIDKey: LeftIDKey = \.cardID
    static var rightIDKey: RightIDKey = \.labelID
    
    var id: Int?
    var cardID: Int
    var labelID: Int
}

extension CardAndLabel: ModifiablePivot {
    init(_ left: Card, _ right: Label) throws {
        cardID = try left.requireID()
        labelID = try right.requireID()
    }
}

extension CardAndLabel: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(CardAndLabel.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.cardID)
            builder.field(for: \.labelID)
            builder.reference(from: \.cardID, to: \Card.id)
            builder.reference(from: \.labelID, to: \Label.id)
        }
    }
}
