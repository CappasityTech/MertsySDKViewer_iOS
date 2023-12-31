import UIKit
import Mertsy

final class ViewController: UIViewController {
    
    private let service = MertsyViewer()

    @IBOutlet private weak var skuTextField: UITextField!
    @IBOutlet private weak var modelView: MertsyModelView!
    @IBOutlet private weak var activity: UIActivityIndicatorView!
    
    @IBAction func searchButton(_ sender: Any) {
        guard let sku = skuTextField.text, !sku.isEmpty else { return }
        activity.startAnimating()
        service.getModel(sku: sku) { [weak self] result in
            switch result {
            case .success(let model):
                self?.loadModel(model)
            case .failure(let error):
                self?.activity.stopAnimating()
                self?.showAlert(message: error.rawValue)
            }
        }
    }
    
    private func loadModel(_ model: MertsyModel) {
        modelView.viewController = self
        let params = MertsyModelViewParams(isAutoRotate: true, autoRotateDelay: 10, language: .en)
        modelView.load(model: model, parameters: params) { [weak self] result in
            self?.activity.stopAnimating()
            if case .failure(let error) = result {
                self?.showAlert(message: error.rawValue)
            }
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

