//
//  migrate.swift
//  App
//
//  Created by Artur Stepaniuk on 21/11/2019.
//

import Vapor
import FluentPostgreSQL

public func migrate(migrations: inout MigrationConfig) throws {
    //table creations
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: UserToken.self, database: .psql)
    migrations.add(model: UserAndTable.self, database: .psql)
    migrations.add(model: Table.self, database: .psql)
    migrations.add(model: List.self, database: .psql)
    migrations.add(model: Card.self, database: .psql)
    migrations.add(model: Comment.self, database: .psql)
    migrations.add(model: Attachment.self, database: .psql)
    migrations.add(model: Label.self, database: .psql)
    migrations.add(model: CardAndLabel.self, database: .psql)
    
    //table updates
    migrations.add(migration: AddCardArchivization.self, database: .psql)
    migrations.add(migration: AddTableArchivization.self, database: .psql)
    migrations.add(migration: AddCommentHistory.self, database: .psql)
}
