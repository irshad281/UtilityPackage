//
//  LayoutSectionExtension.swift
//  
//
//  Created by Irshad Ahmad on 05/07/22.
//

import UIKit

extension NSCollectionLayoutSection {
    
    // MARK: - Add Header Footer To Section
    /// Add header view to respective section
    /// - Parameters:
    ///   - section: NSCollectionLayoutSection which needs to have header view
    func addHeaderFooterView(_ view: HeaderFooterView) {
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: view.height
            ),
            elementKind: view.identifier,
            alignment: view.position
        )
        self.boundarySupplementaryItems.append(header)
    }
}
