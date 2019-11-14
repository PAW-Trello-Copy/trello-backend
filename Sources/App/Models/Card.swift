//
//  Card.swift
//  App
//
//  Created by Artur Stepaniuk on 07/11/2019.
//

import Vapor
import Fluent
import FluentSQLite

protocol CardRepresentable {
    var id: Int? { get set }
    var title: String { get set }
    var listId: Int? { get set }
}

final class Card: CardRepresentable {
    
    var id: Int?
    var title: String
    var listId: Int?
    
    init(id: Int? = nil, title: String, listId: Int?) {
        self.id = id
        self.title = title
        self.listId = listId
    }
}

//MARK: to allow usage in routing
extension Card: Parameter {
    typealias ResolvedParameter = Future<Card>
    
    static var routingSlug: String { return "cardObject" }
    
    static func resolveParameter(_ parameter: String, on container: Container) throws -> ResolvedParameter {
        
        let cardId = try Int.getId(from: parameter)
        
        let repository = try container.make(CardRepository.self)
        return repository.find(by: cardId).map { card in
            if let card = card {
                return card
            }
            
            throw RoutingError(identifier: "cardNotFound", reason: "No card with id \(cardId)")
        }
    }
}

extension Card: Content {}
