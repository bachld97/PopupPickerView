//
//  ShadowDecorator.swift
//  PopupPickerView
//
//  Created by Bach Le on 4/14/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

import Foundation
import UIKit

class ShadowDecorator: BaseDisplayableDecorator {
  private let shadow: ShadowInfo
  
  init(shadow: ShadowInfo, decoratedItem: PopupPickerItemDisplayable) {
    self.shadow = shadow
    super.init(decoratedItem: decoratedItem)
  }
  
  override public func layout(in rect: CGRect) {
    super.layout(in: rect)
    self.uiView.layer.applyShadow(shadow)
  }
}

fileprivate extension CALayer {
  func applyShadow(_ shadow: ShadowInfo) {
    shadowColor = shadow.color.cgColor
    shadowOpacity = Float(shadow.opacity)
    shadowOffset = shadow.offset
    shadowRadius = shadow.radius
  }
}

public extension PopupPickerItemDisplayable {
  func withShadow(_ shadow: ShadowInfo) -> PopupPickerItemDisplayable {
    return ShadowDecorator(shadow: shadow, decoratedItem: self)
  }
}

public struct ShadowInfo {
  public var color: UIColor
  public var opacity: CGFloat
  public var offset: CGSize
  public var radius: CGFloat
  
  public static var defaultShadow: ShadowInfo {
    let color: UIColor = .black
    let opacity: CGFloat = 0.3
    let offset: CGSize = CGSize(width: 0, height: 4)
    let radius: CGFloat = 4
    return .init(color: color, opacity: opacity, offset: offset, radius: radius)
  }
}
