//
//  migrate.swift
//  App
//
//  Created by Artur Stepaniuk on 21/11/2019.
//

import Vapor
import FluentPostgreSQL

public func migrate(migrations: inout MigrationConfig) throws {
    migrations.add(model: Table.self, database: .psql)
    migrations.add(model: List.self, database: .psql)
    migrations.add(model: Card.self, database: .psql)
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: UserToken.self, database: .psql)
    migrations.add(model: UserAndTable.self, database: .psql)
}
