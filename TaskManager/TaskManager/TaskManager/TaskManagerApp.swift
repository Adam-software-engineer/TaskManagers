// YourAppNameApp.swift

import SwiftUI

@main
struct YourAppNameApp: App {
    @StateObject private var viewModel = TaskManagerViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
