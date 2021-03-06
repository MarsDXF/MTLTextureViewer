//
//  PreviewViewController.swift
//  QuickLookPreviewExtension
//
//  Created by Eugene Bokhan on 23.12.2019.
//  Copyright © 2019 Eugene Bokhan. All rights reserved.
//

import Cocoa
import Quartz
import Alloy
import MetalKit

class PreviewViewController: NSViewController, QLPreviewingController {

    override var nibName: NSNib.Name? {
        return NSNib.Name("PreviewViewController")
    }

    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let windowController = storyboard.instantiateController(withIdentifier: "TextureViewer") as? NSWindowController,
              let viewController = windowController.contentViewController as? ViewController
        else { return }

        addChild(viewController)
        self.view.addSubview(viewController.view)
        viewController.view.frame = .init(origin: .zero,
                                          size: self.view.bounds.size)

        do {
            try viewController.textureManager.read(from: url)
            try viewController.drawTexture()
        }
        catch { displayAlert(message: "File read failed, error: \(error)") }

        handler(nil)
    }
    
}
