//
//  EntityDecorator.swift
//  PopupPickerView
//
//  Created by Bach Le on 4/14/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

import Foundation

// TODO: Do we need generic here? Maybe use Any? instead of <Entity>
class EntityDecorator: BaseDisplayableDecorator {
  let entity: Any
  
  init(entity: Any, decoratedItem: PopupPickerItemDisplayable) {
    self.entity = entity
    super.init(decoratedItem: decoratedItem)
  }
}

public extension PopupPickerItemDisplayable {
  func withEntity(_ entity: Any) -> PopupPickerItemDisplayable {
    return EntityDecorator(entity: entity, decoratedItem: self)
  }

  func extractEntity() -> Any? {
    var decorator: PopupPickerDisplayable = self
    while let baseDecorator = decorator as? BaseDisplayableDecorator {
      if let entityDecorator = decorator as? EntityDecorator {
        return entityDecorator.entity
      } else {
        decorator = baseDecorator.decoratedItem
      }
    }
    return nil
  }
}
