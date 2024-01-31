/// Returns a value from an asynchronous context into a concurrent one.
public func awaitReturn<V>(_ produceValue: @Sendable @escaping () async -> V) -> V {
    let container = AsyncContainer<V>()
    
    Task {
        container.result = await produceValue()
        container.semaphore.signal()
    }
    
    container.semaphore.wait()
    
    return container.result
}


fileprivate final class AsyncContainer<V> {
    let semaphore = DispatchSemaphore(value: 0)
    var result: V!
}
