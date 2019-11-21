//
//  TableDTOs.swift
//  App
//
//  Created by Artur Stepaniuk on 21/11/2019.
//

import Vapor

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
