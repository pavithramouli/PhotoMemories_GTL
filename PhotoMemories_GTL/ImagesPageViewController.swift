//
//  ImagesPageViewController.swift
//  PhotoMemories_GTL
//
//  Created by - GTL - on 26/02/16.
//  Copyright © 2016 - GTL -. All rights reserved.
//

import UIKit

/*
This controller manages a simple UIPageViewController to hold the ten images used by the app.

Expected View : A collection of ten images. Added to the PageControl.
Expected Actions: Can zoom in and out of a single image. Can swipe across the ten images.

Future Plans:  Adding limits to zoom.
*/

// MARK:  ImagesPageViewController

class ImagesPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var imagesDataModel = ImagesDataModel.sharedDataModel;
    
    //This is the controller that manages what each page needs to load.
    var indexViewController:ImagesContentViewController!;
    var indexPhoto:Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self;
        self.delegate = self;
        indexViewController = self.pageContentAtIndex(indexPhoto);
        var allPagesControllersArray = [UIViewController]();
        allPagesControllersArray.append(indexViewController!);
        self.setViewControllers(allPagesControllersArray, direction: .Forward, animated: true, completion: nil);
        self.view.backgroundColor = UIColor.blackColor();
    }
    
// MARK: Custom Functions
    func setInitialPhotoIndex(index:Int){
        indexPhoto = index;
    }
    
    // more useful if different pages have to load different view controllers.
    func pageContentAtIndex(index:Int) -> ImagesContentViewController! {
        
        if(imagesDataModel.imagesFileNamesArray.count == 0 || (index >= imagesDataModel.imagesFileNamesArray.count)){
            return nil;
        }else{
            let contentViewController:ImagesContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImagesContentViewController") as! ImagesContentViewController;
            contentViewController.view.backgroundColor = UIColor.blackColor();
            contentViewController.imageCaption!.text = imagesDataModel.imagesCaptionsArray[index];
            contentViewController.imageViewPresented!.image = UIImage.init(named: imagesDataModel.imagesFileNamesArray[index] as String);
            contentViewController.pageIndex = index;
            return contentViewController;
        }
    }
    
// MARK:  PageViewController Delegates    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0;
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return imagesDataModel.imagesFileNamesArray.count;
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! ImagesContentViewController).pageIndex;
        
        if(index == NSNotFound){
            return nil;
        }
        
        
        if((index+1) == imagesDataModel.imagesCaptionsArray.count){
            return nil;
        }else{
            return self.pageContentAtIndex(index+1);
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let index = (viewController as! ImagesContentViewController).pageIndex;
        if(index == 0){
            return nil;
        }
        return self.pageContentAtIndex(index-1);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
