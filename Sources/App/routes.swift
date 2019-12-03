import Vapor
import Crypto
import Authentication
/// Register your application's routes here.
public func routes(_ router: Router) throws {

    // public routes
    let userController = UserController()
    router.post("users", use: userController.create)
    
    // basic / password auth protected routes
    let basic = router.grouped([User.basicAuthMiddleware(using: BCryptDigest()), User.guardAuthMiddleware()])
    basic.post("login", use: userController.login)

    // bearer / token auth protected routes
    let bearer = router.grouped([User.tokenAuthMiddleware(), User.guardAuthMiddleware()])
    
    bearer.get("users", User.parameter, use: userController.getById)
    
    let tableController = TableController()
    let tables = bearer.grouped("tables")
    
    tables.get(use: tableController.all)
    tables.get(Table.parameter, use: tableController.getById)
    tables.post(CreateTableRequest.self, at: "create", use: tableController.createNewTable)
    tables.put(TableUpdateRequest.self, at: Table.parameter, "update", "title", use: tableController.updateTableTitle)
    tables.put(UpdateTableStateRequest.self, at: Table.parameter, "update", "archived", use: tableController.updateTableState)
    tables.delete(Table.parameter, use: tableController.deleteById)
    
    
    let listController = ListController()
    let lists = bearer.grouped("lists")
    
    lists.post(CreateListRequest.self, at: "create", use: listController.create)
    lists.get(use: listController.getAll)
    lists.get(List.parameter, use: listController.getById)
    
    tables.get(Table.parameter, "lists", use: listController.getAllForTable)

    let cardController = CardController()
    let cards = bearer.grouped("cards")

    cards.get(use: cardController.getAll)
    cards.get(Card.parameter, use: cardController.getById)
    cards.post(CreateCardRequest.self, at: "create", use: cardController.create)
    cards.put(UpdateCardTitleRequest.self, at: Card.parameter, "update", "title", use: cardController.updateCardTitle)
    cards.put(UpdateCardDescriptionRequest.self, at: Card.parameter, "update", "description", use: cardController.updateCardDescription)
    cards.put(UpdateCardStateRequest.self, at: Card.parameter, "update", "archived", use: cardController.updateCardState)
    cards.delete(Card.parameter, use: cardController.deleteById)

    lists.get(List.parameter, "cards", use: cardController.getAllForList)

    let commentController = CommentController()
    let comments = bearer.grouped("comments")

    comments.get(use: commentController.getAll)
    comments.get(Comment.parameter, use: commentController.getById)
    comments.post(CreateCommentRequest.self, at: "create", use: commentController.create)
    comments.put(UpdateCommentTextRequest.self, at: Comment.parameter, "update", "text", use: commentController.updateCommentText)

    cards.get(Card.parameter, "comments", use: commentController.getAllForCard)

    
    let attachmentController = AttachmentController()
    
    cards.post(AttachmentUploadRequest.self, at: Card.parameter, "attachments", use: attachmentController.uploadForCard)
    cards.get(Card.parameter, "attachments", use: attachmentController.getAttachmentsListForCard)
    
    comments.post(AttachmentUploadRequest.self, at: Comment.parameter, "attachments", use: attachmentController.uploadForComment)
    comments.get(Comment.parameter, "attachments", use: attachmentController.getAttachmentsListForComment)
    
    let attachments = bearer.grouped("attachments")
    attachments.get(Int.parameter, use:attachmentController.getAttachmentById)
    attachments.delete(Attachment.parameter, use: attachmentController.deleteAttachment)
}
    
