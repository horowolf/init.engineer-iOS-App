//
//  ReviewTabController.swift
//  init.engineer-iOS-App
//
//  Created by 楊承昊 on 2021/1/29.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit
import KaobeiAPI
import GoogleMobileAds

class ReviewTabController: UIViewController {
    
    var userToken: String?
    @IBOutlet weak var reviewTable: UITableView!
    var reviewList = [ArticleUnderReview?]()
    //var count = 1
    var adBanner = GADBannerView(adSize: kGADAdSizeMediumRectangle)
    
    let GAP_ID = "gap"
    let REVIEW_ID = "review"
    let TITLE_ID = "title"
    
    //var reloadBlocker = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let accessToken = KeyChainManager.shared.getToken() {
            self.userToken = accessToken
            print(accessToken)
            if self.reviewList.count > 0 {
                return
            }
            
            self.adBanner.adUnitID = K.getInfoPlistByKey("GAD AdsBanner1") ?? ""
            self.adBanner.rootViewController = self
            self.adBanner.load(GADRequest())
            
            self.reviewTable.allowsSelection = false
            self.reviewTable.delegate = self
            self.reviewTable.dataSource = self
            self.reviewTable.backgroundColor = .clear
            self.reviewTable.sectionHeaderHeight = 20.0
            self.reviewTable.register(ArticleCell.self, forCellReuseIdentifier: REVIEW_ID)
            self.reviewTable.register(TableViewTitle.self, forCellReuseIdentifier: TITLE_ID)
            self.reviewTable.register(TableViewGap.self, forHeaderFooterViewReuseIdentifier: GAP_ID)
            self.reviewList.append(nil)
            
            //reloadBlocker = true
            let listRequest = KBGetArticleReviewList.init(accessToken: accessToken)
            KaobeiConnection.sendRequest(api: listRequest) { [weak self] response in
                //self?.reloadBlocker = false
                switch response.result {
                case .success(let data):
                    self?.reviewList.append(contentsOf: data.data)
                    self?.reviewList.append(nil)
                    self?.reviewTable.reloadData()
                    //self?.count += 1
                    break
                case .failure(let error):
                    print(error.responseCode ?? "")
                    self?.reviewList.append(nil)
                    self?.reviewTable.reloadData()
                    break
                }
            }
        }
        else {
            self.userToken = nil
            self.reviewList.removeAll()
            self.reviewTable.reloadData()
            self.performSegue(withIdentifier: K.reviewToLoginSegue, sender: self)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ReviewTabController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.reviewTable.dequeueReusableCell(withIdentifier: TITLE_ID) as! TableViewTitle
            //cell.setupUI()
            return cell
        }
        
        let cell = self.reviewTable.dequeueReusableCell(withIdentifier: REVIEW_ID) as! ArticleCell
        if let review = reviewList[indexPath.section] {
            cell.makeArticleInReview(content: review)
        } else {
            cell.makeAds(ads: self.adBanner)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: GAP_ID) as! TableViewGap
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return tableView.sectionHeaderHeight
    }
    
    /*
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if reloadBlocker == true { return }
        guard let userToken = self.userToken else { return }
        
        if indexPath.section >= self.reviewList.count - 2 {
            reloadBlocker = true
            let listRequest = KBGetArticleReviewList.init(accessToken: userToken)
            KaobeiConnection.sendRequest(api: listRequest) { [weak self] response in
                self?.reloadBlocker = false
                switch response.result {
                case .success(let data):
                    self?.reviewList.append(contentsOf: data.data)
                    self?.reviewList.append(nil)
                    self?.reviewTable.reloadData()
                    self?.count += 1
                    break
                case .failure(let error):
                    print(error.responseCode ?? "")
                    self?.reviewList.append(nil)
                    self?.reviewTable.reloadData()
                    break
                }
            }
        }
    }
    */
}