import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    
    let tableController = TableController()
    let tables = router.grouped("tables")
    
    tables.get(use: tableController.all)
    tables.post(CreateTableRequest.self, at: "create", use: tableController.createNewTable)
    tables.put(TableUpdateRequest.self, at: Table.parameter, "update", "title", use: tableController.updateTableTitle)
    
    let listController = ListController()
    let lists = router.grouped("lists")
    
    lists.post(CreateListRequest.self, at: "create", use: listController.create)
    lists.get(use: listController.getAll)
    lists.get(List.parameter, use: listController.getById)
}
    
