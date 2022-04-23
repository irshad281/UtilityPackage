import Combine

public struct UtilityPackage {
    static var enableLog: Bool = true
    public init() { }
    
    public static func enableNetworkLog(_ value: Bool) {
        UtilityPackage.enableLog = value
    }
}

public var disposable = Set<AnyCancellable>()
