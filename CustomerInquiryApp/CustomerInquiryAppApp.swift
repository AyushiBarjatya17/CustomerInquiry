//
//  CustomerInquiryAppApp.swift
//  CustomerInquiryApp
//
//  Created by Ayushi Barjatya on 02/09/25.
//

import SwiftUI

@main
struct CustomerInquiryAppApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var themeManager = ThemeManager.shared

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(themeManager)
        }
    }
}

struct AppRootView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ContentView()
            .environment(\.theme, themeManager.currentTheme)
    }
}
