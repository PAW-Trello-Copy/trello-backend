import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    
    
    let tableController = TableController()
    router.get("all", use: tableController.all)
    router.post("create/table", use: tableController.createNewTable)
    router.put("update/table/title", use: tableController.updateTableTitle)
    
    let listController = ListController()
    router.post(CreateListRequest.self, at: "tables", Int.parameter, "lists", "create",
                use: listController.create)
}
