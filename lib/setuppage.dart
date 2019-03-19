import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_permissions/simple_permissions.dart';

class SetupPage extends StatefulWidget {
  SetupPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  static List<Widget> setupPages = [SetupOne(), SetupTwo()];
  int finalPageNum = setupPages.length - 1;

  final _controller = PageController(initialPage: 0);

  Widget _buildPageView() {
    return PageView.builder(
      itemBuilder: (context, position) => setupPages[position],
      itemCount: setupPages.length,
      controller: _controller,
    );
  }

  void nextPage() {
    _controller.nextPage(duration: kTabScrollDuration, curve: Curves.ease);
  }

  Future checkPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // TODO: check if setup process is complete
    if (_controller.page == finalPageNum) {
      prefs.setBool('setupComplete', true);
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageView(),
      floatingActionButton: FancyButton(
        onPressed: () => checkPage(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class FancyButton extends StatelessWidget {
  final GestureTapCallback onPressed;

  FancyButton({@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Text(
        "Next",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: onPressed,
      // fillColor: Colors.teal,
      // splashColor: Colors.tealAccent,
      // shape: const StadiumBorder(),
    );
  }
}

class SetupOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Welcome to Insectify!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                ),
                // style: Theme.of(context).textTheme.display1,
              ),
              SizedBox(
                height: 10,
              ),
//              Text(
//                "Thank you for choosing this app.",
//                style: TextStyle(fontSize: 15, color: Colors.white),
//              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetupTwo extends StatefulWidget {
  @override
  _SetupTwoState createState() => _SetupTwoState();
}

class _SetupTwoState extends State<SetupTwo> {
  List perms = [
    Permission.ReadExternalStorage,
    Permission.Camera,
    Permission.WriteExternalStorage
  ];

  @override
  void initState() {
    super.initState();
    requestPermission(perms);
  }

  requestPermission(List perms) async {
    for (int i = 0; i < perms.length; i++) {
      final res = await SimplePermissions.requestPermission(perms[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Before we start...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                ),
                // style: Theme.of(context).textTheme.display1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
