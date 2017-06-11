
import Cocoa

@available(OSX 10.12.2, *)
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var touchBarWindow: TouchBarWindowController!
  
    @IBOutlet weak var menu: NSMenu!
    
    
    var statusItem: NSStatusItem?
    
    let keyCode : UInt16 = 1 // S-Key
    let keyMask = NSEventModifierFlags(rawValue: 786721) // Control-Key + Alt-Key
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Make a status bar that has variable length (as opposed to being a standard square size)
        // -1 to indicate "variable length"
        self.statusItem = NSStatusBar.system().statusItem(withLength: 1)
        
        // Set the text that appears in the menu bar
        self.statusItem!.title = "🎶"
        self.statusItem?.image?.size = NSSize(width: 20, height: 18)
        self.statusItem?.length = 70
        // image should be set as tempate so that it changes when the user sets the menu bar to a dark theme
        self.statusItem?.image?.isTemplate = true
        
        
        
        // Set the menu that should appear when the item is clicked
        self.statusItem!.menu = self.menu
        
        // Set if the item should change color when clicked
        self.statusItem!.highlightMode = true
        
        
        // Set global keyboard shortcut
        let opts = NSDictionary(object: kCFBooleanTrue, forKey: kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString) as CFDictionary
        guard AXIsProcessTrustedWithOptions(opts) == true else { return }
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown, handler: self.handler)
        
        // Initialise WindowController
        let storyboard = NSStoryboard(name: "Main",bundle: nil)
        touchBarWindow = storyboard.instantiateController(withIdentifier: "TouchBar") as! TouchBarWindowController
    }
    
    func handler(event: NSEvent!) {
        if event.modifierFlags == self.keyMask{
            if event.keyCode == self.keyCode{
                if(touchBarWindow.window!.isVisible)
                {
                    touchBarWindow.close()
                    print("Closed Window")
                }
                else
                {
                    touchBarWindow.showWindow(self)
                    NSApplication.shared().activate(ignoringOtherApps: true)
                    print("Opened Window")
                }
            }
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    @IBAction func quit(_ sender: AnyObject) {
        NSApplication.shared().terminate(nil)
    }
    
    
}
