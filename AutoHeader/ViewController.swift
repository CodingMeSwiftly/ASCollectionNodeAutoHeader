//
//  ViewController.swift
//  AutoHeader
//
//  Created by Maximilian Kraus on 05.03.17.
//  Copyright © 2017 Maximilian Kraus. All rights reserved.
//

import AsyncDisplayKit
import CHTCollectionViewWaterfallLayout

/// A sample implementation of self-sizing supplementary nodes with a custom UICollectionViewLayout subclass.
///
/// Note that this sample is for educational purposes only. In a `real world` application, it is very bad practice to put all
/// of this code in a view controller class.
class ViewController: UIViewController {
  
  let data = SectionData.createSampleData()

  override func loadView() {
    let view = View()
    view.frame = UIScreen.main.bounds
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.view = view
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor(white: 0.95, alpha: 1)
    
    //  Very important! Register all of the supplementary node types you intent to use upfront.
    collectionNode.registerSupplementaryNode(ofKind: CHTCollectionElementKindSectionHeader)
    
    //  Bad practice! Factor these out in individual classes.
    collectionNode.view.layoutInspector = self
    collectionNode.dataSource = self
    collectionNode.delegate = self
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}


//MARK: - Subviews
extension ViewController {
  var mx_view: View {
    return view as! View
  }
  
  var collectionNode: ASCollectionNode {
    return mx_view.collectionNode
  }
}
//  -


//MARK: - ASCollectionDataSource
extension ViewController: ASCollectionDataSource {
  
  //  This should be self-explaning.
  
  func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
    return data.count
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
    return data[section].textsForItems.count
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
    let text = data[indexPath.section].textsForItems[indexPath.item]
    return {
      let node = ASTextCellNode()
      node.backgroundColor = .white
      node.text = text
      return node
    }
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
    guard let text = data[indexPath.section].headerText else { return ASCellNode() }
    
    let node = ASTextCellNode()
    node.backgroundColor = .magenta
    node.text = text
    return node
  }
}
//  -


//MARK: - ASCollectionDelegate
//  We need to conform to `ASCollectionDelegate` (and by that to `UICollectionViewDelegate`), because `CHTCollectionViewWaterfallLayout` uses the
//  collectionViews delegate and casts it internally to `CHTCollectionViewDelegateWaterfallLayout`. Since we are using `ASCollectionNode`, we
//  must conform to `ASCollectionDelegate` for `collectionNode.delegate = self` to work.
extension ViewController: ASCollectionDelegate {}
//  -


//MARK: - CHTCollectionViewDelegateWaterfallLayout
extension ViewController: CHTCollectionViewDelegateWaterfallLayout {
  
  //  Here we return the actual calculated sizes for both items and headers.
  //  This has to be changed to suit whatever custom `UICollectionViewLayout` you are using.
  
  func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAt indexPath: IndexPath!) -> CGSize {
    if let node = collectionNode.nodeForItem(at: indexPath) {
      return node.calculatedSize
    }

    return .zero
  }
  
  func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, heightForHeaderInSection section: Int) -> CGFloat {
    if let node = collectionNode.view.supplementaryNode(forElementKind: CHTCollectionElementKindSectionHeader, at: IndexPath(item: 0, section: section)) {
      return node.calculatedSize.height
    }
    
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, columnCountForSection section: Int) -> Int {
    return 2
  }
}
//  -


//MARK: - ASCollectionViewLayoutInspecting
extension ViewController: ASCollectionViewLayoutInspecting {
  
  //  You provide the constrained sizes for both plain cells and supplementary nodes here.
  //  Note that the values are tightly coupled to the specific `UICollectionViewLayout` object you are using.
  //  E.g. here we are using `CHTCollectionViewWaterfallLayout`. This class provides a convenience method for
  //  calculating the width of cells in a given section (`itemWidthInSection(at:)`.
  //  For supplementary nodes, we provide a constrained size that spans the entire width of the collectionView.
  //  If you were to change properties on the layout that affect the size of supplementary nodes (headers in this case),
  //  you would have to change the values returned from this method accordingly.
  //  E.g.: If you were to set the `headerInset` property of the layout object (or implement 
  //  `collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, insetForHeaderInSection section: Int) -> UIEdgeInsets` in the `CHTCollectionViewDelegateWaterfallLayout`),
  //  you would have to account for those insets here and return a constrainedWidth inset by the specified UIEdgeInsets.
  
  func collectionView(_ collectionView: ASCollectionView, constrainedSizeForNodeAt indexPath: IndexPath) -> ASSizeRange {
    guard let layout = collectionView.collectionViewLayout as? CHTCollectionViewWaterfallLayout else { return ASSizeRange() }
    
    let columnWidth = layout.itemWidthInSection(at: indexPath.section)
    
    return ASSizeRange(
      min: CGSize(width: columnWidth, height: 0),
      max: CGSize(width: columnWidth, height: .greatestFiniteMagnitude)
    )
  }
  
  func collectionView(_ collectionView: ASCollectionView, constrainedSizeForSupplementaryNodeOfKind kind: String, at indexPath: IndexPath) -> ASSizeRange {
    let constrainedWidth = collectionView.frame.width
    
    return ASSizeRange(
      min: CGSize(width: constrainedWidth, height: 0),
      max: CGSize(width: constrainedWidth, height: .greatestFiniteMagnitude)
    )
  }
  
  
  //  Whatever suits your case.
  func scrollableDirections() -> ASScrollDirection {
    return .down
  }
  
  
  //  These two methods are required for supplementary nodes to work properly. 
  //  Not implementing them will cause a (justified) crash.
  //  -
  
  func collectionView(_ collectionView: ASCollectionView, numberOfSectionsForSupplementaryNodeOfKind kind: String) -> UInt {
    let predicate: (SectionData) -> Bool
    
    switch kind {
    case CHTCollectionElementKindSectionHeader:
      predicate = { $0.headerText != nil }
    default:
      return 0
    }
    
    return UInt(data.filter(predicate).count)
  }
  
  func collectionView(_ collectionView: ASCollectionView, supplementaryNodesOfKind kind: String, inSection section: UInt) -> UInt {
    let sectionModel = data[Int(section)]
    
    switch kind {
    case CHTCollectionElementKindSectionHeader:
      return sectionModel.headerText == nil ? 0 : 1
    default:
      return 0
    }
  }
  
  //  -
}
//  -

