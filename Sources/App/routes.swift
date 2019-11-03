import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    
    
    let tableController = TableController()
    router.get("tables", use: tableController.all)
    router.post(CreateTableRequest.self, at: "tables", "create", use: tableController.createNewTable)
    router.put(TableUpdateRequest.self, at: "tables", Table.parameter, "update", "title", use: tableController.updateTableTitle)
    
    let listController = ListController()
    router.post(CreateListRequest.self, at: "lists", "create", use: listController.create)
    router.get("lists", use: listController.getAll)
    router.get("lists", List.parameter, use: listController.getById)
}
    
