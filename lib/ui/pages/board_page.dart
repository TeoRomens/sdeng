import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sdeng/cubits/board_cubit.dart';
import 'package:sdeng/cubits/teams_cubit.dart';
import 'package:sdeng/ui/components/button.dart';
import 'package:sdeng/ui/components/card.dart';
import 'package:sdeng/utils/constants.dart';
import 'package:sdeng/utils/formatter.dart';

class BoardPage extends StatelessWidget {
  BoardPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) {
        BlocProvider.of<BoardCubit>(context).getAllPosts();
        return BoardPage();
      },
    );
  }

  final _formKey = GlobalKey<FormState>();

  void _newPostModal(BuildContext context) {
    final authorController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder:(dialogContext) => ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.85,
            maxWidth: 400
        ),
        child: Material(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spacer16,
                const Text('New Post', style: TextStyle(
                    inherit: false,
                    fontSize: 26,
                    color: Colors.black
                ),),
                spacer16,
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Author',
                    style: TextStyle(
                      color: Color(0xff686f75),
                      fontSize: 16,
                    ),
                  ),
                ),
                TextFormField(
                  controller: authorController,
                  decoration: const InputDecoration(
                    label: Text('Mario Rossi'),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                spacer16,
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Content',
                    style: TextStyle(
                      color: Color(0xff686f75),
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10)
                    ),
                    textAlignVertical: TextAlignVertical.top,
                    controller: contentController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                spacer16,
                spacer16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SdengDefaultButton(
                        text: 'Cancel',
                        onPressed: () {
                          Navigator.of(context).pop();
                        }
                    ),
                    const SizedBox(width: 10,),
                    SdengPrimaryButton(
                        text: 'Confirm',
                        onPressed: () async {
                          if(_formKey.currentState!.validate()) {
                            await BlocProvider.of<BoardCubit>(context).addPost(authorController.text, contentController.text);
                            Navigator.of(context).pop();
                          }
                        }
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: SvgPicture.asset('assets/logos/SDENG_logo.svg', height: 25),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacer16,
              SdengPrimaryButton(
                  text: 'New Post',
                  onPressed: () => _newPostModal(context)
              ),
              spacer16,
              const Text('Posts', style: TextStyle(
                  fontSize: 26
              ),),
              spacer16,
              BlocConsumer<BoardCubit, BoardState>(
                listener: (context, state) {
                  if (state is BoardError) {
                    context.showErrorSnackBar(message: state.error);
                  }
                },
                builder: (context, state) {
                  if (state is BoardInitial) {
                    return preloader;
                  }
                  else if (state is BoardLoaded) {
                    final posts = state.posts;
                    return Column(
                      children: [
                        ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts.values.elementAt(index);
                            return SdengCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(post!.author, style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    ),),
                                    Text(post.content, style: const TextStyle(
                                        fontSize: 16
                                    ),),
                                    Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(Formatter.dateToString(post.createdAt), style: TextStyle(
                                            color: Colors.grey.shade600
                                        ),)
                                    ),
                                  ],
                                )
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(
                              height: 20,
                            );
                          },
                        ),
                      ],
                    );
                  } else if (state is TeamsEmpty) {
                    return const Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text('Start adding your first post!'),
                          ),
                        ),
                      ],
                    );
                  }
                  throw UnimplementedError();
                },
              ),
            ],
          ),
        ),
    );
  }
}