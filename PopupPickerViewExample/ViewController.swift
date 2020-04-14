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
    popupPickerPresenter.pickerItemActivatedDimen = 120
    popupPickerPresenter.pickerItemDeactivatedDimen = 80
    popupPickerPresenter.pickerItemNormalDimen = 90

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
    let smallInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    let mediumInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    return [
      LottieAnimationDisplayable(lottieJsonName: "anim1"),
      LottieAnimationDisplayable(lottieJsonName: "anim2"),
      LottieAnimationDisplayable(lottieJsonName: "FeedLikedAnimation")
    ]
  }()
  
  private lazy var itemBackground: PopupPickerDisplayable = {
    return SimpleViewDisplayable().withBackgroundColor(.red).withCornerStyle(.circular)
  }()
}

