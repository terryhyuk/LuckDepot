//
//  UIApplication+RootViewController.swift
//  Lucky_Depot
//
//  Created by Eunji Kim on 1/22/25.
//

import Foundation
import UIKit

extension UIApplication {
  var currentKeyWindow: UIWindow? {
    UIApplication.shared.connectedScenes
      .compactMap { ($0 as? UIWindowScene)?.keyWindow }
      .first
  }

  var rootViewController: UIViewController? {
    currentKeyWindow?.rootViewController
  }
}
