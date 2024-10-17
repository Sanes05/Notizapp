//
//  ContentView.swift
//  Notizapp
//
//  Created by Kevin Jordan on 08.09.24.
//

import SwiftUI
import SwiftData

// Struktur für Notizen, die Identifiable und Codable implementiert
struct Note: Identifiable, Codable {
    var id = UUID()
    var title: String
    var text: String
}

struct ContentView: View {
    @State private var notes: [Note] = []
    @State private var trashcan: [Note] = []
    @State private var newNoteTitle: String = ""
    @State private var newNoteText: String = ""
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Notiz Titel", text: $newNoteTitle)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                TextField("Notiz Text", text: $newNoteText)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                Button(action: addNote) {
                    Text("Notiz Hinzufügen")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Text(errorMessage).foregroundColor(.red)

                Spacer()

                // NavigationLink to the Notes page
                NavigationLink(destination: NotesView(notes: $notes, deleteNote: deleteNote)) {
                    Text("Alle Notizen anzeigen")
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                }

                // NavigationLink to the trashcan page
                NavigationLink(destination: TrashcanView(trashcan: $trashcan, restoreNote: restoreNote, deleteTrashNote: deleteTrashNote)) {
                    Text("Zum Papierkorb")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Notizen App")
            .onAppear(perform: loadData) // Daten laden, wenn die Ansicht erscheint
        }
    }

    func addNote() {
        if inputValidate() {
            let newNote = Note(title: newNoteTitle, text: newNoteText)
            notes.append(newNote)
            saveData() // Daten speichern
            newNoteTitle = ""
            newNoteText = ""
            errorMessage = ""
        }
    }

    func deleteNote(_ note: Note) {
        trashcan.append(note)
        notes.removeAll { $0.id == note.id }
        saveData() // Daten speichern
    }

    func inputValidate() -> Bool {
        if newNoteTitle.isEmpty {
            errorMessage = "Es fehlt ein Titel"
            return false
        } else if newNoteText.isEmpty {
            errorMessage = "Der Text fehlt"
            return false
        }
        return true
    }

    // Speichert die Notizen und den Papierkorb in UserDefaults
    func saveData() {
        if let notesData = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(notesData, forKey: "notes")
        }
        if let trashData = try? JSONEncoder().encode(trashcan) {
            UserDefaults.standard.set(trashData, forKey: "trashcan")
        }
    }

    // Lädt die gespeicherten Notizen und den Papierkorb aus UserDefaults
    func loadData() {
        if let notesData = UserDefaults.standard.data(forKey: "notes"),
           let savedNotes = try? JSONDecoder().decode([Note].self, from: notesData) {
            notes = savedNotes
        }

        if let trashData = UserDefaults.standard.data(forKey: "trashcan"),
           let savedTrashcan = try? JSONDecoder().decode([Note].self, from: trashData) {
            trashcan = savedTrashcan
        }
    }

    // Funktionen, die in der TrashcanView verwendet werden
    func restoreNote(_ note: Note) {
        notes.append(note)
        trashcan.removeAll { $0.id == note.id }
        saveData() // Daten speichern
    }

    func deleteTrashNote(_ note: Note) {
        trashcan.removeAll { $0.id == note.id }
        saveData() // Daten speichern
    }
}

// Separate View für den Papierkorb
struct TrashcanView: View {
    @Binding var trashcan: [Note]
    var restoreNote: (Note) -> Void
    var deleteTrashNote: (Note) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            if trashcan.isEmpty {
                Text("Papierkorb ist leer.")
                    .font(.headline)
                    .padding()
            } else {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(trashcan) { note in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(note.title).font(.headline)
                                Text(note.text)
                                HStack {
                                    Button(action: {
                                        restoreNote(note)
                                    }) {
                                        Text("Wiederherstellen").foregroundColor(.green)
                                    }
                                    Button(action: {
                                        deleteTrashNote(note)
                                    }) {
                                        Text("Entfernen").foregroundColor(.red)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Papierkorb")
    }
}

// Separate View für Notizen
struct NotesView: View {
    @Binding var notes: [Note]
    var deleteNote: (Note) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            if notes.isEmpty {
                Text("Keine Notizen vorhanden.")
                    .font(.headline)
                    .padding()
            } else {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(notes) { note in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(note.title).font(.headline)
                                Text(note.text)
                                HStack {
                                    Button(action: {
                                        deleteNote(note)
                                    }) {
                                        Text("Notiz Löschen").foregroundColor(.red)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.yellow.opacity(0.3))
                            .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Alle Notizen")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
