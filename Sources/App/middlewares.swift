//
//  middlewares.swift
//  App
//
//  Created by Artur Stepaniuk on 21/11/2019.
//

import Vapor

public func middlewares(config: inout MiddlewareConfig) throws {
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
    config.use(corsMiddleware)
    config.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response

}
