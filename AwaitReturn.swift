import Foundation


/// Returns a value from an asynchronous context into a concurrent one.
public func awaitReturn<V>(_ produceValue: @Sendable @escaping () async -> V) -> V {
    // Set up a reference to shared data.
    let container = AsyncContainer<V>()

    // Begin the asynchronous context.
    Task {
        // Produce the shared result.
        container.result = await produceValue()

        // Alert the concurrent context that it can continue.
        container.semaphore.signal()
    }

    // Wait (similar to "await") for the signal that our asynchronous work is done.
    container.semaphore.wait()

    // Finally return the produced value. At this point, due to the semaphore and order of operations, one can assume that it is non-nil.
    return container.result!
}


/// Data that is shared between contexts.
fileprivate final class AsyncContainer<V> {
    /// The shared semaphore. This allows "await"-like behavior within a concurrent context.
    let semaphore = DispatchSemaphore(value: 0)

    /// The result of the operation.
    var result: V?
}
