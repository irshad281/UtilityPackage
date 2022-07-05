//
//  HeaderFooterView.swift
//  
//
//  Created by Irshad Ahmad on 05/07/22.
//

import UIKit

public struct HeaderFooterView {
    let identifier: String
    let position: NSRectAlignment
    let height: NSCollectionLayoutDimension
    
    public init(identifier: String, position: NSRectAlignment, height: NSCollectionLayoutDimension) {
        self.identifier = identifier
        self.position = position
        self.height = height
    }
}
