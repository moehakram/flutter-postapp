import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:posts_app_241117/resource/remote_resource.dart';
import '../cubit/post_cubit.dart';
import '../model/post.dart';

class PostFormScreen extends StatefulWidget {
  final Post? post;

  const PostFormScreen({Key? key, this.post}) : super(key: key);

  @override
  _PostFormScreenState createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      _titleController.text = widget.post!.title ?? '';
      _contentController.text = widget.post!.content ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post == null ? 'Create Post' : 'Edit Post'),
      ),
      body: BlocListener<PostCubit, PostState>(
        listener: (context, state) {
          if (state is PostActionSuccess) {
            Navigator.pop(context);
          } else if (state is PostError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(labelText: 'Content'),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter content';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _imageFile != null
                          ? Image.file(
                              _imageFile!,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : widget.post?.image != null
                          ? Image.network(
                              '${RemoteResource.baseStorage}/${widget.post!.image}',
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 100,
                              color: Colors.grey[300],
                              child: Icon(Icons.image, size: 50),
                            ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Pick Image'),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is PostActionLoading
                          ? null
                          : _submitForm,
                      child: state is PostActionLoading
                          ? CircularProgressIndicator()
                          : Text(widget.post == null ? 'Create' : 'Update'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (widget.post == null) {
        context.read<PostCubit>().createPost(
          title: _titleController.text,
          content: _contentController.text,
          imageFile: _imageFile,
        );
      } else {
        // Check if post ID is not null before updating
        if (widget.post!.slug != null) {
          context.read<PostCubit>().updatePost(
            slug: widget.post!.slug!,
            title: _titleController.text,
            content: _contentController.text,
            imageFile: _imageFile,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
