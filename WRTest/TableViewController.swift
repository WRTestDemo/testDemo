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
        //request finished
        NotificationCenter.default.addObserver(self, selector: .requestFinished, name: NSNotification.Name(rawValue: kRequestDataFinishedNotification), object: nil)
        //to update cell
        NotificationCenter.default.addObserver(self, selector: .updateImageForCell, name: NSNotification.Name(rawValue: kLoadedImageNotification), object: nil)
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
        //loading state
        state = .loading
        viewModal.requestData()
    }
    
    func reloadData() {
        title = (viewModal.data?.title != nil) ? viewModal.data?.title : kPlacholderTitle
        tableView.reloadData()
        loadImageForCells()
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
    
    func updateImageForCell(_ notification: Notification) {
        let info = notification.userInfo
        let image = info?["img"] as! UIImage
        let indexPath = info?["indexPath"] as! IndexPath
        
        
        //get cell from indexPath
        let cell = tableView.cellForRow(at: indexPath) as? WRTableViewCell
//        cell.imgView.image = image
        
        print("----------- set cell")
        print(image, indexPath)
        print(cell?.cellData?.imageUrl)
        print("--------------------")

//        DispatchQueue.main.async {
            cell?.updateImageView(image: image)
//        }
        
//        cell.setNeedsLayout()
//        cell.layoutIfNeeded()
    }
    
    func loadImageForCells() {
        let cells = tableView.indexPathsForVisibleRows!
        for indexPath in cells {
            let cell = tableView.cellForRow(at: indexPath) as? WRTableViewCell
            viewModal.downloadImage(cell?.cellData?.imageUrl, indexPath)
        }
    }
}

//MARK: - tableview dataSource
extension TableViewController {
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
    
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "WRTableViewCell", for: indexPath) as! WRTableViewCell
////        if cell ！= nil{
//            return cell.getCellHeight()
////        }
//        return UITableViewAutomaticDimension
//    }
}

//MARK: - scroll
extension TableViewController {
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImageForCells()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImageForCells()
    }
}

//MARK: -
private extension Selector {
    static let refreshPressed = #selector(TableViewController.refreshNow)
    static let requestFinished = #selector(TableViewController.requestDataFinished(_:))
    static let updateImageForCell = #selector(TableViewController.updateImageForCell(_:))
}
