//
//  SaneScrollApp.swift
//  SaneScroll
//
//  Created by Erik Vinoya on 11/11/24.
//

import SwiftUI
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popOver = NSPopover()
    private var window: NSWindow!

    func applicationWillFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if AXIsProcessTrusted() == false {
            let alert = NSAlert()
            alert.messageText = "SaneScroll requires Accessibility. Please enable Accessibility in System Preferences."
            alert.informativeText = "SaneScroll will not work without Accessibility enabled."
            alert.addButton(withTitle: "Open System Preferences")
            alert.addButton(withTitle: "Quit")
            
            if alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn{
                let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
                AXIsProcessTrustedWithOptions(options)
            }
            else {
                NSApp.terminate(self)
            }
        }
        
        pollAccessibility()
    }
    
    func pollAccessibility() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if AXIsProcessTrusted() == false {
                self.pollAccessibility()
            }
            else {
                ScrollControl.shared.interceptScrollEvents()
            }
        }
    }
}
