//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var businesses: [Business]!
    var filteredData : [Business]!
    
    var isMoreDataLoading = false
    var loadingMoreView : InfiniteScrollActivityView?
    var offset : Int? = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredData = businesses
            self.tableView.reloadData()
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
        
        let searchBar = UISearchBar()
        searchBar.keyboardType = UIKeyboardType.Default
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.barTintColor = UIColor(red: 200/255, green: 22/255, blue: 5/225, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? businesses : businesses?.filter ({ (business : Business) -> Bool in
            //reference to business name from business.swift in Models folder
            return (business.name)!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })

        tableView.reloadData()
    }
    
    //Infinite Scrolling
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (!isMoreDataLoading) {
            //Calculate the positions of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            //When the user has scorlled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                //Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                //Call function to load more results
                loadMoreData()
            }
        }
    }
    
    //load more data
    func loadMoreData() {
        //Don't have configure session,just call it from the Business View
        //Added parameters to the class function to include the offset within the tableView
        Business.searchWithTerm("Thai", sort: .Distance, categories: [], deals: true, offset: self.offset, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            if (businesses != []) {
                //This conditional states that if the businesses does not equal to the array,
                //correct it by appending the other businesses
                for business in businesses {
                    print("Appending")
                    self.businesses.append(business)
                }
                //Update Flag
                self.isMoreDataLoading = false
                //Stop Loading Indicator
                self.loadingMoreView!.stopAnimating()
                
                //Reload and extend the offset to introduce the new data
                //self.filteredData = self.businesses
                self.tableView.reloadData()
                self.offset! += 10
            }
            self.isMoreDataLoading = false
        })
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let business = businesses[(indexPath?.row)!]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.business = business
    }
}
