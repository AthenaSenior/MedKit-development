import 'package:flutter/material.dart';

class DrugDetail extends StatelessWidget {
  DrugDetail({super.key, required this.drugName, required this.drugPicture, required this.drugLongDesc});

  final String drugName, drugPicture, drugLongDesc;

  String backgroundImage = "", title= "";

  void createUIWithHour()
  {
    var dt = DateTime.now().hour;
    if(dt >= 6 && dt < 12)
    {
      backgroundImage = "assets/images/morning.jpg";
    }
    else if (dt >= 12 && dt < 18)
    {
      backgroundImage = "assets/images/afternoon.jpg";
    }
    else if (dt >= 18 && dt < 21)
    {
      backgroundImage = "assets/images/evening.jpg";
    }
    else if (dt >= 21 || dt < 6)
    {
      backgroundImage = "assets/images/night.jpg";
    }
  }

  @override
  Widget build(BuildContext context) {
    createUIWithHour();
    var size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              )),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            SizedBox(
                height: size.height * .03
            ),
            Row(
              children:[
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.black,
                    size: 26,
                  ),
                ),
                const Text(
                    "Back",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 26)
                ),
              ]
            ),
            SizedBox(
                height: size.height * .01
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: size.height * .87,
                  width: size.width * .95,
                  decoration: BoxDecoration(
                    color: Colors.white70.withOpacity(.75),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child:
                    Column(
                        children: [
                          Text(
                              drugName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 30)
                          ),
                          SizedBox(
                              height: size.height * .01
                          ),
                          Image.network(drugPicture,
                              width: size.width * .55, height: size.height * .25),
                        SizedBox(
                          height: size.height * .52,
                          child:
                          SingleChildScrollView(
                            child:
                            Text(
                                drugLongDesc,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15)
                            ),
                          ),
                        ),
                        ]
                    ),
                  ),
                ),
              ),
            ),
          ],
          ),
        ),
    );
  }
}
