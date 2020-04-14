//
//  InsetsDecorator.swift
//  PopupPickerView
//
//  Created by Bach Le on 4/13/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

import Foundation
import UIKit

class InsetsDecorator: BaseDisplayableDecorator {
  private let insets: UIEdgeInsets
  
  init(insets: UIEdgeInsets, decoratedItem: PopupPickerItemDisplayable) {
    self.insets = insets
    super.init(decoratedItem: decoratedItem)
  }
  
  override public func layout(in rect: CGRect) {
    let smallerRect = rect.inset(by: insets)
    super.layout(in: smallerRect)
  }
}

public extension PopupPickerItemDisplayable {
  func withInsets(_ insets: UIEdgeInsets) -> PopupPickerItemDisplayable {
    return InsetsDecorator(insets: insets, decoratedItem: self)
  }
}
