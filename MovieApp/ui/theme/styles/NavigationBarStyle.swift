//
//  NavigationBarStyle.swift
//  MovieApp
//
//  Created by selinay ceylan on 26.09.2025.
//

import Foundation
import SwiftUI

class NavigationBarStyle {
    static func setupNavigationBar() {
        let largeAppearance = UINavigationBarAppearance()
        largeAppearance.backgroundColor = UIColor(AppColor.mainColor)
        largeAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Lato-Regular", size: 20)!
        ]
        largeAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Lato-Regular", size: 32)!
        ]
        
        let inlineAppearance = UINavigationBarAppearance()
        inlineAppearance.backgroundColor = UIColor(AppColor.mainColor)
        inlineAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Lato-Regular", size: 20)!
        ]
        
        UINavigationBar.appearance().standardAppearance = inlineAppearance
        UINavigationBar.appearance().compactAppearance = inlineAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = largeAppearance
        UINavigationBar.appearance().tintColor = .black
        
            
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(
                string: "Search",
                attributes: [.foregroundColor: UIColor.white]
            )
            

    }
}
