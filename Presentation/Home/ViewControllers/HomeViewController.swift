//
//  HomeViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/21/25.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties
    //MARK: - Data
    private var tableviewData: [String] = [
        "선배의 한마디",
        "맛집 게시판",
        "나의 발자취 "
    ]
    
    // MARK: - View
    private lazy var homeView = HomeView().then {
        $0.editInfoButton.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
        $0.chatBotButton.addTarget(self, action: #selector(didTapFloatButton), for: .touchUpInside)
    }
    
    
    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        
        setDelegate()
    }
    
    // MARK: - Functional
    private func setDelegate() {
        homeView.homeTableView.delegate = self
        homeView.homeTableView.dataSource = self
    }
    
    @objc
    private func didTapEdit() {
        print("정보수정")
    }
    @objc
    private func didTapFloatButton() {
        print("챗봇")
    }
}


// MARK: - Extension
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableviewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HomeTableViewCell.identifier,
            for: indexPath
        ) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        let title = tableviewData[indexPath.row]
        cell.configure(title: title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            print("선배의 한마디 남기기 클릭")
        case 1:
            print("맛집 게시판 가기 클릭")
        case 2:
            print("나의 발자취 보기 클릭")
        default:
            break
        }
    }
}
