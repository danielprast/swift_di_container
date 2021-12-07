import UIKit

/// Tutorial Link:
/// https://www.raywenderlich.com/14223279-dependency-injection-tutorial-for-ios-getting-started

// MARK: - Dependency Injection Container

protocol DIContainerProtocol {
    func register<Service>(type: Service.Type, service: Any)
    func resolve<Service>(type: Service.Type) -> Service?
}

final class DIContainer: DIContainerProtocol {
    static let shared = DIContainer()
    
    private init() {}
    
    var services: [String:Any] = [:]
    
    func register<Service>(type: Service.Type, service: Any) {
        services["\(type)"] = service
    }
    
    func resolve<Service>(type: Service.Type) -> Service? {
        services["\(type)"] as? Service
    }
}

// MARK: Services

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
    
    convenience init(container: DIContainerProtocol) {
        self.init(service: container.resolve(type: GoogleService.self)!)
    }
    
    func showMainMenuDrawer() {
        print("Showing main menu Drawer!!!")
    }
}

// MARK: X-ample

let appleService = AppleService()
let googleService = GoogleService()

let diContainer = DIContainer.shared
diContainer.register(type: AppleService.self, service: appleService)
diContainer.register(type: GoogleService.self, service: googleService)

let pixelPhone = PixelPhone(container: diContainer)
diContainer.register(type: PixelPhone.self, service: pixelPhone)

let getAppleService = diContainer.resolve(type: AppleService.self)
getAppleService?.takeCare()

let getGoogleService = diContainer.resolve(type: GoogleService.self)
getGoogleService?.performSearch("Joss Gandoss")

let getPixelPhone = diContainer.resolve(type: PixelPhone.self)
getPixelPhone?.showMainMenuDrawer()
