//
//  extensions.swift
//  App
//
//  Created by Artur Stepaniuk on 09/11/2019.
//

import Vapor
import Fluent


//MARK: Global database extension
extension Database {
    public typealias ConnectionPool = DatabaseConnectionPool<ConfiguredDatabase<Self>>
}

extension Int {
    static func getId(from value: String) throws -> Int {
        if let id = Int(value) {
            return id
        }
        
        throw RoutingError(identifier: "parameterParsing", reason: "Could not convert parameter \(parameter) to type \(Int.self)")
    }
}
