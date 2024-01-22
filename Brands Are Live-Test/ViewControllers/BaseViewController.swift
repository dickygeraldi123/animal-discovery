//
//  BaseViewController.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 20/01/24.
//

import Reachability
import UIKit

class BaseViewController: UIViewController {
    let reachability = try! Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true

        DispatchQueue.main.async { [weak self] in
            self?.reachability.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    Dlog("Connected Using Wifi")
                } else {
                    Dlog("Connected Using Data")
                }
            }
            self?.reachability.whenUnreachable = { _ in
                Dlog("Disconnected")
                let vc = NoInternetViewController()
                vc.modalPresentationStyle = .overCurrentContext
                self?.present(vc, animated: true, completion: nil)
            }

            do {
                try self?.reachability.startNotifier()
            } catch {
                Dlog("Unable to start notifier")
            }
        }
    }
    
    deinit {
        reachability.stopNotifier()
    }
}
