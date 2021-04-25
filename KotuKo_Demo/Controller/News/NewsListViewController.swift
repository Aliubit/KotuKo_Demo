//
//  NewsListViewController.swift
//  KotuKo_Demo
//
//  Created by Ali on 23/04/2021.
//

import UIKit

class NewsListViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var newsTableView : UITableView!
    @IBOutlet weak var filterBtn : UIBarButtonItem!
    @IBOutlet weak var categoryView : UIView!
    @IBOutlet weak var categoryPicker : UIPickerView!
    
    //MARK:- Data Members
    var dataSource = [News]()
    var categoryList = [Category]()
    var selectedFilter : Category? {
        didSet {
            filterUpdated()
        }
    }
    var pageNumber = 1
    var isFullyLoaded = false
    
    // MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        getCategories()
        getNews(page: pageNumber)
    }
    
    // Initialize UI Code here
    func setupUI() {
        UIBarButtonItem.appearance().setTitleTextAttributes(
        [
            NSAttributedString.Key.font : UIFont(name: "Menlo-Regular", size: 20)!,
        ], for: .normal)
        setPickerView(hide: true)
        filterBtn.tintColor = .link
        newsTableView.tableFooterView =  UIView()
        
        // Tap gesture to close categoryView
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.closeCategoryPicker(_:)))
        categoryView.addGestureRecognizer(dismissTap)
        categoryView.isUserInteractionEnabled = true
    }
    
    // MARK:- Network Calls
    // Fetch categories
    func getCategories() {
        AFManager.getCategories(completion: { categories in
            if let categories = categories {
                self.categoryList = categories
                self.categoryPicker.reloadAllComponents()
            }
        })
    }

    // Fetch news
    func getNews(page : Int) {
        Utility.showActivityIndicator(view: self.view, targetVC: self)
        AFManager.getNews(page: page,filterID: selectedFilter?.id, completion: { newsList in
            Utility.hideActivityIndicator(view: self.view)
            if let newsList = newsList {
                // Logic to check if all the data has already been loaded, so skip the pagination in scroll
                if newsList.count == 0{
                    self.isFullyLoaded = true
                }
                else if newsList.count < Constants.defaultBatchSize {
                    self.isFullyLoaded = true
                }
                
                self.dataSource.append(contentsOf: newsList)
                DispatchQueue.main.async {
                    self.newsTableView.reloadData()
                }
            }
        })
    }
    
    // MARK:- Picker View UI Function
    // Show or Hide pickerview
    func setPickerView(hide : Bool) {
        UIView.transition(with: self.categoryView, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.categoryView.isHidden = hide
        }, completion: nil)
    }
    
    @objc func closeCategoryPicker(_ sender: UITapGestureRecognizer) {
        setPickerView(hide: true)
    }
    
    // MARK:- Filter Logic
    
    func filterUpdated() {
        pageNumber = 1
        dataSource = [News]()
        isFullyLoaded = false
        newsTableView.reloadData()
        getNews(page: pageNumber)
        if let selectedFilter = selectedFilter {
            self.filterBtn.tintColor = .red
            self.filterBtn.title = selectedFilter.name ?? Constants.emptyLabel
        }
        else {
            self.filterBtn.tintColor = .link
            self.filterBtn.title = Constants.filterString
        }
    }
    
    // MARK:- Actions
    
    @IBAction func onFilter() {
        setPickerView(hide: false)
    }
    
    @IBAction func clearFilter() {
        self.selectedFilter = nil
        setPickerView(hide: true)
    }

}

// MARK:- TableView Methods
// Delegate and DataSource functions
extension NewsListViewController : UITableViewDataSource , UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellsIdentifier.NewsListCell.rawValue)! as! NewsTableViewCell
        cell.updateCell(news: dataSource[indexPath.row])
        
        if indexPath.row == dataSource.count - 1 && !isFullyLoaded{ // last cell
            self.pageNumber += 1
            print("fetching for page \(self.pageNumber)")
            self.getNews(page: self.pageNumber)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Segues.NewsDetail.rawValue, sender: dataSource[indexPath.row])
    }
}


// MARK:- News Detail
// Navigation
extension NewsListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newsDetailVC = segue.destination as! NewsDetailViewController
        newsDetailVC.news = sender as? News
    }
}

// MARK:- Picker View
// Delegate and DataSource functions
extension NewsListViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row].name ?? Constants.emptyLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedFilter = categoryList[row]
        setPickerView(hide: true)
    }
    
}

