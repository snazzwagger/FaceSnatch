//
//  ViewController.swift
//  ProjectFaceSnatch
//
//  Created by John Stanford on 10/12/16.
//  Copyright © 2016 Khelion. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var pickedImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        let todoEndpoint: String = "http://jsonplaceholder.typicode.com/posts/1"
        guard let url = NSURL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(url: url as URL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) in
            guard error == nil
            else {
                print("error calling GET on /todos/1")
                print(error)
                return
            }
            
            guard let responseData = data
            else {
                print("Error: did not receive data")
                return
            }
            
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any]
                else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                print("The todo is: " + todo.description)
                
                guard let todoTitle = todo["title"] as? String
                else {
                    print("Could not get todo title from JSON")
                    return
                }
                self.jsonSuccess(mes: todoTitle)
            }
            catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        if (pickedImage.image == nil) {
            failNotice()
        }
        else{
            let imageData = UIImageJPEGRepresentation(pickedImage.image!, 0.6)
            let compressedJPEGImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil)
            saveNotice()
        }
    }

    @IBAction func cameraButtonAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func libraryButtonAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        pickedImage.image = image
        self.dismiss(animated: true, completion: nil);
    }
    
    func saveNotice() {
        let alertController = UIAlertController(title: "Imaged Saved", message: "Saved to Camera Roll!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func failNotice() {
        let alertController = UIAlertController(title: "Error", message: "You need to select an image!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func jsonSuccess(mes: String) {
        let alertController = UIAlertController(title: "Success!!", message: "You have succeeded!!" + mes, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }

}

