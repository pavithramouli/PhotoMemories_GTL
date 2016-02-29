//
//  ImagesDataModel.swift
//  PhotoMemories_GTL
//
//  Created by - GTL - on 26/02/16.
//  Copyright © 2016 - GTL -. All rights reserved.
//

import Foundation

/*
This data model contains basic defintion of the image data structure I wanted. Ample scope for improving when there are dynamic images to be used.

Used images found on different blogs, apparently based on the book https://www.goodreads.com/book/show/21535713-soppy
Hopefully, I haven't infringed any copyrights with these images. I don't mean to use this commercially!

Future Plans:  Adding functions and manager actions to have dynamic loading of images.
*/

// MARK:  ImagesDataModel
class ImagesDataModel
{
    
    var imagesCaptionsArray:[String] = ["On that windy day ..","Figuring out Ikea instructions","Fun in the kitchen","Exploring anything and everything","Being near all the time","All those numerous apologies","All the outings","From Black hole to Matrix","As long as we are headed the same way","We'll be fine"];
    var imagesFileNamesArray:[String] = ["WindyCity","FiguringOutIkea","BiggestFun","ExploringNewThings","Sleeping","Sorry","AllTheOutings","EvenWhenTired","AsLongAsWeAreHeadedTheSameWay","EverythingWillJustBeFine"];

    static let sharedDataModel = ImagesDataModel();
    
}