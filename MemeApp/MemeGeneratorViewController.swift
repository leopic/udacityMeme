//
//  ViewController.swift
//  MemeApp
//
//  Created by Leo Picado on 6/27/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import UIKit

class MemeGeneratorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var btnPickCamera:UIBarButtonItem!
    @IBOutlet var btnPickAlbum:UIBarButtonItem!
    @IBOutlet var btnShare:UIBarButtonItem!
    @IBOutlet var btnCancel:UIBarButtonItem!
    @IBOutlet var txtTop:UITextField!
    @IBOutlet var txtBottom:UITextField!
    @IBOutlet var imgView:UIImageView!
    @IBOutlet var tbTop:UIToolbar!
    @IBOutlet var tbBottom:UIToolbar!
    
    var memeAppTextFieldDelegate = MemeAppTextFieldDelegate()
    
    // MARK: View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtTop.delegate = memeAppTextFieldDelegate
        txtTop.defaultTextAttributes = memeAppTextFieldDelegate.textAttributes
        txtTop.textAlignment = memeAppTextFieldDelegate.textAlignment
        
        txtBottom.delegate = memeAppTextFieldDelegate
        txtBottom.defaultTextAttributes = memeAppTextFieldDelegate.textAttributes
        txtBottom.textAlignment = memeAppTextFieldDelegate.textAlignment
        
        resetUI()
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        btnPickCamera.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage  {
            imgView.image = selectedImage
        }
        
        handleShareBtnVisibility()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Keyboard sliding
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:",
            name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:",
            name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    /**
    Slide the frame down.
    */
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += getKeyboardHeight(notification)
        handleShareBtnVisibility()
    }
    
    /**
    Slide the frame up.
    */
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // MARK: Meme specific functionality
    func saveMeme() -> Meme? {
        if validateMeme() {
            return Meme(textTop: txtTop.text, textBottom: txtBottom.text, image: imgView.image!, memedImage: generateMemedImage()!)
        } else {
            return nil
        }
    }
    
    /**
    Vodoo that handles merging what is currently on the screen and persist it
    into an UIImage.
    
    :returns: what was on the screen at the moment, sans toolbars.
    */
    func generateMemedImage() -> UIImage? {
        // Hide toolbars to avoid saving them as part of the image
        tbTop.hidden = true
        tbBottom.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Bring back toolbars after image was saved
        tbTop.hidden = false
        tbBottom.hidden = false
        return memedImage
    }
    
    // MARK: User interactions
    @IBAction func tapOnPickCameraBtn() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func tapOnPickAlbumBtn() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func tapOnCancelBtn() {
        resetUI()
    }
    
    @IBAction func tapOnShareBtn() {
        if let meme = saveMeme() {
            let activityVC = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
            
            activityVC.completionWithItemsHandler = {(activityType, completed, sender, error) in
                if completed {
                    if var appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                        appDelegate.memes.append(meme)
                        self.navigationController?.popToRootViewControllerAnimated(true)
                        self.resetUI()
                    }
                }
            }
            
            presentViewController(activityVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertView()
            alert.delegate = self
            alert.title = "We can't share your Meme just yet"
            alert.message = "Please make sure to add text to both fields and pick an image mmmkay?."
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    // MARK: Utils
    
    /**
    Reset UI to it's initial state.
    */
    func resetUI() {
        btnShare.enabled = false
        imgView.image = nil
        txtTop.text = "TOP"
        txtBottom.text = "BOTTOM"
    }
    
    /**
    Checks if all necessary fields for a Meme are complete
    
    :returns: result of evaluation
    */
    func validateMeme() -> Bool {
        if let top = txtTop.text, bottom = txtBottom.text, image = imgView.image, memedImage = generateMemedImage() {
            return !top.isEmpty && !bottom.isEmpty
        } else {
            return false
        }
    }
    
    /**
    Enable share button if all fields are complete
    */
    func handleShareBtnVisibility() {
        if validateMeme() {
            btnShare.enabled = true
        }
    }
}
