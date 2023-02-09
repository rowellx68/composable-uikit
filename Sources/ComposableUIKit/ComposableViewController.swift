//
//  Created by Rowell Heria on 27/10/2022.
//

import Combine
import ComposableArchitecture
import UIKit

open class ComposableViewController<Feature: ReducerProtocol>: UIViewController where Feature.State: Equatable {
  open var store: StoreOf<Feature>
  open var viewStore: ViewStoreOf<Feature>
  open var cancellables: Set<AnyCancellable> = []

  public init(store: StoreOf<Feature>) {
    self.store = store
    viewStore = ViewStore(store)
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
}

public extension UINavigationController {
  func prefersLargeTitles(_ largeTitle: Bool = true) -> Self {
    navigationBar.prefersLargeTitles = largeTitle

    return self
  }
}

public extension ViewStore {
  func barButtonItem(image: UIImage?, action: ViewAction, menu: UIMenu? = nil) -> UIBarButtonItem {
    .init(image: image, primaryAction: .init(handler: { [weak self] _ in
      self?.send(action)
    }), menu: menu)
  }

  func barButtonItem(title: String, action: ViewAction, menu: UIMenu? = nil) -> UIBarButtonItem {
    .init(title: title, image: nil, primaryAction: .init(handler: { [weak self] _ in
      self?.send(action)
    }), menu: menu)
  }

  func barButtonItem(title: String, image: UIImage?, action: ViewAction, menu: UIMenu? = nil) -> UIBarButtonItem {
    .init(title: title, image: image, primaryAction: .init(handler: { [weak self] _ in
      self?.send(action)
    }), menu: menu)
  }

  func barButtonMenu(title: String, menu: UIMenu) -> UIBarButtonItem {
    .init(title: title, menu: menu)
  }

  func barButtonMenu(image: UIImage?, children: [UIMenuElement]) -> UIBarButtonItem {
    .init(image: image, menu: .init(children: children))
  }

  func action(for action: ViewAction) -> UIAction {
    .init { [weak self] _ in
      self?.send(action)
    }
  }

  func action(
    for action: ViewAction,
    title: String,
    image: UIImage?,
    attributes: UIMenuElement.Attributes = .init()
  ) -> UIAction {
    .init(title: title, image: image, attributes: attributes) { [weak self] _ in
      self?.send(action)
    }
  }

  func alertAction(for action: ViewAction, title: String, style: UIAlertAction.Style) -> UIAlertAction {
    .init(title: title, style: style) { [weak self] _ in
      self?.send(action)
    }
  }
}
