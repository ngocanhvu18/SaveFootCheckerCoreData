//
//  ViewController.swift
//  SaveFootCheckerCoreData
//
//  Created by Ngọc Anh on 5/25/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate
{
    var entity : Entity?
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var ratingcontroller: RatingControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        nameTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    func configure(){
        if entity != nil {
            nameTextField.text = entity?.text
            ratingcontroller.rating = Int(entity?.ranting ?? 0)
            imageView.image = entity?.photo as? UIImage
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // chọn ảnh
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present( imagePickerController , animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let masterViewController = segue.destination as? MasterViewController {
            if masterViewController.tableView.indexPathForSelectedRow == nil {
                // NewValue
                entity = Entity(context: AppDelegate.context)
            }
            entity?.ranting = Int32(ratingcontroller.rating)
            entity?.text = nameTextField.text
            entity?.photo = imageView.image
            DataService.share.saveToCoreData()
        }
    }
}

