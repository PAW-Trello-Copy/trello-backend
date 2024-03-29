import FluentPostgreSQL
import Vapor

class CardController {
    
    func create(_ req: Request, content: CreateCardRequest) throws -> Future<Card> {
        
        let user = try req.requireAuthenticated(User.self)
        return List.query(on: req).filter(\.id == content.listId).first().flatMap { list in
            guard list != nil else {
                throw Abort(.custom(code: 409, reasonPhrase: "List with id \(content.listId) not found"))
            }
            return Card(title: content.title, listId: content.listId).save(on: req).do { card in
                Comment(cardId: card.id!, text: "Card created", userId: user.id!, history: true).save(on: req)
            }
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
            let archived: Bool = (try? req.query.get(Bool.self, at: "archived")) ?? false
            return Card.query(on: req).filter(\.listId == list.id).filter(\.archived == archived).all()
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

    func updateCardState(_ req: Request, content: UpdateCardStateRequest) throws -> Future<HTTPStatus> {
        let user = try req.requireAuthenticated(User.self)
        return try req.parameters.next(Card.self).map { card -> Future<Card> in
            card.archived = content.archived
            return card.save(on: req).do { card in
                Comment(cardId: card.id!, text: "Card archivization status changed to \(content.archived)", userId: user.id!, history: true).save(on: req)
            }
        }.transform(to: .ok)
    }

    func addCardLabel(_ req: Request, content: AddCardLabelRequest) throws -> Future<HTTPStatus> {
        return Label.query(on: req).filter(\.id == content.labelId).first().flatMap{ label -> Future<CardAndLabel> in
        return try req.parameters.next(Card.self).flatMap { card in
            return card.labels.attach(label! , on:req)
        }
    }.transform(to: .ok)}

    func getCardLabels(_ req: Request) throws  -> Future<[Label]> {
        return try req.parameters.next(Card.self).flatMap {card -> Future<[Label]> in
            return try card.labels.query(on: req).all()
        }   
    }

    func removeCardLabel(_ req: Request, content: RemoveCardLabelRequest) throws -> Future<HTTPStatus> {
        return Label.query(on: req).filter(\.id == content.labelId).first().flatMap{ label -> Future<Void> in
        return try req.parameters.next(Card.self).flatMap { card in
            return card.labels.detach(label! , on:req)
        }
    }.transform(to: .ok)}

    func deleteById(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Card.self).map { card -> Future<Void> in
            if card.archived ?? false
            {
                return card.delete(on: req)
            }
            else {
            throw Abort(.badRequest)
        }
        }.transform(to: .ok)
    }



}
