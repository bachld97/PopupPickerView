//
//  PopupPickerViewPresenter.swift
//  PopupPickerView
//
//  Created by Bach Le on 4/10/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

import UIKit
import Foundation

public class PopupPickerPresenter {
  
  // Configuration
  public var pickerItemNormalDimen: CGFloat = 40
  public var pickerItemActivatedDimen: CGFloat = 70
  public var pickerItemDeactivatedDimen: CGFloat = 30
  public var pickerItemVerticalPadding: CGFloat = 8
  public var pickerItemHorizontalPadding: CGFloat = 8
  
  public init() {}
  
  func calculateItemBackgroundOrigin(pickerSize: CGSize) -> CGPoint {
    return viewDelegate?.calculateOriginForPoupPicker(pickerSize: pickerSize) ?? .zero
  }
  
  public weak var viewDelegate: PopupPickerViewDelegate?
  
  private lazy var pickerView: PopupPickerView = {
    return .init(presenter: self)
  }()
  
  private var isAllowSecondChance = true
  
  private var currentGesture: UILongPressGestureRecognizer?
  
  private lazy var longPressSelectReaction: UILongPressGestureRecognizer = {
    let gesture = UILongPressGestureRecognizer(
      target: self, action: #selector(onLongPressSelectReaction(_:))
    )
    gesture.minimumPressDuration = 0
    return gesture
}()
  
  public func cancelPicker(animated: Bool, completion: ((Bool) -> Void)?) {
    currentGesture?.state = .cancelled
    currentGesture = nil
    pickerView.performExit(animated: animated, completion: completion)
  }
  
  public func showPicker(gesture: UILongPressGestureRecognizer,
                  items: [PopupPickerItemDisplayable],
                  itemBackground: PopupPickerDisplayable,
                  viewActivatingPicker: UIView,
                  viewToInsertPicker: UIView) {
    switch gesture.state {
      case .began:
        isAllowSecondChance = true
        currentGesture = gesture
        notifyMaxItemSize(to: items)
        displayPickerContent(in: viewToInsertPicker,
                             itemsToDisplay: items,
                             itemBackground: itemBackground,
                             relativeToView: viewActivatingPicker)
      default:
        onLongPressSelectReaction(gesture)
    }
  }
  
  private func notifyMaxItemSize(to items: [PopupPickerItemDisplayable]) {
    items.forEach {
      $0.notifyMaxItemDimen(pickerItemActivatedDimen)
    }
  }
  
  @objc private func onLongPressSelectReaction(_ gesture: UILongPressGestureRecognizer) {
    guard gesture == currentGesture else {
      return
    }
    
    switch gesture.state {
      case .changed:
        let currentFingerPosition = gesture.location(in: pickerView)
        updatePickerFingerPosition(currentFingerPosition)
      case .cancelled, .ended:
        onGestureShowPickerEnded()
      default:
        break
    }
  }
  
  private func displayPickerContent(in superview: UIView,
                            itemsToDisplay: [PopupPickerItemDisplayable],
                            itemBackground: PopupPickerDisplayable,
                            relativeToView anchorView: UIView) {
    pickerView.displayContent(in: superview,
                              items: itemsToDisplay,
                              itemBackground: itemBackground,
                              animated: true)
  }
  
  private func updatePickerFingerPosition(_ fingerPosition: CGPoint) {
    pickerView.updateFingerPosition(fingerPosition)
  }
  
  private func onGestureShowPickerEnded() {
    if isAllowSecondChance && pickerView.activatedItem == nil {
      isAllowSecondChance = false
      currentGesture = self.longPressSelectReaction
    } else {
      cancelPicker(animated: true, completion: { _ in
        self.notifyPickerExit()
      })
    }
  }
  
  private func notifyPickerExit() {
    viewDelegate?.didSelectPickerItem(pickerView.activatedItem)
  }
  
  func updateOverlayView(_ overlayView: UIView) {
    longPressSelectReaction.view?.removeGestureRecognizer(longPressSelectReaction)
    overlayView.addGestureRecognizer(longPressSelectReaction)
  }
}
