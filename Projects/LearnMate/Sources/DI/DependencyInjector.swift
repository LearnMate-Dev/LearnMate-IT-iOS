//
//  DependencyInjector.swift
//  LearnMate
//
//  Created by 박지윤 on 7/2/25.
//

import Swinject

/// DI 대상 등록
public protocol DependencyAssemblable {
    /// assemble: Swinject의 Assembly 목록을 받아서 컨테이너에 등록
    func assemble(_ assemblyList: [Assembly])
    /// register: 간단한 인스턴스를 직접 주입하고 싶을 때 사용
    func register<T>(_ serviceType: T.Type, _ object: T)
}

/// DI 등록한 서비스 사용
public protocol DependencyResolvable {
    func resolve<T>(_ serviceType: T.Type) -> T
}

/// DI 등록 + 사용 둘 다 가능
public typealias Injector = DependencyAssemblable & DependencyResolvable

/// 의존성 주입을 담당하는 인젝터
public final class DependencyInjector: Injector {
    private let container: Container
    
    public init(container: Container) {
        self.container = container
    }

    /// assemble: 여러 DI 모듈을 묶어서 한꺼번에 등록 가능
    public func assemble(_ assemblyList: [Assembly]) {
        assemblyList.forEach {
            $0.assemble(container: container)
        }
    }

    /// register: 특정 인스턴스를 직접 등록할 때 사용 (예: Mock 객체 등록, 단일 인스턴스 등)
    public func register<T>(_ serviceType: T.Type, _ object: T) {
        container.register(serviceType) { _ in object }
    }

    /// resolve: 서비스 사용 시점에 등록된 객체 꺼내오기
    public func resolve<T>(_ serviceType: T.Type) -> T {
        container.resolve(serviceType)!
    }
}
