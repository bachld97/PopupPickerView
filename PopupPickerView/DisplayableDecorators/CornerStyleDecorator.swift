//
//  CornerStyleDecorator.swift
//  PopupPickerView
//
//  Created by Bach Le on 4/13/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

import Foundation
import UIKit

public enum CornerStyle {
  case fixed(radius: CGFloat)
  case circular
  case none
}

class CornerStyleDecorator: BaseDisplayableDecorator {
  private let style: CornerStyle
  
  init(style: CornerStyle, decoratedItem: PopupPickerItemDisplayable) {
    self.style = style
    super.init(decoratedItem: decoratedItem)
  }
  
  override public func layout(in rect: CGRect) {
    super.layout(in: rect)
    
    switch style {
      case .none:
        uiView.layer.cornerRadius = 0
      case .fixed(radius: let amount):
        uiView.layer.cornerRadius = amount
      case .circular:
        uiView.layer.cornerRadius = rect.height / 2      
    }
  }
}

public extension PopupPickerItemDisplayable {
  func withCornerStyle(_ style: CornerStyle) -> PopupPickerItemDisplayable {
    return CornerStyleDecorator(style: style, decoratedItem: self)
  }
}
