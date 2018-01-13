//
//  Drawing.swift
//  DrawingApp
//
//  Created by Gilles Vercammen on 1/3/18.
//  Copyright © 2018 Gilles Vercammen. All rights reserved.
//
import UIKit

protocol Drawing: Codable {
    var author: String { get set }
    var description: String  { get set }
    var image: UIImage { get set }
}

class Base64EncodedDrawing: Drawing, Codable {
    var author: String
    
    var description: String = ""
    
    var base64String: String = ""
    
    var image: UIImage {
        get {
            return UIImage(data: Data(base64Encoded: base64String, options: NSData.Base64DecodingOptions())!)!
        }
        set {
            base64String = UIImageJPEGRepresentation(newValue, 0.9)!.base64EncodedString(options: NSData.Base64EncodingOptions())
        }
    }
    
    init(author: String) {
        self.author = author
    }
    
    private enum CodingKeys: CodingKey {
        case author
        case description
        case base64String
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(author, forKey: .author)
        try container.encode(description, forKey: .description)
        try container.encode(base64String, forKey: .base64String)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let author = try container.decode(String.self, forKey: .author)
        let description = try container.decode(String.self, forKey: .description)
        let base64String = try container.decode(String.self, forKey: .base64String)
        self.author = author
        self.description = description
        self.base64String = base64String
    }
}
