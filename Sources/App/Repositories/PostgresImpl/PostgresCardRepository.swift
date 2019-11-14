//
//  PostgresCardRepository.swift
//  App
//
//  Created by Artur Stepaniuk on 07/11/2019.
//

import FluentPostgreSQL

final class PostgresCardRepository: CardRepository {
    let db: PostgreSQLDatabase.ConnectionPool
    
    init(_ db: PostgreSQLDatabase.ConnectionPool) {
        self.db = db
    }
    
    func find(by id: Int) -> EventLoopFuture<Card?> {
        db.withConnection { conn in
            return PostgresCard.find(id, on: conn).map { $0?.convert() }
        }
    }
    
    func all() -> EventLoopFuture<[Card]> {
        return db.withConnection { conn in
            return PostgresCard.query(on: conn).all().map { postgresCards in
                return postgresCards.map { $0.convert() }
            }
        }
    }
    
    func all(for listId: Int) -> EventLoopFuture<[Card]> {
        return db.withConnection { conn in
            return PostgresCard.query(on: conn).filter(\.listId == listId).all().map { postgresCards in
                return postgresCards.map { $0.convert() }
            }
        }
    }
    
    func create(with title: String, listId: Int?) -> EventLoopFuture<Card> {
        db.withConnection { conn in
            return PostgresCard(title: title, listId: listId).save(on: conn).map { $0.convert() }
        }
    }
}

//MARK: Conformance to ServiceType protocol
extension PostgresCardRepository {
    static let serviceSupports: [Any.Type] = [CardRepository.self]
    
    static func makeService(for worker: Container) throws -> Self {
        return .init(try worker.connectionPool(to: .psql))
    }
}

//MARK: Mapping postgres model to generic model
extension PostgresCardRepository {
    struct PostgresCard: CardRepresentable, PostgreSQLModel, Migration {
        var id: Int?
        var title: String
        var listId: Int?
        
        init(id: Int? = nil, title: String, listId: Int?) {
            self.id = id
            self.title = title
            self.listId = listId
        }
        
        func convert() -> Card {
            return Card(id: id, title: title, listId: listId)
        }
        
        static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
            return PostgreSQLDatabase.create(PostgresCard.self, on: conn) { builder in
                builder.field(for: \.id, isIdentifier: true)
                builder.field(for: \.title)
                builder.field(for: \.listId)
            }
        }
    }
}
