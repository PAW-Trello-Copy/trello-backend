//
//  CardController.swift
//  App
//
//  Created by Artur Stepaniuk on 09/11/2019.
//

import Vapor
import FluentPostgreSQL

class CardController {
    var cardRepository: CardRepository
    
    init(cardRepository: CardRepository) {
        self.cardRepository = cardRepository
    }
    
    func all(_ req: Request) throws -> Future<[Card]> {
        return cardRepository.all()
    }
    
    func byId(_ req: Request) throws -> Future<Card> {
        return try req.parameters.next(Card.self)
    }
    
    func create(_ req: Request, content: CreateCardRequest) throws -> Future<Card> {
        return try req.parameters.next(List.self).flatMap { list in
            return self.cardRepository.create(with: content.title, listId: list.id)
        }
    }
}

struct CreateCardRequest: Content {
    let title: String
}
