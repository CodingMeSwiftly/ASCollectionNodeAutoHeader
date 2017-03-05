//
//  Data.swift
//  AutoHeader
//
//  Created by Maximilian Kraus on 05.03.17.
//  Copyright © 2017 Maximilian Kraus. All rights reserved.
//

import AsyncDisplayKit


let loremIpsum = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."

let numberOfSections = 5
let numberOfItemsInEachSection = 15


struct SectionData {
  var headerText: String?
  var textsForItems: [String]
  
  static func createSampleData() -> [SectionData] {
    return (0...numberOfSections).map { _ in
      SectionData(
        headerText: .random,
        textsForItems: (0...numberOfItemsInEachSection).map { _ in .random }
      )
    }
  }
}

private extension String {
  static var random: String {
    return loremIpsum.randomSubstring
  }
  
  private var randomSubstring: String {
    let endIndex = index(startIndex, offsetBy: .random(min: 15, max: characters.count / 2))
    return self.substring(to: endIndex)
  }
}

private extension Int {
  static func random(min: Int, max: Int) -> Int {
    assert(min < max, "min must be smaller than max")
    let delta = max - min
    return min + Int(arc4random_uniform(UInt32(delta)))
  }
}
