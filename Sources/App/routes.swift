import Vapor

/// Register your application's routes here.
public func routes(_ router: Router, _ app: Container) throws {

    
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
    
    let cardRepository = try app.make(CardRepository.self)
    let cardController = CardController(cardRepository: cardRepository)
    
    router.get("cards", use: cardController.all)
    router.get("cards", Card.parameter, use: cardController.byId)
    router.post(CreateCardRequest.self, at: "lists", List.parameter, "cards", "create", use: cardController.create)
}
    
