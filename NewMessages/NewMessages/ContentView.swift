import SwiftUI
import CoreData

struct Contact: Identifiable {
    let id = UUID()
    var name: String
    var phoneNumber: String
    var color: Color = .blue //default color 
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var contacts: [Contact] = [Contact(name: "Jonathan Fang", phoneNumber: "123-456-7890")]
    @State private var isAddingContact = false
    @State private var newContactName = ""
    @State private var newContactPhone = ""
    @State private var firstInitial = ""
    @State private var lastInitial = ""
    @State private var newNote = ""
    @State private var editMode: EditMode = .inactive

    var body: some View {
        NavigationView {
            List {
                ForEach(contacts) { contact in
                    NavigationLink {
                        Text("Contact: \(contact.name)")
                    } label: {
                        HStack {
                            IntialsCircle(intials: getInitials(from: contact.name  ))
                            if editMode == .active {
                                TextField("Name", text: Binding(
                                    get: { contact.name },
                                    set: { newValue in
                                        if let index = contacts.firstIndex(where: { $0.id == contact.id }) {
                                            contacts[index].name = newValue
                                        }
                                    }
                                ))
                            } else {
                                Text(contact.name)
                            }
                        }
                        
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Messages")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: { isAddingContact = true }) {
                        Label("Add Contact", systemImage: "plus")
                    }
                }
            }
            .environment(\.editMode, $editMode)
            Text("Select a contact")
        }
        .sheet(isPresented: $isAddingContact) {
            AddContactView(isPresented: $isAddingContact, name: $newContactName, phone: $newContactPhone, note: $newNote, onSave: addContact)
        }
    }

    private func addContact() {
        let newContact = Contact(name: newContactName, phoneNumber: newContactPhone)
        contacts.append(newContact)
        newContactName = ""
        newContactPhone = ""
        isAddingContact = false
    }

    private func deleteItems(offsets: IndexSet) {
        contacts.remove(atOffsets: offsets)
    }
    
    func getInitials(from name: String) -> String {
        let components = name.components(separatedBy: " ")
        let firstInitial = components.first?.prefix(1) ?? ""
        let lastInitial = components.count > 1 ? components.last?.prefix(1) ?? "" : ""
        return (firstInitial + lastInitial).uppercased()
    }
}

struct AddContactView: View {
    @Binding var isPresented: Bool
    @Binding var name: String
    @Binding var phone: String
    @Binding var note: String
    var onSave: () -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Phone Number", text: $phone)
                TextField("Note", text: $note )
            }
            .navigationTitle("Add Contact")
            .navigationBarItems(
                leading: Button("Cancel") { isPresented = false },
                trailing: Button("Save") {
                    onSave()
                }
            )
        }
    }
}

struct IntialsCircle: View {
    let intials: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 40, height: 40)
            Text(intials)
                .foregroundColor(.white)
                .font(.system(size:16, weight: .bold))
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
