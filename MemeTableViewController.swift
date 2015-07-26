//
//  MemeTableViewController.swift
//  MemeApp
//
//  Created by Leo Picado on 7/26/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    var memes:[Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell", forIndexPath: indexPath) as! UITableViewCell

        let meme = memes[indexPath.row]
        cell.textLabel?.text = meme.textTop
        cell.detailTextLabel?.text = meme.textBottom
        cell.imageView?.image = meme.memedImage

        return cell
    }


}
