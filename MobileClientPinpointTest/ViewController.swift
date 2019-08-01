//
//  ViewController.swift
//  MobileClientPinpointTest
//
//  Created by Schmelter, Tim on 8/1/19.
//  Copyright © 2019 Amazon Web Services. All rights reserved.
//

import UIKit
import AWSMobileClient

class ViewController: UIViewController {

    @IBOutlet weak var signInOutButton: UIButton!

    var currentUserState: UserState = .unknown {
        didSet {
            switch currentUserState {
            case .signedIn:
                signInOutButton.setTitle("Sign out", for: .normal)
            default:
                signInOutButton.setTitle("Sign in", for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currentUserState = AWSMobileClient.sharedInstance().currentUserState
        AWSMobileClient.sharedInstance().addUserStateListener(self) { [weak self] userState, _ in
            self?.currentUserState = userState
        }
    }

    deinit {
        AWSMobileClient.sharedInstance().removeUserStateListener(self)
    }

    @IBAction func didTapSignInOutButton(_ sender: Any) {
        if currentUserState == .signedIn {
            AWSMobileClient.sharedInstance().signOut()
            return
        }

        guard let navigationController = navigationController else {
            print("navigationController unexpectedly nil")
            return
        }

        AWSMobileClient.sharedInstance().showSignIn(navigationController: navigationController) { userState, error in
            if let error = error {
                print("Unexpected error in showSignIn: \(error)")
                return
            }

            guard let userState = userState else {
                print("userState unexpectedly nil in showSignIn")
                return
            }

            print("showSignIn result: \(userState)")
        }

    }

}
