//
//  TableController.swift
//  App
//
//  Created by Artur Stepaniuk on 01/11/2019.
//

import FluentPostgreSQL
import Vapor

class TableController {
    
    func all(_ req: Request) throws  -> Future<[Table]> {
        let user = try req.requireAuthenticated(User.self)
        return try user.tables.query(on: req).all()
    }
    
    func getById(_ req: Request) throws -> Future<Table> {
        return try req.parameters.next(Table.self)
    }

    func createNewTable(_ req: Request, content: CreateTableRequest) throws -> Future<Table> {
        let user = try req.requireAuthenticated(User.self)
        return Table(title: content.title).save(on: req).flatMap { table in
            return table.users.attach(user, on: req).map { _ in return table }
        }
    }

    func updateTableTitle(_ req: Request, content: TableUpdateRequest) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Table.self).map { table -> Future<Table> in
            table.title = content.title
            return table.save(on: req)
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

struct TableUpdateRequest: Content {
    var title: String
   }
