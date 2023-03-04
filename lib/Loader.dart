import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
        body: Center(
          child:
               Text("We're getting things ready..",
              style: TextStyle(fontSize: 18, color: Colors.white)
               ),
                //Image.network("https://www.superiorlawncareusa.com/wp-content/uploads/2020/05/loading-gif-png-5.gif")
          )
    );
  }
}