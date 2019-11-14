//
//  databases.swift
//  App
//
//  Created by Artur Stepaniuk on 09/11/2019.
//

import Vapor
import FluentPostgreSQL

public func databases(config: inout DatabasesConfig, env: Environment) throws {
    
    //TODO: add sqlite DB for tests
    switch env {
    case .testing:
        fallthrough
    default:
        let postgresConfig = try getPostgresConfig()
        config.add(database: PostgreSQLDatabase(config: postgresConfig), as: .psql)
    }
}


//this will crash if environment variables for DB are not set
private func getPostgresConfig() throws -> PostgreSQLDatabaseConfig {
    
    if let connectionUrl = Environment.get("DB_URL"), let config = PostgreSQLDatabaseConfig(url: connectionUrl, transport: .unverifiedTLS) {
        return config
    }
    
    guard let hostname = Environment.get("DB_HOSTNAME") else {
        assertionFailure("Environment variable for DB_HOSTNAME have not been provided")
        throw Abort(.internalServerError)
    }
    
    guard let portRaw = Environment.get("DB_PORT") else {
        assertionFailure("Environment variable for DB_PORT have not been provided")
        throw Abort(.internalServerError)
    }
    guard let port = Int(portRaw) else {
        assertionFailure("value for DB_PORT variable is not an integer")
        throw Abort(.internalServerError)
    }
    
    guard let username = Environment.get("DB_USERNAME") else {
        assertionFailure("Environment variable for DB_USERNAME have not been provided")
        throw Abort(.internalServerError)
    }
    
    guard let database = Environment.get("DB_DATABASE") else {
        assertionFailure("Environment variable for DB_DATABASE have not been provided")
        throw Abort(.internalServerError)
    }
    
    guard let password = Environment.get("DB_PASSWORD") else {
        assertionFailure("Environment variable for DB_PASSWORD have not been provided")
        throw Abort(.internalServerError)
    }
    
    return PostgreSQLDatabaseConfig(
        hostname: hostname,
        port: port,
        username: username,
        database: database,
        password: password,
        transport: .unverifiedTLS
    )
}
