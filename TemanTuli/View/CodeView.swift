//
//  CodeView.swift
//  TemanTuli
//
//  Created by Nathalia Minoque Kusuma Salma Rasyid Jr. on 15/08/23.
//

import SwiftUI

struct CodeView: View {
    var body: some View {
        ZStack{
            Image("bg-camera")
                .resizable()
            HStack{
                Spacer()
                VStack(alignment: .leading){
                    Text("Hi!")
                        .bold()
                        .font(.title3)
                        
                    Text("I want to have a conversation with you")
                    Text("Please scan this code")
                    Image("app-clip-code")
                        .resizable()
                        .frame(width: 160, height: 160)
                        .padding(.top)
                }
                .frame(maxWidth: 240, maxHeight:320)
                .padding(16)
                .background(Color("bg-secondary"))
                .cornerRadius(20)
            }
        }
        .ignoresSafeArea()
    }
}

struct CodeView_Previews: PreviewProvider {
    static var previews: some View {
        CodeView()
    }
}
