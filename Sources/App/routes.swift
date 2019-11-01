import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    
    
    let tableContoller = TableController()
    router.get("all", use: tableContoller.all)
}
