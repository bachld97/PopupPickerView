//
//  BaseDisplayableDecorator.swift
//  PopupPickerView
//
//  Created by Bach Le on 4/13/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

import Foundation
import UIKit

class BaseDisplayableDecorator: PopupPickerItemDisplayable {
  var uiView: UIView {
    return decoratedItem.uiView
  }
  
  func layout(in rect: CGRect) {
    decoratedItem.layout(in: rect)
  }
  
  var decoratedItem: PopupPickerItemDisplayable
  init(decoratedItem: PopupPickerItemDisplayable) {
    self.decoratedItem = decoratedItem
  }
  
  func onActivated() {
    decoratedItem.onActivated()
  }
  
  func onDeactivated() {
    decoratedItem.onDeactivated()
  }
}
