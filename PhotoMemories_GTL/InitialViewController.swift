//
//  ViewController.swift
//  PhotoMemories_GTL
//
//  Created by - GTL - on 26/02/16.
//  Copyright © 2016 - GTL -. All rights reserved.
//

import UIKit

/*
    This controller and the base view manage a simple UICollectionView to hold the ten images used by the app.
    
    Expected View : A collection of ten images. 
    Expected Actions: A tap or a pinch/zoom on any image presents that image in a new screen with other images just a swipe away.
    
    Implemented Animations: Have tried to show a smooth transition effect from the image to it's enlarged version. Haven't smoothened out the transition, but the basic elements of what I wanted to achieve are here. 

    Future Plans: 1) Smoothening the animation
                  2) Adding limits to zoom. 
                  3) Animating the image growing in size when zoom changes.
*/

// MARK:  InitialViewController
class InitialViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    
    //The UICollectionView that holds the ten images
    @IBOutlet weak var collectionView: UICollectionView!
    
    //The UIPageViewController that holds the enlarged images
    var imagesPageViewController: ImagesPageViewController!;
    
    //The Data model that holds details about the images
    var imagesDataModel = ImagesDataModel.sharedDataModel;
       
    override func viewDidLoad() {
        super.viewDidLoad();
        self.collectionView.scrollEnabled = true;
    }
    
// MARK: UIPinchGestureRecognizer Action
    //UIPinchGestureRecognizer added in the Storyboard on the UICollectionViewCell
    @IBAction func pinchIntoPhotos(sender: AnyObject) {
        self.performSegueWithIdentifier("PhotosFullScreenSegue", sender:self);
    }
   
// MARK:  CollectionView Delegates
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCollectionViewCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = UIImage.init(named: imagesDataModel.imagesFileNamesArray[indexPath.row]);
        cell.backgroundColor = UIColor.whiteColor();
        // a little play with the image.
        cell.imageView.layer.cornerRadius = 8
        cell.imageView.layer.shadowColor = UIColor.blackColor().CGColor
        cell.imageView.layer.shadowOffset = CGSize(width: 10 , height: 5)
        cell.imageView.layer.shadowOpacity = 0.5
        cell.imageView.layer.shadowRadius = 2.0
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("PhotosFullScreenSegue", sender:self);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController:ImagesPageViewController = segue.destinationViewController as! ImagesPageViewController
        let indexPath:NSIndexPath;
        //The zoom or tap can affect multiple images, ideally need to locate the centre point, this is just a quick way
        if(self.collectionView.indexPathsForSelectedItems()?.count > 0){
            indexPath = self.collectionView.indexPathsForSelectedItems()![0];
        }
        else{
            indexPath = NSIndexPath.init(forRow: 0, inSection: 0);
        }
        self.collectionView.scrollEnabled = false;
        viewController.setInitialPhotoIndex(indexPath.row); // so that the PageViewController knows which one to load now.
    }

// MARK:  Other View Delegates
    override func viewDidAppear(animated: Bool) {
        self.collectionView.scrollEnabled = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


// MARK:  Custom CollectionViewCell
class ImageCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        imageView.frame = CGRect(x: frame.origin.x, y: frame.origin.y,width: frame.size.width - 20 , height: frame.size.height-20);
        // subtracted 20 for showing that shadow effect inside the cell, outside the image.
       // imageView.frame = bounds
        addSubview(imageView)
    }
}

// MARK:  Custom Animation
class PhotosFullScreenAnimation : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(
        transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
            return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()
        
        let frmVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        if(frmVC!.isKindOfClass(InitialViewController)){
            
            
            /*
                The idea is to locate the image selected and add that imageview on to the Transition object with 
                an animation and then load the next view controller.
                
                Not very smooth.
            */
            
            let fromVC = frmVC as! InitialViewController;
            let indexPath:NSIndexPath;
            if(fromVC.collectionView.indexPathsForSelectedItems()?.count > 0){
               indexPath = fromVC.collectionView.indexPathsForSelectedItems()![0];
            }
            else{
                indexPath = NSIndexPath.init(forRow: 0, inSection: 0);
            }
            fromVC.collectionView.scrollEnabled = false;
            let cellAttributes = fromVC.collectionView.layoutAttributesForItemAtIndexPath(indexPath);
            let cellRect = cellAttributes?.frame;
            
            let imageAtIndex:UIImage = UIImage.init(named: fromVC.imagesDataModel.imagesFileNamesArray[indexPath.row])!;
            let imageViewSelected : UIImageView = UIImageView.init(frame: CGRect(x: cellRect!.origin.x + fromVC.collectionView.contentOffset.x, y: cellRect!.origin.y + fromVC.collectionView.contentOffset.y, width: cellRect!.size.width, height: cellRect!.size.height));
            imageViewSelected.image = imageAtIndex;
            imageViewSelected.contentMode = .ScaleAspectFit
            
            containerView!.addSubview(imageViewSelected)

            containerView!.addSubview(toVC!.view!)
            toVC!.view.frame = transitionContext.finalFrameForViewController(toVC!);
            toVC!.view.alpha = 0;

            
            let duration = transitionDuration(transitionContext)
            UIView.animateWithDuration(duration, animations: {
                
                imageViewSelected.frame = UIScreen.mainScreen().bounds;
                
                }, completion: { finished in
                    UIView.animateWithDuration(duration, animations: {
                        
                        toVC!.view.alpha = 1.0
                        
                        }, completion: { finished in
                            
                            imageViewSelected.removeFromSuperview();
                            transitionContext.completeTransition(true);
                    })
                })
        }
        else{
            transitionContext.completeTransition(!(transitionContext.transitionWasCancelled()));
        }
        
    }
    
}

// MARK:  Custom Navigation Delegate
class CustomNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController,animationControllerForOperation operation:UINavigationControllerOperation,fromViewController fromVC: UIViewController,toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // since this potentially rewires the default UINavigationControllerDelegate, I check and add custom transition only when needed
        if(toVC .isKindOfClass(ImagesPageViewController)){
            return PhotosFullScreenAnimation()
        }
        else{
            return nil;
        }
        
    }
    
}
