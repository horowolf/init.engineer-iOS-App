//
//  PublishTabController.swift
//  init.engineer-iOS-App
//
//  Created by horo on 6/6/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import UIKit

class PublishTabController: UIViewController {
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var articleImg: UIImageView!
    @IBOutlet weak var articleText: UITextView!
    @IBOutlet weak var themePicker: UIPickerView!
    @IBOutlet weak var fontPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func imageUploadBtn(_ sender: Any) {
    }
    
}
