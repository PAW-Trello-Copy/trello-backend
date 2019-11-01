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
}
