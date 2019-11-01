//
//  TableController.swift
//  App
//
//  Created by Artur Stepaniuk on 01/11/2019.
//

import Vapor

class TableController {
    
    func all(_ req: Request) -> Future<[Table]> {
        return Table.query(on: req).all()
    }

    func create(_ req: Request) throws -> Future<TableResponse> {
        return try req.content.decode(CreateTableRequest.self).flatMap { table -> Future<Table> in
            return Table(id: nil, title: table.title)
            .save(on: req)
        }.map { table in
            return try TableResponse(id: table.requireID(), title: table.title)
        }
    }
}

struct CreateTableRequest: Content {
    var title: String
}

struct TableResponse: Content {
    var id: Int?
    var title: String
}
