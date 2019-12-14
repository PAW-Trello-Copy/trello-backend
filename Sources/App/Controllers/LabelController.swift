//
//  ListController.swift
//  App
//
//  Created by Artur Stepaniuk on 03/11/2019.
//

import FluentPostgreSQL
import Vapor

class LabelController {
    
    func create(_ req: Request, content: CreateLabelRequest) throws -> Future<Label> {
        return Table.query(on: req).filter(\.id == content.tableId).first().flatMap { table in
            guard table != nil else {
                throw Abort(.custom(code: 409, reasonPhrase: "Table with id \(content.tableId) not found"))
            }
            return Label(title: content.title, tableId: content.tableId, color: content.color).save(on: req)
        }
    }
    
    func getAll(_ req: Request) throws -> Future<[Label]> {
        return Label.query(on: req).all()
    }
    
    func getById(_ req: Request) throws -> Future<Label> {
        return try req.parameters.next(Label.self)
    }
    
    func getAllForTable(_ req: Request) throws -> Future<[Label]> {
        return try req.parameters.next(Table.self).then { table -> Future<[Label]> in
            return Label.query(on: req).filter(\.tableId == table.id).all()
        }
    }

    func updateLabelTitle(_ req: Request, content: UpdateLabelTitleRequest) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Label.self).map { label -> Future<Label> in
            label.title = content.title
            return label.save(on: req)
        }.transform(to: .ok)
    }
    
   func updateLabelColor(_ req: Request, content: UpdateLabelColorRequest) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Label.self).map { label -> Future<Label> in
            label.color = content.color
            return label.save(on: req)
        }.transform(to: .ok)
    }

     func deleteById(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Label.self).map { label -> Future<Void> in
                return label.delete(on: req)
        }.transform(to: .ok)
    }     

}
