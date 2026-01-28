---
name: rxswift-uikit
description: Use when reviewing, debugging, or writing RxSwift code in UIKit projects, implementing ReactorKit patterns, diagnosing memory leaks or retain cycles in reactive code, fixing threading issues, or migrating callback-based code to RxSwift.
---

# RxSwift + UIKit Patterns

## Overview

Write safe, performant, and maintainable RxSwift code in UIKit applications. Core principles: memory safety through weak references, thread safety through scheduler management, and clean reactive chains.

## Red Flags - STOP and Fix

If you're thinking any of these, STOP:

| Thought | Reality |
|---------|---------|
| "DisposeBag handles it anyway" | DisposeBag can't dispose if VC is retained by closure. Retain cycle. |
| "It works on my machine" | Threading bugs are race conditions. Works 99% ≠ correct. |
| "I'll add [weak self] later" | You won't. Fix now or ship a memory leak. |
| "Manual testing showed no leaks" | Memory leaks accumulate silently. Use Instruments. |
| "Senior said skip observeOn" | Authority doesn't override thread safety. UIKit will crash. |
| "Nested subscribe is clearer" | It's tech debt. flatMap is the pattern. |
| "Just this once without throttle" | Double-tap bugs are user-facing. Never skip. |

**All of these mean: Fix before commit. No exceptions.**

## Iron Laws

### Memory Management - NEVER Violate

| Rule | Reason |
|------|--------|
| Always use `[weak self]` in closures | Prevents retain cycles |
| Never use `[unowned self]` | Crashes if deallocated |
| All subscriptions must be disposed | Prevents memory leaks |
| Guard self immediately after capture | Fail-fast for deallocated objects |

### Thread Safety - NEVER Violate

| Rule | Reason |
|------|--------|
| UI updates MUST be on main thread | UIKit is not thread-safe |
| Use `observeOn(MainScheduler.instance)` before UI | Ensures main thread |
| Network/heavy work on background | Prevents UI blocking |

## Core Patterns

### DisposeBag Management

**ViewController property:**
```swift
final class MyViewController: UIViewController {
    private let disposeBag = DisposeBag()

    func bind() {
        observable
            .subscribe(onNext: { [weak self] value in
                guard let self else { return }
                self.updateUI(value)
            })
            .disposed(by: disposeBag)
    }
}
```

**Reusable cell reset:**
```swift
final class MyCell: UITableViewCell {
    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
```

**Scoped disposal:**
```swift
private var requestDisposeBag = DisposeBag()

func startRequest() {
    requestDisposeBag = DisposeBag()  // Cancel previous
    networkCall
        .subscribe(...)
        .disposed(by: requestDisposeBag)
}
```

### Memory-Safe Closures

**Standard pattern:**
```swift
.subscribe(onNext: { [weak self] value in
    guard let self else { return }
    self.handleValue(value)
})
```

**Throwable pattern (for flatMap):**
```swift
.flatMap { [weak self] value -> Single<Result> in
    guard let self else { throw WeakSelfDeallocatedError() }
    return self.performOperation(value)
}
```

### Scheduler Management

| Scheduler | Use Case |
|-----------|----------|
| `MainScheduler.instance` | UI updates |
| `ConcurrentDispatchQueueScheduler(qos: .background)` | Network/IO |
| `SerialDispatchQueueScheduler` | Sequential processing |

**Network with UI update:**
```swift
networkService.fetchData()
    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    .observeOn(MainScheduler.instance)
    .subscribe(onNext: { [weak self] data in
        self?.updateUI(data)
    })
    .disposed(by: disposeBag)
```

### Concurrency Control

**Throttle - buttons (prevent rapid-fire):**
```swift
button.rx.tap
    .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
    .subscribe(onNext: { [weak self] in
        self?.performAction()
    })
    .disposed(by: disposeBag)
```

**Debounce - search input (wait for pause):**
```swift
searchField.rx.text
    .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
    .distinctUntilChanged()
    .subscribe(onNext: { [weak self] query in
        self?.search(query)
    })
    .disposed(by: disposeBag)
```

**FlatMapLatest - cancel previous, keep latest:**
```swift
searchQuery
    .flatMapLatest { [weak self] query -> Observable<[Result]> in
        guard let self else { return .empty() }
        return self.searchService.search(query)
    }
    .subscribe(...)
```

### Error Handling

**Catch and convert to state:**
```swift
networkCall
    .map { Result.success($0) }
    .catch { .just(Result.failure($0)) }
    .subscribe(onNext: { [weak self] result in
        self?.handleResult(result)
    })
```

**CatchAndReturn for recovery:**
```swift
networkCall
    .catchAndReturn(defaultValue)
    .subscribe(...)
```

**Retry with backoff:**
```swift
networkCall
    .retry(when: { errors in
        errors.enumerated().flatMap { attempt, error -> Observable<Int> in
            guard attempt < 3 else { return .error(error) }
            return Observable.timer(.seconds(Int(pow(2, Double(attempt)))),
                                    scheduler: MainScheduler.instance)
        }
    })
```

## ReactorKit Integration

### Reactor Structure

```swift
final class MyViewReactor: Reactor {
    enum Action {
        case viewDidLoad
        case didTapButton
        case didChangeText(String)
    }

    enum Mutation {
        case setLoading(Bool)
        case setData(MyData)
        case setError(Error?)
    }

    struct State {
        var isLoading: Bool = false
        var data: MyData?
        @Pulse var error: Error?        // One-shot event
        @Pulse var navigateTo: Route?   // One-shot event
    }

    let initialState = State()
}
```

### @Pulse for One-Shot Events

Use `@Pulse` for events that should fire once (alerts, navigation, errors):

```swift
// In State
@Pulse var showAlert: String?

// In ViewController
reactor.pulse(\.$showAlert)
    .compactMap { $0 }
    .observeOn(MainScheduler.instance)
    .subscribe(onNext: { [weak self] message in
        self?.showAlert(message)
    })
    .disposed(by: disposeBag)
```

### bind(reactor:) Pattern

```swift
func bind(reactor: MyViewReactor) {
    // MARK: - State Bindings
    reactor.state.map(\.isLoading)
        .distinctUntilChanged()
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] isLoading in
            guard let self else { return }
            self.loadingView.isHidden = !isLoading
        })
        .disposed(by: disposeBag)

    // MARK: - Pulse Bindings (one-shot)
    reactor.pulse(\.$error)
        .compactMap { $0 }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] error in
            self?.handleError(error)
        })
        .disposed(by: disposeBag)

    // MARK: - Action Bindings
    rx.viewDidLoad
        .map { Reactor.Action.viewDidLoad }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)

    button.rx.tap
        .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
        .map { Reactor.Action.didTapButton }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
}
```

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| `[unowned self]` | Crash if deallocated | `[weak self]` with guard |
| Missing `disposed(by:)` | Memory leak | Always dispose |
| Strong self in closure | Retain cycle | `[weak self]` capture |
| UI update on background | Crash/undefined | `observeOn(MainScheduler.instance)` |
| Nested subscribe | Subscription hell | Use `flatMap`/`flatMapLatest` |
| Missing `distinctUntilChanged` | Redundant updates | Add before UI binding |
| `flatMap` when need latest only | Stale results | Use `flatMapLatest` |
| No throttle on buttons | Double-tap issues | `throttle(.milliseconds(300))` |

**Nested subscribe (BAD):**
```swift
outer.subscribe(onNext: { value in
    inner.subscribe(onNext: { result in })  // BAD
})
```

**Flattened (GOOD):**
```swift
outer
    .flatMapLatest { value in inner }
    .subscribe(onNext: { result in })
```

## Code Review Workflow

**When reviewing RxSwift code, follow this exact order:**

### Step 1: Memory Safety (Critical - Review First)
- [ ] All closures use `[weak self]`
- [ ] No `[unowned self]` usage
- [ ] Guard self immediately after capture
- [ ] All subscriptions disposed via DisposeBag
- [ ] Reusable cells reset DisposeBag in prepareForReuse

**Stop here if any fail. Request changes immediately.**

### Step 2: Threading (Critical)
- [ ] UI updates use `observeOn(MainScheduler.instance)`
- [ ] Heavy work on background scheduler
- [ ] No main thread blocking

**Stop here if any fail. Request changes immediately.**

### Step 3: Concurrency Control (High)
- [ ] Button taps use `throttle()`
- [ ] Text input uses `debounce()` for search
- [ ] State bindings use `distinctUntilChanged()`
- [ ] Latest-only streams use `flatMapLatest`

### Step 4: ReactorKit (If applicable)
- [ ] One-shot events use `@Pulse`
- [ ] State: `reactor.state.map(\.property)`
- [ ] Pulse: `reactor.pulse(\.$property)`
- [ ] Actions throttled where appropriate

### Step 5: Error Handling
- [ ] Errors caught and converted to state
- [ ] No silent error swallowing
- [ ] Recovery paths for expected errors

### Step 6: Code Style
- [ ] No nested subscribes (use flatMap)
- [ ] Consistent MARK comments
- [ ] Proper access control (private where appropriate)

## Debugging Guide

### Memory Leak Diagnosis

**Symptoms:** ViewController not deallocating, memory grows, deinit never called

**Steps:**
1. Add `deinit { print("\(Self.self) deinit") }` to suspect classes
2. Use Xcode Memory Graph Debugger (Debug > Debug Memory Graph)
3. Check for strong self in closures
4. Look for missing `[weak self]`

**Common causes:**
- Strong self capture in subscribe closures
- Closure stored as property referencing self
- Timer/NotificationCenter not disposed

### Thread Violation Diagnosis

**Symptoms:** Purple runtime warning, inconsistent UI, crashes

**Steps:**
1. Enable Main Thread Checker (Edit Scheme > Diagnostics)
2. Add breakpoint on thread violation
3. Check call stack for non-main UI access

**Fix:** Add `observeOn(MainScheduler.instance)` before UI update

### Subscription Debugging

```swift
observable
    .debug("FeatureName", trimOutput: true)
    .subscribe(...)

// Or detailed
.do(onNext: { print("Next: \($0)") },
    onError: { print("Error: \($0)") },
    onSubscribe: { print("Subscribed") },
    onDispose: { print("Disposed") })
```

## Migration Tips

### Callback to RxSwift

```swift
// Before
func fetch(completion: @escaping (Result<Data, Error>) -> Void)

// After
func fetch() -> Single<Data> {
    Single.create { single in
        self.legacyFetch { result in
            switch result {
            case .success(let data): single(.success(data))
            case .failure(let error): single(.failure(error))
            }
        }
        return Disposables.create()
    }
}
```

### Delegate to RxSwift

```swift
extension Reactive where Base: MyClass {
    var didSomething: Observable<Void> {
        delegate.methodInvoked(#selector(MyDelegate.didSomething))
            .map { _ in }
    }
}
```

### KVO to RxSwift

```swift
object.rx.observe(String.self, "property")
    .subscribe(onNext: { value in })
    .disposed(by: disposeBag)
```

## Common Rationalizations Table

| Excuse | Why It's Wrong | What To Do |
|--------|----------------|------------|
| "The VC will deallocate soon anyway" | Closure holds VC → VC can't deallocate → Leak | Add `[weak self]` |
| "I tested manually, no crash" | Threading bugs are intermittent race conditions | Add `observeOn(MainScheduler.instance)` |
| "flatMap is overkill for simple case" | Nested subscribe creates disposal issues | Always flatten |
| "throttle slows down the UX" | 300ms is imperceptible, double-tap is noticeable | Always throttle buttons |
| "distinctUntilChanged is premature optimization" | Redundant UI updates waste CPU, cause flicker | Always use before UI binding |
| "error handling makes code verbose" | Silent failures are debugging nightmares | Always handle errors explicitly |
| "I'll refactor this next sprint" | Tech debt tickets never get done | Fix now |
