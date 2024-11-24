import 'package:flutter/cupertino.dart';
import 'package:template/shared/resources.dart';

class BackgroundPage extends StatelessWidget {
  final Widget child;
  final bool whiteBG;
  const BackgroundPage({Key? key, required this.child, this.whiteBG = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Image.asset(
            whiteBG ? Resources.bg1 : Resources.bg,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          child
        ],
      ),
    );
  }
}
