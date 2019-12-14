//
//  ListDTOs.swift
//  App
//
//  Created by Artur Stepaniuk on 21/11/2019.
//

import Vapor

struct CreateLabelRequest: Content {
    var tableId: Table.ID
    var title: String
    var color: String
}

struct UpdateLabelTitleRequest: Content {
    var title: String
}

struct UpdateLabelColorRequest: Content {
    var color: String
}