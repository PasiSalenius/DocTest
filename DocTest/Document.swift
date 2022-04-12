//
//  Document.swift
//  DocTest
//
//  Created by Pasi Salenius on 12.4.2022.
//

import UIKit

class Document: UIDocument {
    
    enum DocumentError: LocalizedError {
        case badData
        case invalidDocumentData
        
        public var errorDescription: String? {
            switch self {
            case .invalidDocumentData:
                return "Document data does not exist."
            case .badData:
                return "Document contents could not be read."
            }
        }
    }
    
    var string: String = ""

    private var directoryWrapper: FileWrapper?
    
    static func new(at fileURL: URL) throws {
        let fileWrapper = FileWrapper(regularFileWithContents: Data())
        fileWrapper.preferredFilename = "document"

        let directoryWrapper = FileWrapper(directoryWithFileWrappers: ["document": fileWrapper])
        
        try directoryWrapper.write(to: fileURL, options: [], originalContentsURL: nil)
    }

    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        
        guard
            let data = string.data(using: .utf8),
            let directoryWrapper = directoryWrapper,
            let oldFileWrapper = directoryWrapper.fileWrappers?["document"]
            else { throw DocumentError.invalidDocumentData }
        
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        fileWrapper.preferredFilename = "document"
        
        directoryWrapper.removeFileWrapper(oldFileWrapper)
        directoryWrapper.addFileWrapper(fileWrapper)

        return directoryWrapper
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
        
        guard
            let directoryWrapper = contents as? FileWrapper,
            let fileWrapper = directoryWrapper.fileWrappers?["document"],
            let data = fileWrapper.regularFileContents,
            let string = String(data: data, encoding: .utf8)
            else { throw DocumentError.badData }
        
        self.directoryWrapper = directoryWrapper
        self.string = string
    }
}

