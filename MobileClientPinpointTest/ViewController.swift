//
//  ViewController.swift
//  MobileClientPinpointTest
//
//  Created by Schmelter, Tim on 8/1/19.
//  Copyright © 2019 Amazon Web Services. All rights reserved.
//

import UIKit

import AWSMobileClient
import AWSPinpoint

class ViewController: UIViewController {

    @IBOutlet weak var signInOutButton: UIButton!

    var mobileClient: AWSMobileClient {
        return AWSMobileClient.sharedInstance()
    }

    var pinpoint: AWSPinpoint? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.pinpoint
    }

    var analyticsClient: AWSPinpointAnalyticsClient? {
        return pinpoint?.analyticsClient
    }

    var currentUserState: UserState = .unknown {
        didSet {
            switch currentUserState {
            case .signedIn:
                DispatchQueue.main.async {
                    self.signInOutButton.setTitle("Sign out", for: .normal)
                }
            default:
                DispatchQueue.main.async {
                    self.signInOutButton.setTitle("Sign in", for: .normal)
                }
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

    // MARK: - IBActions

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

    @IBAction func didTapSendEventA(_ sender: Any) {
        recordEvent(named: "event_a")
    }

    @IBAction func didTapSendEventB(_ sender: Any) {
        recordEvent(named: "event_b")
    }

    // MARK: - Utility functions

    private func recordEvent(named eventType: String) {
        guard let analyticsClient = analyticsClient else {
            return
        }

        let event = analyticsClient.createEvent(withEventType: eventType)
        analyticsClient.record(event)

        // Note: Normally this would be batched or timed, rather than submitted on each event
        analyticsClient.submitEvents()
    }

}
