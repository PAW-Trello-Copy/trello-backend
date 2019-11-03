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
        let tableId = try req.parameters.next(Int.self)
        
        return Table.query(on: req).filter(\.id == tableId).first().flatMap { table -> Future<List> in
            return List(title: content.title, tableId: tableId).save(on: req)
        }
    }
}


struct CreateListRequest: Content {
    var title: String
}
