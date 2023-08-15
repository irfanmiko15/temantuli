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
        VStack{
            Text(speechRecognizer.transcript)
            .padding()
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
            .padding(20)
            .foregroundColor(.white)
            .background(.blue)
            .cornerRadius(36)
        }.onAppear{
//            speechController.requestSpeechRecognitionAuthorization()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
