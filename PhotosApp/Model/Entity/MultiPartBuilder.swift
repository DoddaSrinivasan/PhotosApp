//
//  MultiPartBuilder.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 17/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Foundation

import Foundation

fileprivate let MultipartFormCRLF = "\r\n"
fileprivate let MutlipartFormCRLFData = MultipartFormCRLF.data(using: .utf8)!

class MultiPartBuilder {
    
    let boundary: String
    private var fields: [Data] = []
    
    
    public init(boundary: String) {
        self.boundary = boundary
    }
    
    convenience init() {
        self.init(boundary: "boundary\(UUID().uuidString)")
    }
    
    public func build() -> Data? {
        
        let data = NSMutableData()
        
        for field in self.fields {
            data.append(self.toData("--\(self.boundary)"))
            data.append(MutlipartFormCRLFData)
            data.append(field)
        }
        
        data.append(self.toData("--\(self.boundary)--"))
        data.append(MutlipartFormCRLFData)
        
        return (data.copy() as! Data)
    }
    
    public func addImage(name: String, content: Data, fileName: String) -> MultiPartBuilder {
        let contentDisposition = "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\""
        let contentTypeHeader = "Content-Type: image/png"
        
        let data = self.merge([
            toData(contentDisposition),
            MutlipartFormCRLFData,
            toData(contentTypeHeader),
            MutlipartFormCRLFData,
            MutlipartFormCRLFData,
            content,
            MutlipartFormCRLFData
            ])
        self.fields.append(data)
        return self
    }
    
    private func toData(_ string: String) -> Data {
        return string.data(using: .utf8)!
    }
    
    private func merge(_ chunks: [Data]) -> Data {
        let data = NSMutableData()
        for chunk in chunks {
            data.append(chunk)
        }
        return data.copy() as! Data
    }
    
}
