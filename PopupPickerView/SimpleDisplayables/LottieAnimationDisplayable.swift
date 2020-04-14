//
//  LottieAnimationDisplayable.swift
//  PopupPickerView
//
//  Created by Bach Le on 4/13/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

import Foundation
import UIKit
import Lottie

public class LottieAnimationDisplayable: UIView, PopupPickerItemDisplayable {
  private let lottieJsonName: String
  private lazy var animationView: AnimationView = .init(name: lottieJsonName)
  
  public init(lottieJsonName: String) {
    self.lottieJsonName = lottieJsonName
    super.init(frame: .zero)
  }
  public override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    if superview != nil {
      setupAnimView()
      setupAnim()
    }
  }
  
  private func setupAnimView() {
    self.addSubview(animationView)
  }
  
  private func setupAnim() {
    animationView.loopMode = .loop
    animationView.backgroundBehavior = .pauseAndRestore
    animationView.play()
  }
  
  public required init?(coder: NSCoder) {
    fatalError()
  }
  
  public func layout(in rect: CGRect) {
    layoutView(self, in: rect)
    animationView.frame = self.bounds
  }
}
