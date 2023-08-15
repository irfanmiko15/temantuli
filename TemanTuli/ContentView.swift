//
//  ContentView.swift
//  TemanTuli
//
//  Created by Irfan Dary Sujatmiko on 02/08/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var classificationViewModel = ClassificationViewModel()
    var body: some View {
        MainView().environmentObject(classificationViewModel)
    }
}
