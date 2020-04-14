//
//  PopupPickerView.swift
//  PopupPickerView
//
//  Created by Bach Le on 4/10/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

import Foundation
import UIKit

class PopupPickerView: UIView {
  
  private var presenter: PopupPickerPresenter
  private lazy var overlayView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    view.isUserInteractionEnabled = true
    return view
  }()
  
  init(presenter: PopupPickerPresenter) {
    self.presenter = presenter
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private var items: [PopupPickerItemDisplayable] = []
  private var itemBackground: PopupPickerDisplayable? = nil
  
  private(set) var activatedItem: PopupPickerItemDisplayable? {
    didSet {
      if let item = self.activatedItem {
        item.onActivated()
      }
      
      self.items.filter {
        return $0 !== activatedItem
      }.forEach {
        $0.onDeactivated()
      }
      
      if oldValue !== activatedItem {
        layoutContent(animated: true)
      }
    }
  }
  
  private var itemBackgroundFrame: CGRect {
    let noItemIsActivated = (activatedItem == nil)
    
    let fCount = CGFloat(items.count)
    let horizontalSpacingTotal = (fCount + 1) * presenter.pickerItemHorizontalPadding
    let iconSizeTotal: CGFloat
    let backgroundHeight: CGFloat
    if noItemIsActivated {
      iconSizeTotal = fCount * presenter.pickerItemNormalDimen
      backgroundHeight = presenter.pickerItemNormalDimen + 2 * presenter.pickerItemVerticalPadding
    } else {
      iconSizeTotal = (fCount - 1) * presenter.pickerItemDeactivatedDimen + presenter.pickerItemActivatedDimen
      backgroundHeight = presenter.pickerItemDeactivatedDimen + 2 * presenter.pickerItemVerticalPadding
    }
    
    let backgroundWidth = iconSizeTotal + horizontalSpacingTotal
    let itemBackgroundSize: CGSize = CGSize(width: backgroundWidth, height: backgroundHeight)
    let pickerHeight = max(backgroundHeight, presenter.pickerItemActivatedDimen)
    
    let itemBackgroundOrigin = presenter.calculateItemBackgroundOrigin(
      pickerSize: CGSize(width: backgroundWidth, height: pickerHeight)
    )
    return CGRect(origin: itemBackgroundOrigin, size: itemBackgroundSize)
  }
  
  private func calculateItemFrames(backgroundOrigin: CGPoint) -> [CGRect] {
    var itemFrames = [CGRect]()
    var accumulatedOffset: CGFloat = presenter.pickerItemHorizontalPadding
    let deactivatedDimen = (activatedItem == nil) ? presenter.pickerItemNormalDimen : presenter.pickerItemDeactivatedDimen
    
    for itemIndex in 0..<items.count {
      let isItemActivated = (items[itemIndex] === activatedItem)
      let itemDimen = isItemActivated ? presenter.pickerItemActivatedDimen : deactivatedDimen
      itemFrames.append(CGRect(
        x: backgroundOrigin.x + accumulatedOffset,
        y: backgroundOrigin.y + presenter.pickerItemVerticalPadding + deactivatedDimen - itemDimen,
        width: itemDimen,
        height: itemDimen
      ))
      accumulatedOffset += presenter.pickerItemHorizontalPadding + itemDimen
    }
    return itemFrames
  }
  
  func displayContent(in superview: UIView,
                      items: [PopupPickerItemDisplayable],
                      itemBackground: PopupPickerDisplayable,
                      animated: Bool = true) {
    addSelfToSuperview(superview)
    addBackgroundUIViewToSelf(itemBackground)
    addItemsUIViewToSelf(items)
    addOverlayViewToSelf()
    layoutContent(animated: animated)
  }
  
  private func addSelfToSuperview(_ superview: UIView) {
    if self.superview != superview {
      self.removeFromSuperview()
      superview.addSubview(self)
    }
    
    self.frame = superview.bounds
  }
  
  private func addBackgroundUIViewToSelf(_ itemBackground: PopupPickerDisplayable) {
    cleanupOldBackgroundItem(newItemBackground: itemBackground)
    self.itemBackground = itemBackground
    
    itemBackground.layout(in: itemBackgroundFrame)
    self.addSubview(itemBackground.uiView)
  }
  
  private func cleanupOldBackgroundItem(newItemBackground: PopupPickerDisplayable) {
    guard let itemBackground = self.itemBackground else {
      return
    }
    
    if itemBackground !== newItemBackground {
      itemBackground.uiView.removeFromSuperview()
    }
    self.itemBackground = newItemBackground
  }
  
  private func addItemsUIViewToSelf(_ items: [PopupPickerItemDisplayable]) {
    cleanupOldPickerItems()
    self.items = items
    
    items.forEach {
      if $0.uiView.superview != self {
        $0.uiView.removeFromSuperview()
        self.addSubview($0.uiView)
      }
    }
  }
  
  private func cleanupOldPickerItems() {
    items.forEach {
      $0.onDeactivated()
      $0.uiView.removeFromSuperview()
    }
    items.removeAll()
  }
  
  private func addOverlayViewToSelf() {
    if overlayView.superview !== self {
      overlayView.removeFromSuperview()
      self.addSubview(overlayView)
    }
    overlayView.frame = self.bounds
    overlayView.alpha = 1
    presenter.updateOverlayView(overlayView)
  }
  
  private func layoutContent(animated: Bool) {
    if animated {
      UIView.animate(withDuration: 0.3, animations: performLayout)
    } else {
      performLayout()
    }
  }
  
  private func performLayout() {
    let backgroundFrame = itemBackgroundFrame
    itemBackground?.layout(in: backgroundFrame)
    
    let itemFrames = calculateItemFrames(backgroundOrigin: backgroundFrame.origin)
    guard items.count == itemFrames.count else {
      let assertMessage = "Number of items and frames are inconsistent. Number of items: \(items.count), number of item frames: \(itemFrames.count)"
      return assertionFailure(assertMessage)
    }
    
    for itemIndex in 0..<items.count {
      items[itemIndex].layout(in: itemFrames[itemIndex])
    }
  }
  
  func updateFingerPosition(_ fingerPosition: CGPoint) {
    // deactivate `activatedItem` if finger is too far in any direction
    guard isFingerInActivationZone(fingerPosition) else {
      activatedItem?.onDeactivated()
      activatedItem = nil
      return
    }
    
    // Activate corresponding `item` based on finger postion
    let currentItemFrames = items.map { $0.uiView.frame }
    let fingerX = fingerPosition.x
    let halfPadding = presenter.pickerItemHorizontalPadding / 2
    
    for index in 0..<currentItemFrames.count {
      let frame = currentItemFrames[index]
      if frame.minX - halfPadding <= fingerX && fingerX <= frame.maxX + halfPadding {
        activatedItem = items[index]
        return
      }
    }
    
    // If all above fail, the finger is either at beginning or last item
    if fingerX < currentItemFrames.first?.minX ?? 0 {
      activatedItem = items.first
    } else {
      activatedItem = items.last
    }
  }
  
  private func isFingerInActivationZone(_ fingerPosition: CGPoint) -> Bool {
    let currentItemFrames = items.map { $0.uiView.frame }
    guard let maxY = currentItemFrames.max(by: { return $0.maxY > $1.maxY })?.maxY,
          let minY = currentItemFrames.max(by: { return $0.minY < $1.minY })?.minY,
          let minX = currentItemFrames.first?.minX,
          let maxX = currentItemFrames.last?.maxX else {
      assertionFailure("Invalid flow of control..")
      return false
    }
    
    let isFingerTooFarAbove = fingerPosition.y < minY - presenter.pickerItemNormalDimen
    let isFingerTooFarBelow = fingerPosition.y > maxY + presenter.pickerItemNormalDimen
    let isFingerTooFarLeft = fingerPosition.x < minX - presenter.pickerItemNormalDimen
    let isFingerTooFarRight = fingerPosition.x > maxX + presenter.pickerItemNormalDimen
    return !(isFingerTooFarAbove || isFingerTooFarBelow || isFingerTooFarLeft || isFingerTooFarRight)
  }
  
  func performExit(animated: Bool, completion: ((Bool) -> Void)?) {
    let exitBlock: (Bool) -> Void = { animationDidFinish in
      completion?(animationDidFinish)
      if animationDidFinish {
        self.overlayView.removeFromSuperview()
        self.cleanupOldPickerItems()
        self.itemBackground?.uiView.removeFromSuperview()
        self.itemBackground = nil
        self.activatedItem = nil
        self.removeFromSuperview()
      }
    }
    
    let exitAnimationBlock: () -> Void = {
      self.overlayView.alpha = 0
      self.itemBackground?.uiView.alpha = 0
      self.items.forEach {
        $0.uiView.alpha = 0
      }
    }
    
    if animated {
      UIView.animate(withDuration: 0.2, animations: exitAnimationBlock, completion: exitBlock)
    } else {
      exitBlock(true)
    }
  }
}
