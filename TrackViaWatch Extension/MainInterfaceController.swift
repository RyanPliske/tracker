//
//  MainInterfaceController.swift
//  TrackViaWatch Extension
//
//  Created by Ryan Pliske on 6/11/15.
//  Copyright © 2015 Tracker. All rights reserved.
//

import WatchKit
import Foundation

@available(iOS 8.2, *)
class MainInterfaceController: WKInterfaceController {

    @IBOutlet var trackButton: WKInterfaceButton!
    var testInt = 0
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func trackButtonWasPressed() {
        print("Pressed")
        testInt = 2
    }
    

}
