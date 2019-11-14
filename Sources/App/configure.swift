import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())
    
    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
    middlewares.use(corsMiddleware)
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    // Configure a SQLite database

//    let postgresql = PostgreSQLDatabase(config: getDatabaseConfiguration()!)
    
    // Register the configured SQLite database to the database config.
    var databasesConfig = DatabasesConfig()
    try databases(config: &databasesConfig, env: env)
//    databases.add(database: postgresql, as: .psql)
    services.register(databasesConfig)
    
    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Table.self, database: .psql)
    migrations.add(model: List.self, database: .psql)
    migrations.add(model: PostgresCardRepository.PostgresCard.self, database: .psql) // config depending on env
    services.register(migrations)
    
    services.register(PostgresCardRepository.self)
    
    // Register routes to the router
    
    services.register(Router.self) { container -> EngineRouter in
        let router = EngineRouter.default()
        try routes(router, container)
        return router
    }
}
