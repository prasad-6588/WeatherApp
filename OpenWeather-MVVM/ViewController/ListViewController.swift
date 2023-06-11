//
//  ListViewController.swift
//  OpenWeather-MVVM

import UIKit
import MBProgressHUD

class ListViewController: UIViewController {
    
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    public var listViewModel: ListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "citycell")
        listViewModel = ListViewModel(delegate: self)
        if listViewModel.getNumberOfRows(for: .recent) > 0 {
            self.reloadTableView()
        }
    }
    
    private var imageResolution: String {
        switch UIScreen.main.scale {
        case 1.0:
            return ""
        case 2.0, 3.0:
            return "@2x"
        default:
            return ""
        }
    }
    
    private func reloadTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
}

extension ListViewController: ListViewModelOutputProtocol {
    
    func refreshList(weatherDetails: WeatherDetails) {
        DispatchQueue.main.async {
            self.reloadTableView()
        }
    }
    
    func showError(errorMessage: String) {
        // Alert can be shown here
        print(errorMessage)
    }
    
    func showLoader() {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

extension ListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text,
           searchText.count > 3 {
            self.listViewModel.searchByCityName(cityName: searchText)
            searchBar.resignFirstResponder()
        }
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        listViewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = listViewModel.sections[section]
        return listViewModel.getNumberOfRows(for: sectionType)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = listViewModel.sections[indexPath.section]
        switch sectionType {
        case .recent:
            return 44
        case .current:
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionType = listViewModel.sections[section]
        let numberOfRows = listViewModel.getNumberOfRows(for: sectionType)
        switch sectionType {
        case .recent:
            return (numberOfRows > 0) ? "Recent Searches" : ""
        case .current:
            return (numberOfRows > 0) ? "Current Searches" : ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = listViewModel.sections[indexPath.section]
        switch sectionType {
        case .recent:
            let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
            cell.textLabel?.text = listViewModel.recentCityName(index: indexPath.row)
            cell.selectionStyle = .none
            return cell
        case .current:
            let cell: CityTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "citycell") as! CityTableViewCell
            cell.imageViewCity.downloadedFrom(link: "https://openweathermap.org/img/wn/\(listViewModel.icon)\(imageResolution).png")
            cell.labelCity.text = listViewModel.cityName
            cell.labelDescription.text = listViewModel.weatherDescription
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionType = listViewModel.sections[indexPath.section]
        switch sectionType {
        case .current:
            listViewModel.addCityToRecentList()
        case .recent:
            listViewModel.searchByCityName(cityName: listViewModel.recentCityName(index: indexPath.row))
        }
    }
}
