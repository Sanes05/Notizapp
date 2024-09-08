//
//  ContentView.swift
//  Notizapp
//
//  Created by Kevin Jordan on 08.09.24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var notes : [(title: String, text:String)]=[]
    @State private var trashcan : [(title: String, text:String)]=[]
    @State private var newNoteTitle : String = ""
    @State private var newNoteText: String = ""
    @State private var errorMessage: String = ""
    var body:some View{
        VStack{
            TextField("Notiz Titel", text:$newNoteTitle)
                .padding()
                .background(Color.gray.opacity(0.2))
        }
    }
}

struct ContentView_Previews: PreviewProvider{
    static var previews: some View{ContentView()}
}
