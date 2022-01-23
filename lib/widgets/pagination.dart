import 'package:flutter/cupertino.dart';

class PaginationWidget extends StatelessWidget {
  final ScrollController scrollController;
  final void Function() onLoadMore;
  final Widget child;

  const PaginationWidget({
    Key? key,
    required this.scrollController,
    required this.onLoadMore,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          if (scrollController.position.extentAfter == 0) {
            onLoadMore();
          }
        }
        return false;
      },
      child: child,
    );
  }
}
