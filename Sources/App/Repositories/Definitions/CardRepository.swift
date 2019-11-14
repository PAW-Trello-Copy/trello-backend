//
//  CardRepository.swift
//  App
//
//  Created by Artur Stepaniuk on 07/11/2019.
//

import Vapor

protocol CardRepository: ServiceType {
    func all() -> Future<[Card]>
    func find(by id: Int) -> Future<Card?>
    func create(with title: String, listId: Int?) -> Future<Card>
    func all(for listId: Int) -> EventLoopFuture<[Card]> 
}
