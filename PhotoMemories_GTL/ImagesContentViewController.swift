//
//  ImagesContentViewController.swift
//  PhotoMemories_GTL
//
//  Created by - GTL - on 26/02/16.
//  Copyright © 2016 - GTL -. All rights reserved.
//

import UIKit

/*
This controller manages a simple UIViewController to present a single image.

Expected View : A view containing a simple lable and the image.
Expected Actions: Can zoom in and out of the single image.

Future Plans:  Adding limits to zoom.
*/

// MARK:  ImagesContentViewController

class ImagesContentViewController: UIViewController {
    
    @IBOutlet weak var imageCaption: UILabel!
    @IBOutlet weak var imageViewPresented: UIImageView!
    var pageIndex:Int = 0;

    @IBAction func scaleImage(sender: UIPinchGestureRecognizer) {
        self.view.transform = CGAffineTransformScale(self.view.transform, sender.scale,sender.scale);
        sender.scale = 1;
        //this function needs a lot more work.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor.whiteColor();
    }
}
