//
//  HomeViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/21/25.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties
    let memberService = MemberService()
    let postService = PostService()
    
    //MARK: - Data
    private var tableviewData: [String] = [
        "선배의 한마디",
        "맛집 게시판",
        "나의 발자취 "
    ]
    
    // MARK: - View
    private lazy var homeView = HomeView().then {
        let majorTap = UITapGestureRecognizer(target: self, action: #selector(didTapMajorTip))
        $0.majorSelectTipView.addGestureRecognizer(majorTap)
        
        let loadTip = UITapGestureRecognizer(target: self, action: #selector(didTapLoadTip))
        $0.shortLoadTipView.addGestureRecognizer(loadTip)
        
        let useTap = UITapGestureRecognizer(target: self, action: #selector(didTapUseTip))
        $0.useTipView.addGestureRecognizer(useTap)
        
        let schoolTap = UITapGestureRecognizer(target: self, action: #selector(didTapSchoolTip))
        $0.schoolTipView.addGestureRecognizer(schoolTap)
        
        $0.editInfoButton.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
        $0.chatBotButton.addTarget(self, action: #selector(didTapFloatButton), for: .touchUpInside)
    }
    
    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true // 뷰 컨트롤러가 나타날 때 숨기기
        callGetMember()
        callGetRESPhoto()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false // 뷰 컨트롤러가 사라질 때 나타내기
    }
    
    // MARK: - Network
    func callGetMember() {
        memberService.getMember(completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                homeView.name = data.nickname
                homeView.major = data.major
                print(data.nickname, data.major)
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        })
    }
    
    func callGetRESPhoto() {
        postService.getRestaurantHome(completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.homeView.restaurantPosts = data.posts
                print("맛집 이미지 \(data.posts.count)개 로드")
                
            case .failure(let error):
                print("맛집 이미지 로드 실패: \(error.localizedDescription)")
            }
        })
    }
    
    // MARK: - Functional
    private func setDelegate() {
        homeView.homeTableView.delegate = self
        homeView.homeTableView.dataSource = self
        
        homeView.storeCollectionView.delegate = self
        homeView.storeCollectionView.dataSource = self
    }
    
    // MARK: Event
    @objc
    private func didTapEdit() {
        print("정보수정")
    }
    @objc
    private func didTapFloatButton() {
        print("챗봇")
    }
    
    @objc
    private func didTapLoadTip() {
        goToBoard("지름길 보기")
    }
    
    @objc
    private func didTapUseTip() {
        goToBoard("시설 이용하기")
    }
    
    @objc
    private func didTapSchoolTip() {
        goToBoard("학교 생활 꿀팁")
    }
    
    @objc
    private func didTapMajorTip() {
        goToBoard("학과 선택 꿀팁")
    }
    
    private func goToBoard(_ boardName: String) {
        let boardType = BoardType.fromKoreanName(boardName)
        let nextVC = CommonBoardViewController(boardCategory: boardType)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - TableView Extension
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
            goToBoard("학과 선택 꿀팁")
        case 1:
            goToBoard("맛집 게시판")
        case 2:
            print("나의 발자취 보기 클릭")
        default:
            break
        }
    }
}

// MARK: - CollectionView Extension
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeView.restaurantPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StoreCollectionViewCell.identifier,
            for: indexPath
        ) as? StoreCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let post = homeView.restaurantPosts[indexPath.item]
        cell.configure(with: post.imageUrl)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = homeView.restaurantPosts[indexPath.item]
        print("맛집 포스트 클릭: \(post.postId)")
        // TODO: 상세 화면으로 이동
    }
}
