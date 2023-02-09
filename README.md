# ComposableUIKit

ComposableUIKit is a package that simplifies the creation of `UIViewController` using [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) by [PointFree Co](https://www.pointfree.co).

## Example Usage

```swift
// MARK: Feature
struct RootFeature: ReducerProtocol {
  struct State: Equatable {}

  enum Action: Equatable {}

  var body: some ReducerProtocol<State, Action> {
  Reduce { state, action in
    //
  }
}

// MARK: ViewController
class RootViewController: ComposableViewController<RootFeature> {
}
```
