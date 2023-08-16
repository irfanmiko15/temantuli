//
//  MainView.swift
//  TemanTuli
//
//  Created by Nathalia Minoque Kusuma Salma Rasyid Jr. on 10/08/23.
//

import SwiftUI

struct MainView: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    
    var body: some View {
        ZStack{
            Image("bg-camera")
//                .zIndex(0)
            HStack{
                Spacer()
                VStack{
                    HStack{
                        VStack(alignment: .leading){
                            Text("Hello, i Adi")
//                                .padding(.bottom, 1)
//                                .zIndex(1)
                            Text("Did you mean: Hello, i am Adi")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color("bg-primary"))
                        .cornerRadius(8)
                       Spacer()
                    }
                    .padding(.vertical, 4)
                    .padding(.trailing, 36)
                    HStack{
                        Spacer()
                        VStack(alignment: .leading){
                                        Text(speechRecognizer.transcript)
                                .foregroundColor(.black)
                            //            .padding()
//                            Text("Hello Adi, nice to meet you")
//                                .padding(.bottom, 1)
//                            Text("Did you mean: Hello, i am Adi")
//                                .font(.caption2)
//                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color("bg-primary"))
                        .cornerRadius(8)
                    }
                    .padding(.vertical, 4)
                    .padding(.leading, 36)
                    
                    Spacer()
                    
                    Button {
                        if !isRecording {
                            speechRecognizer.transcribe()
                        } else {
                            speechRecognizer.stopTranscribing()
                        }
                        isRecording.toggle()
                    } label: {
                        Image(systemName: "mic")
                            .bold()
                    }
                    .padding(24)
                    .foregroundColor(.white)
                    .background(.blue)
                    .clipShape(Circle())
                }
                .frame(maxWidth: 240, maxHeight:320)
                .padding(16)
                .background(Color("bg-secondary"))
                .cornerRadius(20)
            }
//            .zIndex(1)
        }
        .ignoresSafeArea()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
