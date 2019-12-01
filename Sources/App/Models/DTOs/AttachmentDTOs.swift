//
//  AttachmentDTOs.swift
//  App
//
//  Created by Artur Stepaniuk on 01/12/2019.
//

import Vapor

struct AttachmentUploadRequest: Content {
    var file: File
}

struct AttachmentInfoResponse: Content {
    var id: Int
    var filename: String
}
