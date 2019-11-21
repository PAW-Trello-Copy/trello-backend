//
//  ListDTOs.swift
//  App
//
//  Created by Artur Stepaniuk on 21/11/2019.
//

import Vapor

struct CreateListRequest: Content {
    var tableId: Table.ID
    var title: String
}
