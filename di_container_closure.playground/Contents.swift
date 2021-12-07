import UIKit

/// Tutorial Link:
/// https://levelup.gitconnected.com/dependency-injection-container-in-swift-b4d7e139338c

// MARK: - DI Container

typealias FactoryClosure = (DICProtocol) -> AnyObject

protocol DICProtocol {
    func register<Service>(type: Service.Type, factoryClosure: @escaping FactoryClosure)
    func resolve<Service>(type: Service.Type) -> Service?
}

final class DIC: DICProtocol {
    static let shared = DIC()
    
    private init() {}
    
    var services = Dictionary<String, FactoryClosure>()
    
    func register<Service>(type: Service.Type, factoryClosure: @escaping FactoryClosure) {
        services["\(type)"] = factoryClosure
    }
    
    func resolve<Service>(type: Service.Type) -> Service? {
        return services["\(type)"]?(self) as? Service
    }
}

// MARK: - Services

class AppleService {
    func takeCare() {
        print("Taking care customer's macbook")
    }
}

class GoogleService {
    func performSearch(_ keyword: String) {
        print("Perform search with keyword: \(keyword)")
    }
}

class PixelPhone {
    let service: GoogleService
    
    init(service: GoogleService) {
        self.service = service
    }
    
    convenience init(container: DICProtocol) {
        self.init(service: container.resolve(type: GoogleService.self)!)
    }
    
    func showMainMenuDrawer() {
        print("Showing main menu Drawer!!!")
    }
}

class IBox {
    let service: AppleService
    
    init(service: AppleService) {
        self.service = service
    }
    
    convenience init(container: DICProtocol) {
        self.init(service: container.resolve(type: AppleService.self)!)
    }
    
    func buyMac() {
        print("Buy new mac!!!")
    }
}

// MARK: - X-ample

let appleService = AppleService()
let googleService = GoogleService()

let dic = DIC.shared
dic.register(type: AppleService.self) { _ in
    return appleService
}
dic.register(type: GoogleService.self) { _ in
    return googleService
}
dic.register(type: IBox.self) { container in
    return IBox(container: container)
}
dic.register(type: PixelPhone.self) { container in
    return PixelPhone(container: container)
}

let ibox = dic.resolve(type: IBox.self)
ibox?.buyMac()

let pixelPhone = dic.resolve(type: PixelPhone.self)
pixelPhone?.showMainMenuDrawer()

