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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        // Test
        let img = UIImage(named: "test")!
        var testMeme = Meme(textTop: "arriba", textBottom: "abajo", image: img, memedImage: img)
        memes.append(testMeme)
        memes.append(testMeme)
        memes.append(testMeme)
        // Test
        
        tableView.contentInset = UIEdgeInsetsMake(66.0, 0.0, 0.0, 0.0)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
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
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if toInterfaceOrientation == UIInterfaceOrientation.LandscapeLeft || toInterfaceOrientation == UIInterfaceOrientation.LandscapeRight {
            tableView.contentInset = UIEdgeInsetsMake(32.0, 0.0, 0.0, 0.0)
        } else {
            tableView.contentInset = UIEdgeInsetsMake(66.0, 0.0, 0.0, 0.0)
        }
    }


}
