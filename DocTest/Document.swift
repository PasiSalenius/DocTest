//
//  Document.swift
//  DocTest
//
//  Created by Pasi Salenius on 12.4.2022.
//

import UIKit

class Document: UIDocument {
    
    enum DocumentError: LocalizedError {
        case badDocumentFile
        case invalidDocument
        
        public var errorDescription: String? {
            switch self {
            case .invalidDocument:
                return "Document data does not exist."
            case .badDocumentFile:
                return "Document file cannot not be read."
            }
        }
    }
    
    private var directoryWrapper: FileWrapper?

    var text: String?
    
    static func new(at fileURL: URL) throws {
        let fileWrapper = FileWrapper(regularFileWithContents: Data())
        fileWrapper.preferredFilename = "document"

        let directoryWrapper = FileWrapper(directoryWithFileWrappers: ["document": fileWrapper])
        
        try directoryWrapper.write(to: fileURL, options: [], originalContentsURL: nil)
    }

    override func contents(forType typeName: String) throws -> Any {
        guard
            let data = text?.data(using: .utf8),
            let directoryWrapper = directoryWrapper,
            let oldFileWrapper = directoryWrapper.fileWrappers?["document"]
            else { throw DocumentError.invalidDocument }
        
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        fileWrapper.preferredFilename = "document"
        
        directoryWrapper.removeFileWrapper(oldFileWrapper)
        directoryWrapper.addFileWrapper(fileWrapper)

        return directoryWrapper
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard
            let directoryWrapper = contents as? FileWrapper,
            let fileWrapper = directoryWrapper.fileWrappers?["document"],
            let data = fileWrapper.regularFileContents,
            let string = String(data: data, encoding: .utf8)
            else { throw DocumentError.badDocumentFile }
        
        self.directoryWrapper = directoryWrapper
        self.text = string
    }
}

