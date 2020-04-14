//
//  BackgroundColorDecorator.swift
//  PopupPickerView
//
//  Created by Bach Le on 4/13/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

import Foundation
import UIKit

class BackgroundColorDecorator: BaseDisplayableDecorator {
  private let color: UIColor
  
  init(color: UIColor, decoratedItem: PopupPickerItemDisplayable) {
    self.color = color
    super.init(decoratedItem: decoratedItem)
  }
  
  override public func layout(in rect: CGRect) {
    super.layout(in: rect)
    self.uiView.backgroundColor = color
  }
}

public extension PopupPickerItemDisplayable {
  func withBackgroundColor(_ color: UIColor) -> PopupPickerItemDisplayable {
    return BackgroundColorDecorator(color: color, decoratedItem: self)
  }
}
