//
//  TableViewController.swift
//  WRTest
//
//  Created by 王刃 on 2018/4/17.
//  Copyright © 2018年 W.R. All rights reserved.
//

import UIKit

let kPlacholderTitle = "Title"

enum ENetworkingStatue: Int {
    case nomal
    case loading
    case success
    case failed
}

class TableViewController: UITableViewController {
    
    var viewModal = WRViewModal()
    
    var state = ENetworkingStatue.nomal {
        didSet(value) {
            setRightBarButton(state == .loading)
            
            switch value {
            case .nomal:
                
                break
            case .loading:
                
                break
            case .success:
                break
            case .failed:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        setupTableView()
        setupNotifications()
        
        refreshNow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: ---------------------- setup
    func setupNav() {
        title = kPlacholderTitle
        setupRefreshButtonAndIndicator()
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: .requestFinished, name: NSNotification.Name(rawValue: kRequestDataFinishedNotification), object: nil)
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        registerTableCells()
    }
    
    func registerTableCells() {
        tableView.register(WRTableViewCell.self, forCellReuseIdentifier: "WRTableViewCell")
    }
    
    //refresh button & indicator
    var refreshBarButtonActivityIndicator: UIBarButtonItem!
    var refreshBarButton: UIBarButtonItem!
    
    func setupRefreshButtonAndIndicator() {
        ///Setting Reload Button
        refreshBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: .refreshPressed)
        
        ///Setting activity Indicator
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        refreshBarButtonActivityIndicator = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.startAnimating()
        
        state = .nomal
    }
    
    func setRightBarButton(_ isLoading: Bool) {
        navigationItem.rightBarButtonItem = isLoading ? refreshBarButtonActivityIndicator : refreshBarButton
    }
    
    //MARK: ----------------------- request
    func refreshNow() {
        //loading statue
        state = .loading
        viewModal.requestData()
        
//        weak var weakSelf = self
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            weakSelf?.statue = .nomal
//        }
    }
    
    func reloadData() {
        title = (viewModal.data?.title != nil) ? viewModal.data?.title : kPlacholderTitle
        tableView.reloadData()
    }
    
    //MARK: Notifications
    func requestDataFinished(_ noti: Notification) {
        let info = noti.userInfo as! [String: ENetworkingStatue]
        let state = info["state"]
        
        self.state = state!
        
        if state == ENetworkingStatue.success{
            reloadData()
        }else {
            //TODO: show failed tips
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModal.data != nil {
            return (viewModal.data?.rows?.count)!
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WRTableViewCell", for: indexPath) as! WRTableViewCell
        
        //set cellData from response data(WRDataDetails)
        let rowData = viewModal.data?.rows?[indexPath.row] as! WRDataDetails
        cell.cellData = CellData(title: rowData.title, desc: rowData.describe, imageUrl: rowData.imageUrl)
        
        cell.layoutIfNeeded()

        return cell
    }
 
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

//MARK: -
private extension Selector {
    static let refreshPressed = #selector(TableViewController.refreshNow)
    static let requestFinished = #selector(TableViewController.requestDataFinished(_:))
}
