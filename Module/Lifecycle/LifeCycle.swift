//
//  LifeCycle.swift
//  Wallpaper
//
//  Created by moyanxinxu on 2026/10/26.
//

struct Lifecycle<T> {
    var onMutate: (() -> Void)?
    var onSuccess: ((T) -> Void)?
    var onError: ((Error) -> Void)?
    var onSettled: (() -> Void)?

    func invoke(_ operation: () async throws -> T) async {
        defer { onSettled?() }
        onMutate?()

        do {
            let data = try await operation()
            onSuccess?(data)
        } catch {
            onError?(error)
        }
    }
}

extension Lifecycle where T == Void {
    func invoke(_ operation: () async throws -> Void) async {

        defer { onSettled?() }
        onMutate?()

        do {
            try await operation()
            onSuccess?(())
        } catch {
            onError?(error)
        }
    }
}
