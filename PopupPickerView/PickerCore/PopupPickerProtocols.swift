//
//  PopupPickerItemDisplayable.swift
//  PopupPickerView
//
//  Created by Bach Le on 4/12/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

import Foundation
import UIKit

public protocol PopupPickerItemDisplayable: PopupPickerDisplayable {
  func onActivated()
  func onDeactivated()
  func notifyMaxItemDimen(_ dimen: CGFloat)
}

public extension PopupPickerItemDisplayable {
  func onActivated() { }
  func onDeactivated() { }
  func notifyMaxItemDimen(_ dimen: CGFloat) { }
}

public protocol PopupPickerDisplayable: class {
  var uiView: UIView { get }
  func layout(in rect: CGRect)
}

extension PopupPickerDisplayable {
  func layoutView(_ view: UIView, in rect: CGRect) {
    view.alpha = 1
    view.isHidden = false
    view.frame = rect
  }
}

public extension PopupPickerDisplayable where Self: UIView {
  var uiView: UIView { return self }
  
  func layout(in rect: CGRect) {
    layoutView(self, in: rect)
  }
}

public protocol PopupPickerViewDelegate: class {
  func calculateOriginForPoupPicker(pickerSize: CGSize) -> CGPoint
  func didSelectPickerItem(_ item: PopupPickerItemDisplayable?)
}
