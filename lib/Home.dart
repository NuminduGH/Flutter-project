import 'package:flutter/material.dart';
import 'db.dart';
import 'Contact.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();


}
class _HomepageState extends State<Homepage> {

  // Function to delete contacts
  Future<void> deleteContact(int id) async {
    await DatabaseHelper.instance.deleteContact(id);
    // Remove the contact from the UI list
    setState(() {
      contacts.removeWhere((contact) => contact.id == id);
    });
  }

  Future<void> fetchContacts() async {
    List<Map<String, dynamic>> fetchedContacts = await DatabaseHelper.instance.getContacts();
    setState(() {
      contacts = fetchedContacts.map((contactMap) {
        return Contact(
          id: contactMap['id'],
          name: contactMap['name'],
          contact: contactMap['contact'],
          email: contactMap['email'],
        );
      }).toList();
    });
  }
  @override
  void initState() {
    super.initState();
    fetchContacts(); // Fetch contacts when the widget initializes
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  List<Contact> contacts = List.empty(growable: true);

  int selectedIndex = -1;



  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(centerTitle: true, title: const Text('Contact list'),),

    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children:  [
           SizedBox(height: 10),
           TextField(
             controller: nameController,
            decoration: const InputDecoration(
                hintText:'Contact name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10)))),),
          SizedBox(height: 10),
          TextField(
            controller: contactController,
            keyboardType: TextInputType.number,
            maxLength: 10,
          decoration: const InputDecoration(
              hintText:'Contact number',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(10)))),),
          SizedBox(height: 10),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                hintText:'email',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10)))),),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                String name = nameController.text.trim();
                String contact = contactController.text.trim();
                String email = emailController.text.trim();
                if(name.isNotEmpty && contact.isNotEmpty && email.isNotEmpty) {
                  Contact newContact = Contact(
                      name: name, contact: contact, email: email);
                  int insertedId = await DatabaseHelper.instance.insertContact(
                      newContact);
                  if (insertedId != -1) {
                    setState(() {
                      nameController.text = '';
                      contactController.text = '';
                      emailController.text = '';
                      contacts.add(newContact);
                    });
                  }
                }
              } , child:Text('Save'),),
              ElevatedButton(
                onPressed: (){
                String name = nameController.text.trim();
                String contact = contactController.text.trim();
                String email = emailController.text.trim();
                if(name.isNotEmpty && contact.isNotEmpty && email.isNotEmpty){
                  setState(() {
                    nameController.text = '';
                    contactController.text = '';
                    emailController.text = '';
                    contacts[selectedIndex].name = name;
                    contacts[selectedIndex].contact = contact;
                    contacts[selectedIndex].email = email;
                    selectedIndex = -1;
                  });
                }


              } , child:Text('Update'),),
            ],
          ),
          contacts.isEmpty ? const Text('No contacts', style: TextStyle(fontSize: 20),):
          Expanded(
             child: ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) => getRow(index),)
             )
          ],
        ),
      ),
    );
  }
  Widget getRow(int index){
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: index%2==0 ? Colors.purple : Colors.blue,
          foregroundColor: Colors.white,
          child: Text(contacts[index].name[0], style: const TextStyle(fontWeight: FontWeight.bold),),
        ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contacts[index].name, style: const TextStyle(fontWeight: FontWeight.bold),),
          Text(contacts[index].contact),
          Text(contacts[index].email),
          ],
        ),

        trailing: SizedBox(
            width: 70,
            child: Row(
               children: [
                 InkWell(
                   onTap: () {
                     nameController.text = contacts[index].name;
                     contactController.text = contacts[index].contact;
                     emailController.text = contacts[index].email;
                     setState(() {
                       selectedIndex = index;
                     });


                   },


                child: const Icon(Icons.edit),),
                InkWell(
                  onTap: (() {
                    // Delete the contact from the database and UI and assuming id cannot be null
                    deleteContact(contacts[index].id!);
                    setState(() {
                      contacts.removeAt(index);
                    });

                  }),
                child: const Icon(Icons.delete),),
               ],
            ),
        ),
      )
    );
  }
}



