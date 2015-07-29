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
    
    let textTop = "TOP"
    let textBottom = "BOTTOM"
    
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
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        btnPickCamera.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        subscribeToKeyboardNotifications()
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage  {
            imgView.image = selectedImage
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        updateUI()
    }
    
    // MARK: Keyboard sliding
    /**
    The height of the keyboard can come from multiple places, ie: bluetooth
    keyboards, custom keyboards, so it's best to calculate it.
    
    :param: notification fired from `UIKeyboardWillShowNotification`
    
    :returns: height of the current keyboard on screen
    */
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        if let userInfo = notification.userInfo,
            keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                if txtBottom.isFirstResponder() {
                    return keyboardSize.CGRectValue().height
                }
        }
        
        return 0
    }
    
    /**
    Slide the frame down.
    */
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += getKeyboardHeight(notification)
        updateUI()
    }
    
    /**
    Slide the frame up.
    */
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
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
        // Udacity reviewer: I couldn't get this frame to be JUST the image
        // without the toolbars, so I have a large whitespace at the top of all
        // the images.
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Bring back toolbars after image was saved
        tbTop.hidden = false
        tbBottom.hidden = false
        return memedImage
    }
    
    /**
    Checks if all necessary fields for a Meme are complete
    
    :returns: result of evaluation
    */
    func validateMeme() -> Bool {
        if let top = txtTop.text, bottom = txtBottom.text, image = imgView.image {
            return !top.isEmpty && !bottom.isEmpty && top != textTop && bottom != textBottom
        } else {
            return false
        }
    }
    
    // MARK: User interactions
    @IBAction func tapOnPickCameraBtn() {
        pickAnImageUsing(.Camera)
    }
    
    @IBAction func tapOnPickAlbumBtn() {
        pickAnImageUsing(.PhotoLibrary)
    }
    
    /**
    Displays a `UIImagePickerController`.
    
    :param: sourceType:UIImagePickerControllerSourceType to use.
    */
    func pickAnImageUsing(sourceType:UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func tapOnCancelBtn() {
        resetUI()
    }
    
    @IBAction func tapOnShareBtn() {
        if let meme = saveMeme() {
            let activityVC = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
            
            activityVC.completionWithItemsHandler = {(activityType, completed, sender, error) in
                if var appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate where completed {
                    appDelegate.memes.append(meme)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    self.resetUI()
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
    Reset the UI to it's initial state.
    */
    func resetUI() {
        imgView.image = nil
        txtTop.text = textTop
        txtBottom.text = textBottom
        btnCancel.enabled = false
        btnShare.enabled = false
    }
    
    /**
    Updates the state of the share and cancel buttons.
    */
    func updateUI() {
        btnShare.enabled = validateMeme()
        btnCancel.enabled = userHasInteracted()
    }
    
    /**
    Checks if the user has interacted with any of the controls on the view.
    
    :returns: result of evaluation
    */
    func userHasInteracted() -> Bool {
        if let top = txtTop.text, bottom = txtBottom.text {
            return top.isEmpty || bottom.isEmpty || imgView.image != nil
        } else {
            return false
        }
    }
}
