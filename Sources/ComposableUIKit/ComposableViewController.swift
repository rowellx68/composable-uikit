//
//  Created by Rowell Heria on 27/10/2022.
//

import Combine
import ComposableArchitecture
import UIKit

open class ComposableViewController<Feature: Reducer>: UIViewController where Feature.State: Equatable {
  open var store: StoreOf<Feature>
  open var viewStore: ViewStoreOf<Feature>
  open var cancellables: Set<AnyCancellable> = []

  public init(store: StoreOf<Feature>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  public required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

public extension ComposableViewController {
  func wrapInNavigationController() -> UINavigationController {
    .init(rootViewController: self)
  }

  func barButtonItem(systemItem: UIBarButtonItem.SystemItem, action: Feature.Action, menu: UIMenu? = nil) -> UIBarButtonItem {
    UIBarButtonItem(
      systemItem: systemItem,
      primaryAction: self.action(for: action),
      menu: menu
    )
  }

  func barButtonItem(image: UIImage?, action: Feature.Action, menu: UIMenu? = nil) -> UIBarButtonItem {
    UIBarButtonItem(
      image: image,
      primaryAction: self.action(for: action),
      menu: menu
    )
  }

  func barButtonItem(title: String, action: Feature.Action, menu: UIMenu? = nil) -> UIBarButtonItem {
    UIBarButtonItem(
      title: title,
      image: nil,
      primaryAction: self.action(for: action),
      menu: menu
    )
  }

  func barButtonItem(title: String, image: UIImage?, action: Feature.Action, menu: UIMenu? = nil) -> UIBarButtonItem {
    UIBarButtonItem(
      title: title,
      image: image,
      primaryAction: self.action(for: action),
      menu: menu
    )
  }

  func barButtonMenu(title: String, menu: UIMenu) -> UIBarButtonItem {
    UIBarButtonItem(title: title, menu: menu)
  }

  func barButtonMenu(image: UIImage?, children: [UIMenuElement]) -> UIBarButtonItem {
    UIBarButtonItem(image: image, menu: .init(children: children))
  }

  func action(for action: Feature.Action) -> UIAction {
    UIAction { [weak self] _ in
      self?.viewStore.send(action)
    }
  }

  func action(for action: Feature.Action, title: String, image: UIImage?, attributes: UIMenuElement.Attributes = .init()) -> UIAction {
    UIAction(
      title: title,
      image: image,
      attributes: attributes
    ) { [weak self] _ in
      self?.viewStore.send(action)
    }
  }
}

public extension UINavigationController {
  func prefersLargeTitles(_ largeTitle: Bool = true) -> Self {
    navigationBar.prefersLargeTitles = largeTitle

    return self
  }
}
