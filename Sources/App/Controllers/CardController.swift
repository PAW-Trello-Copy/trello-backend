import FluentPostgreSQL
import Vapor

class CardController {
    
    func create(_ req: Request, content: CreateCardRequest) throws -> Future<Card> {
        return List.query(on: req).filter(\.id == content.listId).first().flatMap { list in
            guard list != nil else {
                throw Abort(.custom(code: 409, reasonPhrase: "List with id \(content.listId) not found"))
            }
            return Card(title: content.title, listId: content.listId).save(on: req)
        }
    }
    
    func getAll(_ req: Request) throws -> Future<[Card]> {
        return Card.query(on: req).all()
    }
    
    func getById(_ req: Request) throws -> Future<Card> {
        return try req.parameters.next(Card.self)
    }
    
    func getAllForList(_ req: Request) throws -> Future<[Card]> {
        return try req.parameters.next(List.self).then { list -> Future<[Card]> in
            return Card.query(on: req).filter(\.listId == list.id).all()
        }
    }

    func updateCardTitle(_ req: Request, content: UpdateCardTitleRequest) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Card.self).map { card -> Future<Card> in
            card.title = content.title
            return card.save(on: req)
        }.transform(to: .ok)
    }

    func updateCardDescription(_ req: Request, content: UpdateCardDescriptionRequest) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Card.self).map { card -> Future<Card> in
            card.description = content.description
            return card.save(on: req)
        }.transform(to: .ok)
    }   
}


struct CreateCardRequest: Content {
    var listId: List.ID
    var title: String
}

struct UpdateCardTitleRequest: Content {
    var title: String
}

struct UpdateCardDescriptionRequest: Content {
    var description: String
}
