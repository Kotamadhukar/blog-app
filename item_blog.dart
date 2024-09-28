import 'package:blog/models/blog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class ItemBlog extends StatelessWidget {
  final Blog blog;
  const ItemBlog({super.key,required this.blog});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(blog.title,style: Theme.of(context).textTheme.titleLarge),
          Text(DateFormat('dd/MM/yyyy hh:mm a').format(blog.createdAt)),
          const SizedBox(height: 10),
          Text(blog.desc)
        ],
      ),
    );
  }
}

