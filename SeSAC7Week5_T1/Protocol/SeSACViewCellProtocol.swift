import UIKit

protocol SeSACViewCellProtocol: SeSACViewProtocol {
    associatedtype DataType
    
    func configuerHierarchy()
    func configureLayout()
    func configureUI(rowData: DataType)
}
