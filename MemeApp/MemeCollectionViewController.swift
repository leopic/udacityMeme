//
//  MemeCollectionViewController.swift
//  MemeApp
//
//  Created by Leo Picado on 7/26/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    var memes:[Meme]!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        let img = UIImage(named: "test")!
        var testMeme = Meme(textTop: "arriba", textBottom: "abajo", image: img, memedImage: img)
        memes.append(testMeme)
        memes.append(testMeme)
        memes.append(testMeme)
        memes.append(testMeme)
        memes.append(testMeme)
        memes.append(testMeme)
        memes.append(testMeme)
        memes.append(testMeme)
        memes.append(testMeme)
        memes.append(testMeme)
        memes.append(testMeme)
        
        collectionView?.contentInset = UIEdgeInsetsMake(61.0, 0.0, 35.0, 0.0)
        self.collectionView?.reloadData()
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        cell.backgroundColor = UIColor.lightTextColor()
        cell.imageView.image = meme.memedImage
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if toInterfaceOrientation == .LandscapeLeft || toInterfaceOrientation == .LandscapeRight {
            collectionView?.contentInset = UIEdgeInsetsMake(27.0, 0.0, 35.0, 0.0)
        } else {
            collectionView?.contentInset = UIEdgeInsetsMake(61.0, 0.0, 35.0, 0.0)
        }
    }
}
