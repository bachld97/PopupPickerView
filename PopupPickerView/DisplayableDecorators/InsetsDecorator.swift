//
//  InsetsDecorator.swift
//  PopupPickerView
//
//  Created by Bach Le on 4/13/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

import Foundation
import UIKit

class InsetsDecorator: UIView, PopupPickerItemDisplayable {
  private let insets: UIEdgeInsets
  private let decoratedItem: PopupPickerItemDisplayable
  
  init(insets: UIEdgeInsets, decoratedItem: PopupPickerItemDisplayable) {
    self.insets = insets
    self.decoratedItem = decoratedItem
    
    super.init(frame: .zero)
    
    self.addSubview(decoratedItem.uiView)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func layout(in rect: CGRect) {
    layoutView(uiView, in: rect)
    
    let contentBounds = CGRect(origin: .zero, size: rect.size).inset(by: insets)
    decoratedItem.layout(in: contentBounds)
  }
}

public extension PopupPickerItemDisplayable {
  func withInsets(_ insets: UIEdgeInsets) -> PopupPickerItemDisplayable {
    return InsetsDecorator(insets: insets, decoratedItem: self)
  }
}
