//
//  MainView.swift
//  TemanTuli
//
//  Created by Nathalia Minoque Kusuma Salma Rasyid Jr. on 10/08/23.
//

import SwiftUI

extension Animation {
    func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}

struct MainView: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @State private var scale = 1.0
    @State var isAnimating = false
    
    var body: some View {
        ZStack{
            Image("bg-camera")
            HStack{
                Spacer()
                VStack{
                    HStack{
                        VStack(alignment: .leading){
                            Text("Hello, i Adi")
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
                        }
                        .padding()
                        .background(Color("bg-primary"))
                        .cornerRadius(8)
                    }
                    .padding(.vertical, 4)
                    .padding(.leading, 36)
                    
                    Spacer()
                    
                    ZStack{
                        
                        Image("mic-circle-2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 88)
                            .opacity(isAnimating ? 1 : 0.0) // Apply opacity animation
                            .animation(Animation.easeInOut(duration: 2).repeat(while: isAnimating))
                        
                        Image("mic-circle-1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 76)
                            .opacity(isAnimating ? 1 : 0.0) // Apply opacity animation
                            .animation(Animation.easeInOut(duration: 1).repeat(while: isAnimating))
                        
                        
                        Button {
                            print(isAnimating)
                            isAnimating.toggle()
                            if !isRecording {
                                speechRecognizer.transcribe()
                            } else {
                                speechRecognizer.stopTranscribing()
                            }
                        } label: {
                            Image(systemName: "mic")
                                .bold()
                        }
                        .padding(24)
                        .foregroundColor(.white)
                        .background(.blue)
                        .clipShape(Circle())
                        
                    }
                    
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
