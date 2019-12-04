import FluentPostgreSQL
import Vapor
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())
    try services.register(AuthenticationProvider())
    
    //ONLY FOR RUNNING ON LOCALHOST
    if let poolLimitRaw = Environment.get("LIMIT_POOL"),
        let poolLimit = Int(poolLimitRaw) {
        let serverConfig = NIOServerConfig.default(workerCount: poolLimit)
        services.register(serverConfig)
    }
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Register middleware
    var middlewaresConfig = MiddlewareConfig()
    try middlewares(config: &middlewaresConfig)
    services.register(middlewaresConfig)
    
    // Register the configured SQLite database to the database config.
    var databasesConfig = DatabasesConfig()
    try databases(config: &databasesConfig, env: env)
    services.register(databasesConfig)
    
    // Configure migrations
    services.register { container -> MigrationConfig in
        var migrationConfig = MigrationConfig()
        try migrate(migrations: &migrationConfig)
        return migrationConfig
    }

    try services.register(AuthenticationProvider())
}
