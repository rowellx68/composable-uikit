//
//  Store+Extensions.swift
//
//
//  Created by Rowell Heria on 09/03/2023.
//

import Combine
import ComposableArchitecture
import UIKit

public extension Store {
  /// Present a `UIViewController` as a sheet
  ///
  /// ```swift
  /// store.scope(
  ///   state: \.optionsState,
  ///   action: { .optionsAction(.presented($0)) }
  /// )
  /// .sheet(for: self) { store in
  ///   OptionsViewController(store: store)
  /// }
  /// .store(in: &cancellables)
  /// ```
  ///
  /// - Parameters:
  ///  - for: The UIViewController that will be presenting the sheet
  ///  - sheet: A closure that returns the `UIViewController` to present as a sheet
  ///  - animated: Animate on present
  ///  - animatedOnDismiss: Animate on dismiss
  func sheet<Wrapped>(
    for presenter: UIViewController,
    _ sheet: @escaping (Store<Wrapped, Action>) -> UIViewController,
    animated: Bool = true,
    animatedOnDismiss: Bool = true
  ) -> Cancellable where State == Wrapped? {
    ifLet { [weak presenter] store in
      guard let presenter else { return }
      presenter.present(sheet(store), animated: animated)
    } else: { [weak presenter] in
      guard let presenter else { return }
      presenter.presentedViewController?.dismiss(animated: animatedOnDismiss)
    }
  }
  
  /// Navigate to a `ComposableViewController<Feature>`.
  ///
  /// ```swift
  /// store.scope(
  ///   state: \.optionsState,
  ///   action: { .optionsAction(.presented($0)) }
  /// )
  /// .navigationDestination(from: self) { store in
  ///   OptionsViewController(store: store)
  /// }
  /// .store(in: &cancellables)
  /// ```
  ///
  /// - Parameters:
  ///  - for: The UIViewController that has the `navigationViewController` to which the destination will be pushed to.
  ///  - destination: A function that returns the destination `ComposableViewController<Feature>`
  ///  - animated: Animation on push
  ///  - animatedOnPop: Animate on pop
  func navigationDestination<Wrapped, Feature>(
    from presenter: UIViewController,
    _ destination: @escaping (Store<Wrapped, Action>) -> ComposableViewController<Feature>,
    animated: Bool = true,
    animatedOnPop: Bool = true
  ) -> Cancellable where State == Wrapped? {
    ifLet { [weak presenter] store in
      guard let presenter else { return }
      presenter.navigationController?.pushViewController(
        destination(store),
        animated: animated
      )
    } else: { [weak presenter] in
      guard let presenter else { return }
      presenter.navigationController?.popToViewController(
        presenter,
        animated: animatedOnPop
      )
    }
  }
}
