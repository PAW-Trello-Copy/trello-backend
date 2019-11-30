import FluentPostgreSQL
import Vapor

class CommentController {
    
    func create(_ req: Request, content: CreateCommentRequest) throws -> Future<Comment> {
        return Card.query(on: req).filter(\.id == content.cardId).first().flatMap { card in
            let user = try req.requireAuthenticated(User.self)
            guard card != nil else {
                throw Abort(.custom(code: 409, reasonPhrase: "Card with id \(content.cardId) not found"))
            }
            return Comment(cardId: content.cardId, text: content.text, userId: try user.requireID()).save(on: req)
        }
    }
    
    func getAll(_ req: Request) throws -> Future<[Comment]> {
        return Comment.query(on: req).all()
    }
    
    func getById(_ req: Request) throws -> Future<Comment> {
        return try req.parameters.next(Comment.self)
    }
    
    func getAllForCard(_ req: Request) throws -> Future<[Comment]> {
        return try req.parameters.next(Card.self).then { card -> Future<[Comment]> in
            return Comment.query(on: req).filter(\.cardId == card.id).all()
        }
    }

    func updateCommentText(_ req: Request, content: UpdateCommentTextRequest) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Comment.self).map { comment -> Future<Comment> in
            comment.text = content.text
            return comment.save(on: req)
        }.transform(to: .ok)
    }

}
