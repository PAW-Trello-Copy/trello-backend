import Vapor
import Crypto

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    // public routes
    let userController = UserController()
    router.post("users", use: userController.create)
    
    // basic / password auth protected routes
    let basic = router.grouped([User.basicAuthMiddleware(using: BCryptDigest()), User.guardAuthMiddleware()])
    basic.post("login", use: userController.login)

    // bearer / token auth protected routes
    let bearer = router.grouped(User.tokenAuthMiddleware())
    
    let tableController = TableController()
    let tables = bearer.grouped("tables")
    
    tables.get(use: tableController.all)
    tables.get(Table.parameter, use: tableController.getById)
    tables.post(CreateTableRequest.self, at: "create", use: tableController.createNewTable)
    tables.put(TableUpdateRequest.self, at: Table.parameter, "update", "title", use: tableController.updateTableTitle)
    
    
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

    lists.get(List.parameter, "cards", use: cardController.getAllForList)
    
    
}
    
