//
//  ViewController.swift
//  HttpLogPreview
//
//  Created by Cellphoness on 04/23/2021.
//  Copyright (c) 2021 Cellphoness. All rights reserved.
//

import UIKit
import HttpLogPreview

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        view.backgroundColor = .white

        HttpServerLogger.shared().startServer(8989)

        NotificationCenter.default.post(name: HttpLogDefine.Notification.httpLog, object: "post notification 12345")
        NotificationCenter.default.post(name: HttpLogDefine.Notification.httpLog, object: "post notification 67890")

        LogPreviewManager.loggerBrowserSingleLine("single 12345")

        LogPreviewManager.loggerBrowserMultibleLines("3 in line 1")
        LogPreviewManager.loggerBrowserMultibleLines("3 in line 2")
        LogPreviewManager.loggerBrowserMultibleLines("3 in line 3")

        LogPreviewManager.loggerBrowserMultibleLines("total 5 line 1", lines: 5)
        LogPreviewManager.loggerBrowserMultibleLines("total 5 line 2", lines: 5)
        LogPreviewManager.loggerBrowserMultibleLines("total 5 line 3", lines: 5)
        LogPreviewManager.loggerBrowserMultibleLines("total 5 line 4", lines: 5)
        LogPreviewManager.loggerBrowserMultibleLines("total 5 line 5", lines: 5)
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

