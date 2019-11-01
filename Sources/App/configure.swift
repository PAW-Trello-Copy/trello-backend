import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())
    
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    // Configure a SQLite database

    let postgresql = PostgreSQLDatabase(config: getDatabaseConfiguration()!)
    
    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: postgresql, as: .psql)
    services.register(databases)
    
    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Table.self, database: .psql)
    services.register(migrations)
}

//this will crash if environment variables for DB are not set
private func getDatabaseConfiguration() -> PostgreSQLDatabaseConfig? {
    
    if let connectionUrl = Environment.get("DB_URL") {
        return PostgreSQLDatabaseConfig(url: connectionUrl, transport: .unverifiedTLS)
    }
    
    guard let hostname = Environment.get("DB_HOSTNAME") else {
        assertionFailure("Environment variable for DB_HOSTNAME have not been provided")
        return nil
    }
    
    guard let portRaw = Environment.get("DB_PORT") else {
        assertionFailure("Environment variable for DB_PORT have not been provided")
        return nil
    }
    guard let port = Int(portRaw) else {
        assertionFailure("value for DB_PORT variable is not an integer")
        return nil
    }
    
    guard let username = Environment.get("DB_USERNAME") else {
        assertionFailure("Environment variable for DB_USERNAME have not been provided")
        return nil
    }
    
    guard let database = Environment.get("DB_DATABASE") else {
        assertionFailure("Environment variable for DB_DATABASE have not been provided")
        return nil
    }
    
    guard let password = Environment.get("DB_PASSWORD") else {
        assertionFailure("Environment variable for DB_PASSWORD have not been provided")
        return nil
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
