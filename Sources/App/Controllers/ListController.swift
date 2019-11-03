//
//  ListController.swift
//  App
//
//  Created by Artur Stepaniuk on 03/11/2019.
//

import FluentPostgreSQL
import Vapor

class ListController {
    
    func create(_ req: Request, content: CreateListRequest) throws -> Future<List> {
        return Table.query(on: req).filter(\.id == content.tableId).first().flatMap { table in
            guard table != nil else {
                throw Abort(.custom(code: 409, reasonPhrase: "Table with id \(content.tableId) not found"))
            }
            return List(title: content.title, tableId: content.tableId).save(on: req)
        }
    }
    
    func getAll(_ req: Request) throws -> Future<[List]> {
        return List.query(on: req).all()
    }
    
    func getById(_ req: Request) throws -> Future<List> {
        return try req.parameters.next(List.self)
    }
}


struct CreateListRequest: Content {
    var tableId: Table.ID
    var title: String
}
