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
    popupPickerPresenter.pickerItemActivatedDimen = 100 / 2
    popupPickerPresenter.pickerItemDeactivatedDimen = 70 / 2
    popupPickerPresenter.pickerItemNormalDimen = 85 / 2
    
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
        .withBackgroundColor(.black)
        .withCornerStyle(.circular)
        .withEntity(ReactionEntity(id: "1"))
        .withInsets(smallInsets),
      
      LottieAnimationDisplayable(lottieJsonName: "anim1")
        .withInsets(smallInsets)
        .withBackgroundColor(.blue)
        .withCornerStyle(.circular)
        .withEntity(ReactionEntity(id: "2")),
      
      LottieAnimationDisplayable(lottieJsonName: "FeedLikedAnimation")
        .withEntity(ReactionEntity(id: "3")),
      
      ImageViewDisplayable(image: UIImage(named: "tickBadge"))
        .withBackgroundColor(.green)
        .withInsets(smallInsets)
        .withShadow(.defaultShadow)
        .withEntity(ReactionEntity(id: "4")),
      
      ImageViewDisplayable(image: UIImage(named: "tickBadge"))
        .withInsets(smallInsets)
        .withBackgroundColor(.green)
        .withEntity(ReactionEntity(id: "5")),
      
      ImageViewDisplayable(image: UIImage(named: "tickBadge"))
        .withEntity(ReactionEntity(id: "6")),
    ]
  }()
  
  private lazy var itemBackground: PopupPickerDisplayable = {
    return SimpleViewDisplayable()
      .withBackgroundColor(.white)
      .withCornerStyle(.fixed(radius: 8))
      .withShadow(.defaultShadow)
  }()
}

struct ReactionEntity {
  let id: String
}
