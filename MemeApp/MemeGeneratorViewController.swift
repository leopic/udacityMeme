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

    func resetUI() {
        txtTop.text = "TOP"
        txtBottom.text = "BOTTOM"
        imgView.image = nil
    }

    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {

            if let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage  {
                imgView.image = selectedImage
            }

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
        if let top = txtTop.text, bottom = txtBottom.text, image = imgView.image, memedImage = generateMemedImage() {
            return Meme(textTop: top, textBottom: bottom, image: image, memedImage: memedImage)
        } else {
            return nil
        }
    }

    // Render view to an image
    func generateMemedImage() -> UIImage? {
        tbTop.hidden = true
        tbBottom.hidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
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

    /**
    Restore UI to initial state
    */
    @IBAction func tapOnCancelBtn() {
        resetUI()
    }

    @IBAction func tapOnShareBtn() {
        if let meme = saveMeme() {
            println(meme.textTop)
        } else {
            let alert = UIAlertView()
            alert.delegate = self
            alert.title = "Error sharing your Meme"
            alert.message = "Please make sure to set both text fields and pick an image"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }

}
