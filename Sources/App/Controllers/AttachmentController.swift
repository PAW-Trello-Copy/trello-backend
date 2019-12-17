//
//  AttachmentController.swift
//  App
//
//  Created by Artur Stepaniuk on 30/11/2019.
//

import Vapor

final class AttachmentController {
    
    func uploadForCard(_ req: Request, content: AttachmentUploadRequest) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Card.self).map { card -> Future<Attachment> in
            let user = try req.requireAuthenticated(User.self)
            
            return Attachment(authorId: try user.requireID(), cardId: card.id, title: content.file.filename, data: content.file.data, ext: content.file.ext).save(on: req)
        }.transform(to: .ok)
    }
    
    func getAttachmentsListForCard(_ req: Request) throws -> Future<[AttachmentInfoResponse]> {
        
        return try req.parameters.next(Card.self).then { card -> Future<[Attachment]> in
            return Attachment.query(on: req).filter(\.cardId, .equal, card.id).all()
        }.map { attachments in
            return attachments.map { AttachmentInfoResponse(id: $0.id!, filename: $0.title) }
        }
    }
    
    func uploadForComment(_ req: Request, content: AttachmentUploadRequest) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Comment.self).map { comment -> Future<Attachment> in
            let user = try req.requireAuthenticated(User.self)
            
            return Attachment(authorId: try user.requireID(), commentId: comment.id, title: content.file.filename, data: content.file.data, ext: content.file.ext).save(on: req)
        }.transform(to: .ok)
    }
    
    func getAttachmentsListForComment(_ req: Request) throws -> Future<[AttachmentInfoResponse]> {
        
        return try req.parameters.next(Comment.self).then { comment -> Future<[Attachment]> in
            return Attachment.query(on: req).filter(\.commentId, .equal, comment.id).all()
        }.map { attachments in
            return attachments.map { AttachmentInfoResponse(id: $0.id!, filename: $0.title) }
        }
    }
    
    func getAttachmentById(_ req: Request) throws -> Future<AttachmentResponse> {
        
        let attId = try req.parameters.next(Int.self)
        return Attachment.query(on: req).filter(\.id, .equal, attId).first().map { att in
            guard let att = att else {
                throw Abort(.custom(code: 409, reasonPhrase: "Attachment with id \(attId) not found"))
            }
            
            var mediaType: MediaType?
            if let extIndex = att.title.lastIndex(of: ".") {
                let type = att.title.suffix(from: att.title.index(after: extIndex))
                mediaType = MediaType.fileExtension(type.lowercased())
            }
            
            return AttachmentResponse(string64: att.data.base64EncodedString(), title: att.title, fileType: mediaType?.serialize())
        }
    }
    
    func getAttachmentFile(_ req: Request) throws -> Future<HTTPResponse> {
        return try req.parameters.next(Attachment.self).map { attachment in
            var message = HTTPResponse()
            
            if let extIndex = attachment.title.lastIndex(of: ".") {
                let type = attachment.title.suffix(from: attachment.title.index(after: extIndex))
                message.contentType = MediaType.fileExtension(type.lowercased())
            }
            message.body = HTTPBody(data: attachment.data)
            
            return message
        }
    }
    
    func deleteAttachment(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Attachment.self).flatMap { att in
            return att.delete(on: req)
        }.transform(to: .ok)
    }
}
