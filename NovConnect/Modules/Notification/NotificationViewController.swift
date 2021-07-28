//
//  NotificationViewController.swift
//  NovConnect
//
//  Created by Tai Phan Van on 17/07/2021.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationViewController: UITableViewController {
    
    // MARK: - Properties
    var notifications = [NotificationModel]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Views
    private var refresher = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        fetchNotifications()
    }
    
    // MARK: - Helpers
    func configureTableView() {
        
        navigationItem.title = "Notifications"
        
        tableView.backgroundColor = .white
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
    
    func fetchNotifications() {
        NotificationService.fetchNotifications { notifications in
            self.notifications = notifications
            self.checkIfUserIsFollowing()
        }
    }
    
    func checkIfUserIsFollowing() {
        notifications.forEach { noti in
            if noti.type == .follow {
                UserService.checkIfUserIsFollowing(user: noti.uid) { isFollowing in
                    if let index = self.notifications.firstIndex(where: { $0.id == noti.id }) {
                        self.notifications[index].userIsFollowing = isFollowing
                    }
                }
            }
        }
    }
    
    @objc func handleRefresh() {
        notifications.removeAll()
        fetchNotifications()
        refresher.endRefreshing()
    }
}

// MARK: - UITableViewDelegate
extension NotificationViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DebugLog(self)
        showLoading(true)
        let uid = notifications[indexPath.row].uid
        
        UserService.fetchUser(with: uid) { user in
            self.showLoading(false)
            if let user = user {
                let controller = ProfileViewController(user: user)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension NotificationViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        if indexPath.row < notifications.count {
            cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        }
        cell.delegate = self
        return cell
    }
}

// MARK: - NotificationCellDelegate
extension NotificationViewController: NotificationCellDelegate {
    func notificationCell(_ cell: NotificationCell, follow user: String) {
        DebugLog(self)
        showLoading(true)
        UserService.follow(user: user) { result in
            self.showLoading(false)
            if result {
                cell.viewModel?.notification.userIsFollowing.toggle()
                PostService.updateUserFeed(user: user, isFollow: true)
            }
        }
    }
    
    func notificationCell(_ cell: NotificationCell, unfollow user: String) {
        DebugLog(self)
        showLoading(true)
        UserService.unfollow(user: user) { result in
            self.showLoading(false)
            if result {
                cell.viewModel?.notification.userIsFollowing.toggle()
                PostService.updateUserFeed(user: user, isFollow: false)
            }
        }
    }
    
    func notificationCell(_ cell: NotificationCell, open post: String) {
        DebugLog(self)
        // TODO: - or not
    }
}
