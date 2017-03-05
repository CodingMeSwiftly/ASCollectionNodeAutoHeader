//
//  View.swift
//  AutoHeader
//
//  Created by Maximilian Kraus on 05.03.17.
//  Copyright © 2017 Maximilian Kraus. All rights reserved.
//

import AsyncDisplayKit
import CHTCollectionViewWaterfallLayout

class View: UIView {
  
  let collectionNode: ASCollectionNode
  let collectionViewLayout = CHTCollectionViewWaterfallLayout()
  
  override init(frame: CGRect) {
    
    collectionNode = ASCollectionNode(collectionViewLayout: collectionViewLayout)
    
    super.init(frame: .zero)
    
    collectionNode.backgroundColor = .clear
    collectionNode.view.alwaysBounceVertical = true
    
    addSubnode(collectionNode)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("Storyboards are incompatible with truth and beauty.")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    collectionNode.frame = bounds
    collectionNode.view.contentInset = .zero
    collectionNode.view.scrollIndicatorInsets = .zero
    
    collectionViewLayout.sectionInset = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
    collectionViewLayout.minimumColumnSpacing = 16
    collectionViewLayout.minimumInteritemSpacing = 16
  }
}
