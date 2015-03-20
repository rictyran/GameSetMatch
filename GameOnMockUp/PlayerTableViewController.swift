
//
//  PlayerTableViewController.swift
//  GameOnMockUp
//
//  Created by Jeanie House on 3/16/15.
//  Copyright (c) 2015 Richard Tyran. All rights reserved.
//

import UIKit


  var newCell: String!


class PlayerTableViewController: UITableViewController {
    
    @IBAction func backButton(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    


    
  
    
    // Change to segmented controls
    
    @IBAction func fiveMileButton(sender: AnyObject) {
        
        mileDistance = 5
        refreshPlayers()
 
        
    }
    @IBAction func tenMileButton(sender: AnyObject) {
        
        mileDistance = 10
        refreshPlayers()
        
    }
    @IBAction func twentyMileButton(sender: AnyObject) {
        
        mileDistance = 20
        refreshPlayers()
        
    }
    
    
    
    
    
    
   // let postImages = ["female2"]
    
    var players: [PFUser] = []
    
    let postTitles = ["firstName"]
    
    var mileDistance: Double = 10
    
    let ageRange: [String] = []
    
    let skillLevel: [String] = []
    
    let gender = ""
    
    var postShown = [Bool](count: 6, repeatedValue: false)
    
    
    var chosenAgeRanges:[String] = []
    var chosenSkillLevel:[String] = []
    var chosenGender:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshPlayers()
        
        
    }
    
    func refreshPlayers() {
        
        var playerQuery = PFUser.query()
        
        if let selfGeo = PFUser.currentUser()["location"] as? PFGeoPoint {
            
            // add buttons for narrowing down to 10 and 5 mile radius
            
            playerQuery.whereKey("location", nearGeoPoint: selfGeo, withinMiles: mileDistance)
            
        }
        
        
        
        if chosenAgeRanges.count > 0 { playerQuery.whereKey("ageRange", containedIn: chosenAgeRanges) }
        
        if chosenSkillLevel.count > 0 { playerQuery.whereKey("skillLevel", containedIn: chosenSkillLevel)}
        //
        if gender != "" { playerQuery.whereKey("gender", equalTo: gender) }
        //
        
        playerQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            // update players = objects & reloadData
            self.players = objects as [PFUser]
            
            println(self.players)
            
            self.tableView.reloadData()
            
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return players.count
        //return postTitles.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> PlayersTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as PlayersTableViewCell
        
        // Configure the cell...   If let statments
      //  cell.postImageView.image = UIImage(named: postImages[indexPath.row])
//        
        let player = players[indexPath.row]
        println(players)
        cell.titleLabel.text = player["firstName"] as? String
        cell.skillLabel.text = player["skillLevel"] as? String
        cell.locLabel.text = player["zipCode"] as? String
        cell.ageLabel.text = player["ageRange"] as? String
        cell.genderLabel.text = player["gender"] as? String
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // Determine if the post is displayed. If yes, we just return and no animation will be created
        if postShown[indexPath.row] {
            return;
        }
        
        // Indicate the post has been displayed, so the animation won't be displayed again
        postShown[indexPath.row] = true
        
        
        // Define the initial state (Before the animation)
        // cell.alpha = 0
        
        // Define the final state (After the animation)
        // UIView.animateWithDuration(1.0, animations: { cell.alpha = 1 })
        
        
        // Define the initial state (Before the animation)
        let rotationAngleInRadians = 90.0 * CGFloat(M_PI/180.0);
        //        let rotationTransform = CATransform3DMakeRotation(rotationAngleInRadians, 0, 0, 1);
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
        cell.layer.transform = rotationTransform;
        
        // Define the final state (After the animation)
        UIView.animateWithDuration(1.0, animations: { cell.layer.transform = CATransform3DIdentity })
        
    }
    
  
  
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as PlayersTableViewCell
        
        newCell = cell.titleLabel.text
        
        var schedulerViewController = storyboard?.instantiateViewControllerWithIdentifier("SVC") as SchedulerVCViewController
        
        
        navigationController?.pushViewController(schedulerViewController, animated: true)
        
       
        
    }
//
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
