import UIKit

protocol SeSACTableViewControllerProtocol: SeSACViewControllerProtocol, UITableViewDelegate, UITableViewDataSource {
    func configure()
}
