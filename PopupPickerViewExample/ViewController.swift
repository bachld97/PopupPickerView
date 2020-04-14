//
//  ViewController.swift
//  PopupPickerViewExample
//
//  Created by Bach Le on 4/10/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

import UIKit
import PopupPickerView

class ViewController: UIViewController, PopupPickerViewDelegate {
  
  private let activationView = UIView()
  private let popupPickerPresenter = PopupPickerPresenter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
   
    popupPickerPresenter.viewDelegate = self
    popupPickerPresenter.pickerItemActivatedDimen = 100
    popupPickerPresenter.pickerItemDeactivatedDimen = 70
    popupPickerPresenter.pickerItemNormalDimen = 85

    activationView.frame = CGRect(x: 100, y: 100, width: 60, height: 60)
    activationView.backgroundColor = .black
    activationView.isUserInteractionEnabled = true
    
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleButtonLongPress(_:)))
    activationView.addGestureRecognizer(longPressGesture)
    
    self.view.addSubview(activationView)
  }
  
  func calculateOriginForPoupPicker(pickerSize: CGSize) -> CGPoint {
    let minX = (self.view.bounds.width - pickerSize.width) / 2
    let minY: CGFloat = 160 + 16
    return CGPoint(x: minX, y: minY)
  }
  
  func didSelectPickerItem(_ item: PopupPickerItemDisplayable?) {
    guard let entity = item?.extractEntity() as? String else {
      return
    }
    
    print("Did pick item with entity", entity)
  }
  
  @objc private func handleButtonLongPress(_ gesture: UILongPressGestureRecognizer) {
    popupPickerPresenter.showPicker(gesture: gesture,
                                    items: testDecoratorItems,
                                    itemBackground: itemBackground,
                                    viewActivatingPicker: activationView,
                                    viewToInsertPicker: self.view)
  }
  
  private lazy var testDecoratorItems: [PopupPickerItemDisplayable] = {
    let smallInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    let mediumInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    return [
      LottieAnimationDisplayable(lottieJsonName: "anim1")
        .withBackgroundColor(.purple)
        .withCornerStyle(.fixed(radius: 8))
        .withInsets(smallInsets),
      
      LottieAnimationDisplayable(lottieJsonName: "anim1")
        .withInsets(smallInsets)
        .withBackgroundColor(.purple)
        .withCornerStyle(.fixed(radius: 8)),
      
      LottieAnimationDisplayable(lottieJsonName: "anim1")
        .withInsets(smallInsets)
        .withCornerStyle(.fixed(radius: 8))
        .withBackgroundColor(.purple),
      
      LottieAnimationDisplayable(lottieJsonName: "anim1")
        .withCornerStyle(.fixed(radius: 8))
        .withBackgroundColor(.purple)
        .withInsets(smallInsets),
    ]
  }()
  
  private lazy var itemBackground: PopupPickerDisplayable = {
    return SimpleViewDisplayable().withBackgroundColor(.red)
  }()
}

