//
//  BillViewController.swift
//  SmartScan
//
//  Created by Carin Gan on 4/21/18.
//  Copyright © 2018 Carin Gan. All rights reserved.
//

import UIKit
import TesseractOCR

class BillViewController: UIViewController, G8TesseractDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var photo: UIImageView?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let tesseract:G8Tesseract = G8Tesseract(language:"eng+ita")
        //tesseract.language = "eng+ita"
        tesseract.delegate = self
        tesseract.image = photo?.image
        tesseract.recognize()
        
        print(tesseract.recognizedText)
    }
    
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        print("Recognition progress \(tesseract.progress)%")
    }
    
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false // return true if you need to interrupt tesseract before it finishes
    }

    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)
        return cell
    }
    
    // MARK: - Navigation

}
