//
//  ScrollControl.swift
//  SaneScroll
//
//  Created by Erik Vinoya on 11/11/24.
//

import ApplicationServices

class ScrollControl
{
    static let shared = ScrollControl()
    
    let scrollEventCallback: CGEventTapCallBack = {(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon) in
        var isWheel: Bool = event.getIntegerValueField(.scrollWheelEventIsContinuous) == 0
        
        if isWheel {
            event.setIntegerValueField(.scrollWheelEventDeltaAxis1, value: -event.getIntegerValueField(.scrollWheelEventDeltaAxis1))
            event.setIntegerValueField(.scrollWheelEventDeltaAxis2, value: -event.getIntegerValueField(.scrollWheelEventDeltaAxis2))
        }
        
        return Unmanaged.passUnretained(event)
    }
    
    func interceptScrollEvents()
    {
        var eventTap: CFMachPort?
        var runLoopSource: CFRunLoopSource?
        
        eventTap = CGEvent.tapCreate(tap: .cghidEventTap, place: .tailAppendEventTap, options: .defaultTap, eventsOfInterest: CGEventMask(1 << CGEventType.scrollWheel.rawValue), callback: scrollEventCallback, userInfo: nil)
        
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource!, CFRunLoopMode.commonModes)
        CGEvent.tapEnable(tap: eventTap!, enable: true)
        CFRunLoopRun()
    }
}
