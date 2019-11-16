import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    
    let tableController = TableController()
    let tables = router.grouped("tables")
    
    tables.get(use: tableController.all)
    tables.get(Table.parameter, use: tableController.getById)
    tables.post(CreateTableRequest.self, at: "create", use: tableController.createNewTable)
    tables.put(TableUpdateRequest.self, at: Table.parameter, "update", "title", use: tableController.updateTableTitle)
    
    
    let listController = ListController()
    let lists = router.grouped("lists")
    
    lists.post(CreateListRequest.self, at: "create", use: listController.create)
    lists.get(use: listController.getAll)
    lists.get(List.parameter, use: listController.getById)
    
    tables.get(Table.parameter, "lists", use: listController.getAllForTable)

    let cardController = CardController()
    let cards = router.grouped("cards")

    cards.get(use: cardController.getAll)
    cards.get(Card.parameter, use: cardController.getById)
    cards.post(CreateCardRequest.self, at: "create", use: cardController.create)
    cards.put(UpdateCardTitleRequest.self, at: Card.parameter, "update", "title", use: cardController.updateCardTitle)
    cards.put(UpdateCardDescriptionRequest.self, at: Card.parameter, "update", "description", use: cardController.updateCardDescription)

    lists.get(List.parameter, "cards", use: cardController.getAllForList)
    
    
}
    
