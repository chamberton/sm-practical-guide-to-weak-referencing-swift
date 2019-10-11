import UIKit
import StoreKit
import Foundation
import ObjectiveC

struct Article { // model for medium article
    let authorFullname: String
    let publicationDate: Date
    var title: String
    var content: String
    var rating: Int
}

enum ServiceError: Error { //possible errors that might occur when fetching articles
    case describedBy(String)
    case `default`
}

protocol MediumArticleLoader { //  requirements of a HTTP client
    func loadMediumArticles(completion:@escaping (([Article]?, ServiceError?) -> Swift.Void))
}

class MediumArticleTableViewController: UITableViewController {
    var mediumArticleLoader: MediumArticleLoader? // to be set
    
    func displayError(_ error: Error?) {
        // Implementation goes here
    }
    func updateDisplayedArticles(_ articles: [Article]) {
        // Implementation goes here
    }
    
    @IBAction func didTapLoadArticleButton(_ sender: UIButton) {
        mediumArticleLoader?.loadMediumArticles { [weak self]
            (fetchedArticles, error) in
            if error==nil {
                self?.displayError(error)
            } else if let loadedArticles = fetchedArticles  {
                self?.updateDisplayedArticles(loadedArticles)
            } else {
                self?.displayError(ServiceError.default)
            }
        }
    }
}

// #############################################################################################################################


struct Session {
    let token: String
}

protocol MediumAuthenticator {
    func authenticate(username: String?, password: String?, completion:@escaping ((Session?, ServiceError?)  -> Swift.Void))
}

class MediumLoginViewController: UIViewController {
    var mediumAuthenticator: MediumAuthenticator? // to be set
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    func displayError(_ error: Error?) {
        // Your implementation
    }
    
    func navigateToMediumHomePage(username: String, token: String) {
        // Your implementation
    }
    
    func navigateToMediumHomePage(userSessionToken token: String) {
        // Your implementation
        // Compute user name here from usernameTextField
    }
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        mediumAuthenticator?.authenticate(username: usernameTextField.text, password: passwordTextField.text) {
            [weak self] (session, error) in
            if let error = error {
                self?.displayError(error)
            } else if let session = session {
                self?.navigateToMediumHomePage(username: (self?.usernameTextField.text)!, token: session.token) // BAD
                // self?.navigateToMediumHomePage(userSessionToken: session.token)     // GOOD (use this call instead of the previous)
            } else {
                self?.displayError(ServiceError.default)
            }
        }
    }
}


// #############################################################################################################################


DispatchQueue.global(qos: .userInteractive).async { }   // `imemdiate call`, but not exactly immediately executed

DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 5) { } // `call with 5-second delay call (on global thread)

DispatchQueue.main.asyncAfter(deadline: .now() + 5) { } // `call with 5-second delay call (on main thread)


// #############################################################################################################################

extension  NSNotification.Name  {
    struct CustomNotificationName {
        static let kAccountRequiresRefreshNotificationName = "accountRequiresRefresh"
    }
    static let accountRequiresRefresh = NSNotification.Name(CustomNotificationName.kAccountRequiresRefreshNotificationName)
}

class MyClass: NSObject {
   
    override init() {
        super.init()
        NotificationCenter.default.addObserver(forName: .accountRequiresRefresh, object: nil, queue: .current, using: { [weak self] _ in // prevent strong capture of self, which might prevent deallocation
            // perform you update or call self here, self is optional --> use self?.
        })
    }
    
    func downloadArticleImage() {
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 5) { [weak self] in
            // call to the download API
        }
    }
    
 
    deinit { NotificationCenter.default.removeObserver(self) }
}

// #############################################################################################################################

class StoreProductInteractor: NSObject {
    
  private func launchStoreProductPage(id productId: UInt64, storeProductDelegate: SKStoreProductViewControllerDelegate) {
    let product = [SKStoreProductParameterITunesItemIdentifier:    NSNumber(value: productId)]
    let storeController = SKStoreProductViewController()
    storeController.delegate = storeProductDelegate
    storeController.loadProduct(withParameters: product) {
        [unowned storeProductDelegate, weak self](success, error) in
        if success {
            //  self is optional --> use self?.
            //  storeProductDelegate is not optional  --> use storeProductDelegate
        } else {
            //  self is optional --> use self?.
            //  storeProductDelegate is not optional  --> use storeProductDelegate
        }
    }
 }

}

// #############################################################################################################################

class CameraPermissionManager {
    
}


class PhotoInteractor {
    unowned var cameraPermissionManager: CameraPermissionManager // we     cannot own[have a strong reference] cameraPermissionManager, but cameraPermissionManager must always exist
    
    init(cameraPermissionManager:  CameraPermissionManager) {
        self.cameraPermissionManager = cameraPermissionManager
    }
    
}


// #############################################################################################################################


class MyClassWithAnimation: NSObject {
    
    func performTypeAAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: { [unowned self] in
            // self should never be nil, unless something terrible had happened
        })
    }
    
    func performTypeBAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            // self should never be nil, unless something terrible had happened
        }
    }

}


// #############################################################################################################################

protocol ScannerDelegate: class {
    func scanner(_ scanner: Scanner, didCompletedScanningWithData scannedData: Data)
}

class BarCodeViewController: UIViewController {
    weak var scannerDelegate: ScannerDelegate?
}

// #############################################################################################################################


class UITableViewController {
    var tableView: UITableView! { get set } // owns a UITableView with strong reference
}

class UITableView {
    weak var delegate: UITableViewDelegate? { get set } // owns a   UITableViewDelegate view with weak reference
    weak var dataSource: UITableViewDataSource? { get set } // owns a   UITableViewDataSource view with weak reference
}


// #############################################################################################################################


class MyUIViewController: UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak private(set) var tableView: UITableView! { get set } // owns a UITableView with weak reference, linked to the a tableview added in the nib for MyUIViewController
    // MARK:- UITableViewDataSource
    // required methods for UITableViewDataSource go here
    // MARK:- UITableViewDelegate
    // required methods for UITableViewDelegate go here
}

class UITableView {
    weak var delegate: UITableViewDelegate? { get set } // owns a  UITableViewDelegate view with weak reference
    weak var dataSource: UITableViewDataSource? { get set } // owns a  UITableViewDataSource view with weak reference
}

// #############################################################################################################################


class Operation {
    weak var opertionManager: OperationManager? { get set } // owns a OperationManager with wealreference
}

class OperationManager {
    let operation: Operation? { get set }  // owns a OperationManager with wealreference
}

class OperationManager: NSObject {
    private var weakOperations = NSPointerArray.weakObjects() // NSPointer array with weak referenced objects
    
    public func addOperation(_ operation: AbstractOperation) {
        objc_sync_enter(self) // safe to synchronize
        unowned var weakOperation = operation // because at this point we guarantee the existence of operation but we do not want to own it
        
        let pointer = Unmanaged.passUnretained(weakOperation).toOpaque()
        weakOperations.compact() // remove operations that might have been deallocated
        
        weakOperations.addPointer(pointer) // insert weak reference
        
        objc_sync_exit(self)
    }
    
    @objc public func removeOperation(_ operation: Operation) {
        objc_sync_enter(self) // safe to synchronize, especially if your operation addition might occur in various thread
        
        weakOperations.compact() // remove operations that might have been deallocated
        
        var validOperations: [AnyObject]? = weakOperations.allObjects as [AnyObject]? // obtain remaining operations
        
        var operationToRemove = operation as? AnyObject // convert operation to remove into any since we store pointers and type specific objects
        
        if let index = validOperations?.firstIndex(where: { $0 === operationToRemove }) {
            validOperations = nil // remove array having strong holds
            weakOperations.removePointer(at: index)
        }
        objc_sync_exit(self)
    }
}

// #############################################################################################################################
