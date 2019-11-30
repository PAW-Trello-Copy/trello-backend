//
//  CardDTOs.swift
//  App
//
//  Created by Artur Stepaniuk on 21/11/2019.
//

import Vapor

struct CreateCardRequest: Content {
    var listId: List.ID
    var title: String
}

struct UpdateCardTitleRequest: Content {
    var title: String
}

struct UpdateCardDescriptionRequest: Content {
    var description: String
}

struct UpdateCardStateRequest: Content {
    var archived: Bool
}
