import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyDataPlaceholder extends StatefulWidget {
  RefreshCallback onRefresh;

  EmptyDataPlaceholder(this.onRefresh, {Key? key}) : super(key: key);

  @override
  State<EmptyDataPlaceholder> createState() => _EmptyDataPlaceholderState();
}

class _EmptyDataPlaceholderState extends State<EmptyDataPlaceholder> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => RefreshIndicator(
            onRefresh: widget.onRefresh,
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                      minWidth: constraints.maxWidth),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset("images/data_empty.svg",
                            width: 100, height: 100),
                        SizedBox(height: 32),
                        Text("空空如也", style: TextStyle(fontSize: 24)),
                      ],
                    ),
                  ),
                ))));
  }
}
