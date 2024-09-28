import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blog/models/blog.dart';
class AddBlogScreen extends StatefulWidget {
  const AddBlogScreen({super.key});

  @override
  State<AddBlogScreen> createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  final title = TextEditingController();
  final desc = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(('Add blog')),
        actions: [
          IconButton(onPressed: (){
           if(formkey.currentState!.validate()){
             setState(() {
               loading =true;
             });
             addBlog();
           }
          },
          icon: const Icon(Icons.done),)
        ],
      ),
      body: loading? const Center(child: CircularProgressIndicator(),)
          : Form(
        key: formkey,
        child: ListView(padding: const EdgeInsets.all(15),
          children: [
            TextFormField(
              controller: title,
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder()
              ),
              validator: (value){
                if(value!.isEmpty)
                  {
                    return 'Please enter title';
                  }
                return null;
              },
            ),
            const SizedBox(height: 15,),
            TextFormField(
              controller: desc,
              maxLines: 10,
              decoration: InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder()
              ),
              validator: (value){
                if(value!.isEmpty)
                {
                  return 'Please enter description';
                }
                return null;
              },
            )
          ],
        ),
      ),
    );
  }
  addBlog() async{
    final db = FirebaseFirestore.instance.collection('blogs');
    final user = FirebaseAuth.instance.currentUser!;
    final id =DateTime.now().microsecondsSinceEpoch.toString();

    Blog blog = Blog(
        id: id,
        userId: user.uid,
        title: title.text,
        desc: desc.text,
        createdAt: DateTime.now()
    );
    try {
      await db.doc(id).set(blog.toMap());
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    }on FirebaseAuthException catch(e){
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? ''),
        ));
    }
  }
}
