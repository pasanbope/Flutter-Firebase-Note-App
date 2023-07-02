import 'package:flutter/material.dart';
import 'package:firebase_demo/style/app_style.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/widgets/note_card.dart';
import 'package:firebase_demo/screens/note_reader.dart';
import 'package:firebase_demo/screens/note_editor.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("FireNotes"),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your recent Notes",
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 20),


            Expanded(child:
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("notes").snapshots(),
              builder: (context, AsyncSnapshot <QuerySnapshot> snapshot){
                if (snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                  child: CircularProgressIndicator(),
                  );
                }
                if(snapshot.hasData){
                   return GridView(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                       crossAxisCount: 2),
                     children: snapshot.data!.docs.map((note) => noteCard((){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => NoteReaderScreen(note),));
    }, note)).toList(),
                   );
                }
                return Text("Ther's no Notes", style: GoogleFonts.nunito(color: Colors.white),);
                },
            )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const NoteEditorScreen()));
        },
        label:const Text("Add Note"),
        icon: const Icon(Icons.add),
    )
    );
  }
}
