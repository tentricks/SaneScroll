//
//  main.swift
//  SaneScroll
//
//  Created by Erik Vinoya on 11/11/24.
//

import AppKit

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
