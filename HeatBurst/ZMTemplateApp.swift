
import SwiftUI

@main
struct HeatBurstApp: App {
    @UIApplicationDelegateAdaptor(HeatBurstAppDelegate.self) private var appDelegate
    private let dependencies = HeatBurstAppDependencies()
    
    var body: some Scene {
        WindowGroup {
            HeatBurstRootView(viewModel: HeatBurstRootViewModel(launchService: dependencies.launchService))
                .environmentObject(dependencies.webViewCoordinator)
        }
    }
}
