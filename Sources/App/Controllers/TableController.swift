//
//  TableController.swift
//  App
//
//  Created by Artur Stepaniuk on 01/11/2019.
//

import FluentPostgreSQL
import Vapor

class TableController {
    
    func all(_ req: Request) -> Future<[Table]> {
        return Table.query(on: req).all()
    }

    func createNewTable(_ req: Request) throws -> Future<TableResponse> {
        return try req.content.decode(CreateTableRequest.self).flatMap { table -> Future<Table> in
            return Table(id: nil, title: table.title)
            .save(on: req)
        }.map { table in
            return try TableResponse(id: table.requireID(), title: table.title)
        }
    }

    func updateTableTitle(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.content.decode(UpdateRequest.self).then { tableToUpdate -> Future<Table> in
            return Table.query(on: req).filter(\.id == tableToUpdate.id).first().flatMap { table -> Future<Table> in
                guard let table = table else {
                    throw Abort(.custom(code: 409, reasonPhrase: "Table with id \(tableToUpdate.id) was not found"))
                }
                table.title = tableToUpdate.title
                return table.save(on: req)
            }
        }.transform(to: .ok)
    }
}

struct CreateTableRequest: Content {
    var title: String
}

struct TableResponse: Content {
    var id: Int?
    var title: String
}

struct UpdateRequest: Content {
    var id: Int?
    var title: String
   }
