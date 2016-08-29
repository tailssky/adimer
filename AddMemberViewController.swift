//
//  AddMemberViewController.swift
//  Adam
//
//  Created by 周岩峰 on 7/29/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//

import UIKit
import AVOSCloud

class AddMemberViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchResults = [User]()
    var byClub: Club!
    var currentUser: User!
    
    var hasSearched = false
    
    struct UserResultsCellIdentifiers {
        static let searchResultCell = "UserInfoCell"
        static let nothingFound = "NothingFoundCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        //config the custom cell
        let cellNib = UINib(nibName: UserResultsCellIdentifiers.searchResultCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: UserResultsCellIdentifiers.searchResultCell)
        let cellNib1 = UINib(nibName: UserResultsCellIdentifiers.nothingFound, bundle: nil)
        tableView.registerNib(cellNib1, forCellReuseIdentifier: UserResultsCellIdentifiers.nothingFound)
        
        tableView.rowHeight = 80

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddMemberViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
        return searchResults.count
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = searchResults[indexPath.row]
        
        if let showUserInfoView = self.storyboard?.instantiateViewControllerWithIdentifier("ShowUserInfoView") as? ShowUserInfoTableViewController {
            showUserInfoView.fromClub = byClub
            showUserInfoView.userForShow = user
            showUserInfoView.currentUser = currentUser
            if user.userID == currentUser.userID {
                showUserInfoView.viewType = 1
            } else {
                showUserInfoView.viewType = 0}
            
            self.navigationController?.pushViewController(showUserInfoView, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if searchResults.count == 0 {
            return tableView.dequeueReusableCellWithIdentifier(UserResultsCellIdentifiers.nothingFound, forIndexPath: indexPath)
//            return tableView.dequeueReusableCellWithIdentifier(UserResultsCellIdentifiers.searchResultCell, forIndexPath: indexPath)
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(UserResultsCellIdentifiers.searchResultCell, forIndexPath: indexPath) as! UserInfoCellTableViewCell
            
            cell.portraitImage.image = searchResults[indexPath.row].userPortraitImage
            cell.mainName.text = searchResults[indexPath.row].nickname
            cell.subName.text = searchResults[indexPath.row].userName
            
            
            return cell
        }
    }
    
}

extension AddMemberViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let searchtext = searchBar.text
        searchResults = []
        if searchtext != "" {
            let queryPhoneNum = AVQuery(className: "_User")
            queryPhoneNum.whereKey("mobilePhoneNumber", equalTo: searchtext)
            let queryEmail = AVQuery(className: "_User")
            queryEmail.whereKey("email", equalTo: searchtext)
            let queryNickname = AVQuery(className: "_User")
            queryNickname.whereKey("nickName", containsString: searchtext)
            let queryUsername = AVQuery(className: "_User")
            queryUsername.whereKey("username", containsString: searchtext)
            let query = AVQuery.orQueryWithSubqueries([queryPhoneNum,queryEmail,queryNickname,queryUsername])
            query.findObjectsInBackgroundWithBlock({avObjects, error in
                if error == nil {
                    for avObject in avObjects {
                        let avuser = avObject as! AVUser
                        let foundUser = User.changerAVUserToUserNoAuthority(avuser)
                        if let foundUser = foundUser {
                        self.searchResults.append(foundUser)
                        }
                    }
                    self.hasSearched = true
                    self.tableView.reloadData()
                } else {
                    print("\(error)")
                }})
        }else {
            return
        }
    }
}
