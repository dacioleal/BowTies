//
//  ViewController.swift
//  Bow Ties
//
//  Created by Dacio Leal on 7/18/15.
//  Copyright (c) 2015 Dacio Leal. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timesWornLabel: UILabel!
    @IBOutlet weak var lastWornLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var managedContext : NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        insertSampleData()
        
        let request = NSFetchRequest(entityName: "Bowtie")
        let firstTitle = segmentedControl.titleForSegmentAtIndex(0)
        
        request.predicate = NSPredicate(format: "searchKey == %@", firstTitle!)
        
        var error : NSError? = nil
        var results = managedContext.executeFetchRequest(request, error: &error) as? [Bowtie]
        
        if let bowties = results {
            populate(bowties[0])
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
    }
    
    @IBAction func segmentedControl(control: UISegmentedControl) {
        
    }
    
    @IBAction func wear(sender: AnyObject) {
        
    }
    
    @IBAction func rate(sender: AnyObject) {
        
    }
    
    //Insert sample data
    func insertSampleData() {
        
        let fetchRequest = NSFetchRequest(entityName: "Bowtie")
        fetchRequest.predicate = NSPredicate(format:"searchKey != nil")
        let ties = managedContext.executeFetchRequest(fetchRequest, error: nil) as! [Bowtie]
        
        if ties.count > 0 {
            return
        }
        
        let path = NSBundle.mainBundle().pathForResource("SampleData", ofType: "plist")
        
        let dataArray = NSArray(contentsOfFile:path!)
        
        for dict:AnyObject in dataArray! {
            
            let bowtie = NSEntityDescription.insertNewObjectForEntityForName("Bowtie", inManagedObjectContext: managedContext) as! Bowtie
            
            let btDict = dict as! NSDictionary
            
            bowtie.name = btDict["name"] as! String
            bowtie.searchKey = btDict["searchKey"] as! String
            bowtie.rating = btDict["rating"] as! NSNumber
            let tintColorDict = btDict["tintColor"] as! NSDictionary
            bowtie.tintColor = colorFromDict(tintColorDict)
            
            let imageName = btDict["imageName"] as! String
            let image = UIImage(named: imageName)
            let photoData = UIImagePNGRepresentation(image)
            bowtie.photoData = photoData
            
            bowtie.lastWorn = btDict["lastWorn"] as! NSDate
            bowtie.timesWorn = btDict["timesWorn"] as! NSNumber
            bowtie.isFavorite = btDict["isFavorite"] as! NSNumber
            
        }
        
        var error : NSError?
        
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error!.userInfo)")
        }
        
    }
    
    func colorFromDict(dict: NSDictionary) -> UIColor {
        
        let red = dict["red"] as! NSNumber
        let green = dict["green"] as! NSNumber
        let blue = dict["blue"] as! NSNumber
        
        let color = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
        
        return color
        
    }
    
    func populate(bowtie: Bowtie) {
        
        imageView.image = UIImage(data: bowtie.photoData)
        nameLabel.text = bowtie.name
        ratingLabel.text = "Rating: \(bowtie.rating.doubleValue)"
        timesWornLabel.text = "# times worn: \(bowtie.timesWorn.integerValue)"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        lastWornLabel.text = dateFormatter.stringFromDate(bowtie.lastWorn)
        favoriteLabel.hidden = !bowtie.isFavorite.boolValue
        
        view.tintColor = bowtie.tintColor as! UIColor
    }
}
































