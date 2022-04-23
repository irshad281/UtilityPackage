//
//  Layout.swift
//  
//
//  Created by Irshad Ahmad on 08/06/22.
//

import Foundation
import UIKit

public extension NSDirectionalEdgeInsets {
    static let defaultValue = NSDirectionalEdgeInsets(top: .zero, leading: 12, bottom: .zero, trailing: 12)
}

public class Layout {
    
    // MARK: - Get Horizontal
    /// Add header view to respective section
    /// - Parameters:
    ///   - itemWidth: Item Width
    ///   - itemHeight: Item Height
    ///   - itemSpacing: NSCollectionLayoutDimension
    ///   - contentInsets: NSDirectionalEdgeInsets
    ///   - headerView: Header View
    ///   - footerView: Footer View
    ///   - Returns: NSCollectionLayoutSection
    public class func gridLayout(
        itemWidth: NSCollectionLayoutDimension = .estimated(50),
        itemHeight: NSCollectionLayoutDimension = .absolute(40),
        itemSpacing: CGFloat = 10,
        contentInsets: NSDirectionalEdgeInsets = .defaultValue,
        headerView: HeaderFooterView? = nil,
        footerView: HeaderFooterView? = nil
    ) -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout(
            section: Layout.gridLayoutSection(
                itemWidth: itemWidth,
                itemHeight: itemHeight,
                itemSpacing: itemSpacing,
                contentInsets: contentInsets,
                headerView: headerView,
                footerView: footerView
            )
        )
    }
    
    public class func gridLayoutSection(
        itemWidth: NSCollectionLayoutDimension = .estimated(50),
        itemHeight: NSCollectionLayoutDimension = .absolute(40),
        itemSpacing: CGFloat = 10,
        contentInsets: NSDirectionalEdgeInsets = .defaultValue,
        headerView: HeaderFooterView? = nil,
        footerView: HeaderFooterView? = nil
    ) -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: itemWidth,
                heightDimension: itemHeight
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(200)
            ),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(itemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = itemSpacing
        section.contentInsets = contentInsets
            
        if let headerView = headerView {
            addHeaderFooterTo(section: section, view: headerView)
        }
        
        if let footerView = footerView {
            addHeaderFooterTo(section: section, view: footerView)
        }
        
        return section
    }
}

private extension Layout {
    
    // MARK: - Add Header Footer To Section
    /// Add header view to respective section
    /// - Parameters:
    ///   - section: NSCollectionLayoutSection which needs to have header view
    class func addHeaderFooterTo(section: NSCollectionLayoutSection, view: HeaderFooterView) {
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: view.height
            ),
            elementKind: view.identifier,
            alignment: view.position
        )
        section.boundarySupplementaryItems.append(header)
    }
}


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
