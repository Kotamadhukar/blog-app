import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/blog.dart';
import '../auth/home/widgets/item_blog.dart';

class MyBlogsScreen extends StatefulWidget {
  const MyBlogsScreen({super.key});

  @override
  State<MyBlogsScreen> createState() => _MyBlogsScreenState();
}

class _MyBlogsScreenState extends State<MyBlogsScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Blogs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('blogs')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading blogs'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No blogs found'));
          }

          final data = snapshot.data!.docs;
          List<Blog> blogs = data
              .map((e) => Blog.fromMap(e.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              Blog blog = blogs[index];
              return ListTile(
                title: ItemBlog(blog: blog),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(context, blog, data[index].id),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Method to show confirmation dialog and delete blog if confirmed
  void _confirmDelete(BuildContext context, Blog blog, String blogId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Blog"),
          content: const Text("Are you sure you want to delete this blog?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _deleteBlog(blogId); // Call the method to delete the blog
              },
            ),
          ],
        );
      },
    );
  }

  // Method to delete the blog from Firestore
  Future<void> _deleteBlog(String blogId) async {
    try {
      await FirebaseFirestore.instance.collection('blogs').doc(blogId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Blog deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting blog: $e')),
      );
    }
  }
}