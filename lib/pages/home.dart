import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wood_craft_finder/pages/login.dart';
import 'package:wood_craft_finder/widgets/feeds_widget.dart';
import '../actions/data_fetcher_action.dart';
import './post_product_screen.dart';
import './feedback.dart';
import './updateProfile.dart';

class Home extends StatefulWidget {
  final bool isSeller;
  final String token;

  const Home({Key? key, required this.isSeller, required this.token})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController _textEditingController;
  late Future<List<dynamic>> _dataFuture;
  late Future<Map<String, dynamic>> _userProfileFuture;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _dataFuture = DataFetcher().fetchData();
    _userProfileFuture = DataFetcher().fetchUserProfile(widget.token);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WOOD CRAFT FINDER',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: FutureBuilder<Map<String, dynamic>>(
        future: _userProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Drawer(
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Drawer(
              child: Center(
                  child: Text('Error loading profile: ${snapshot.error}')),
            );
          } else if (!snapshot.hasData) {
            return const Drawer(
              child: Center(child: Text('No profile data available')),
            );
          } else {
            final userProfile = snapshot.data!;
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(userProfile['first_name'] ?? 'N/A'),
                    accountEmail: Text(userProfile['email'] ?? 'N/A'),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(
                          userProfile['profilePicture'] ??
                              'https://example.com/default-profile.jpg'),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  if (widget.isSeller) ...[
                    ListTile(
                      leading: const Icon(Icons.sell_outlined),
                      title: const Text('Sell'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostProductForm(
                                      token: widget.token,
                                    )));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.account_circle),
                      title: const Text('Profile'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileUpdateForm(
                                      token: widget.token,
                                    )));
                      },
                    ),
                  ],
                  ListTile(
                    leading: const Icon(Icons.feedback),
                    title: const Text('Feedback'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FeedbackForm(
                                    token: widget.token,
                                  )));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {
                      Navigator.pop(context);
                      // Add logout logic here if needed
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.remove('token');
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const LoginForm()),
                        );
                      });
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
      body: SizedBox(
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<List<dynamic>>(
                future: _dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error fetching data: ${snapshot.error}'),
                    );
                  } else {
                    return FeedsWidget(data: snapshot.data!);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[50],
    );
  }
}
