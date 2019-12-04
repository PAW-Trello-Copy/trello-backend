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
        let archived: Bool = (try? req.query.get(Bool.self, at: "archived")) ?? false
        return try user.tables.query(on: req).filter(\.archived == archived).all()
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
    
    func updateTableState(_ req: Request, content: UpdateTableStateRequest) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Table.self).map { table -> Future<Table> in
            table.archived = content.archived
            return table.save(on: req)
        }.transform(to: .ok)
    }
    
    func deleteById(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Table.self).flatMap { table -> Future<Void> in
            if table.archived ?? false
            {
                return table.users.detachAll(on: req).flatMap { _ in
                    return table.delete(on: req)
                }
            }
            else {
                throw Abort(.badRequest)
            }
        }.transform(to: .ok)
    }
}
