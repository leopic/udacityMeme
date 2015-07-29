//
//  MemeDetailViewController.swift
//  MemeApp
//
//  Created by Leo Picado on 7/28/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import UIKit

class MemeDetailViewController:UIViewController {

    @IBOutlet var memedImage:UIImageView!
    var meme:Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memedImage.image = meme.memedImage
        self.navigationItem.title = meme.textTop
        self.navigationController?.navigationBar.backgroundColor = .whiteColor()
        self.navigationController?.navigationBar.tintColor = .redColor()
    }
    
    @IBAction func tapOnShareBtn(sender:AnyObject) {
        let activityVC = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        presentViewController(activityVC, animated: true, completion: nil)
    }

}
