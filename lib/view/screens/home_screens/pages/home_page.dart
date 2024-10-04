import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailer_app/view/screens/home_screens/ar_Measurement_screen.dart';
import 'package:tailer_app/view/screens/home_screens/ar_try_screen.dart';
import 'package:tailer_app/view/screens/home_screens/categorization_screen.dart';
import 'package:tailer_app/view/screens/home_screens/category_collection.dart';
import 'package:tailer_app/view/screens/home_screens/designer_collection.dart';
import 'package:tailer_app/view/screens/home_screens/pages/cart_page.dart';
import 'package:tailer_app/view/screens/home_screens/pages/profile_page.dart';
import 'package:tailer_app/view/screens/home_screens/product_list_screen.dart';
import 'package:tailer_app/view/auth/login_screen.dart';

// Define the data lists inside the file
List<String> categories = ['Men', 'Women', 'Kids'];
List<Category> categoriesList = [
  Category(price: "3000", image: "assets/cate1.png", title: "T-Shirt"),
  Category(price: "3000", image: "assets/cate2.png", title: "Kids Suits"),
  Category(price: "3000", image: "assets/cate3.png", title: "Kameez"),
];
List<Discover> discoverList = [
  Discover(image: "assets/disc1.png", title: "Customize Dress"),
  Discover(image: "assets/disc2.png", title: "Designer Collection"),
  Discover(image: "assets/disc3.png", title: "AR TRY"),
  Discover(image: "assets/disc4.png", title: "AR Measurement"),
];

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text("Dashboard"),
      ),
      drawer: buildDrawer(context),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xffd9d9d9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60),
              topRight: Radius.circular(60), // Adjusted for symmetry
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi",
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "Khalid",
                  style: TextStyle(
                    fontSize: 26,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16), // Increased spacing for better UI
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: Icon(Icons.search, color: Colors.white),
                    fillColor: Theme.of(context).primaryColor,
                    filled: true,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to a full categories page if available
                        // Get.to(() => CategorizationScreen()); // Adjust if needed
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cate = categories[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => CategoryCollection(title: cate));
                          },
                          child: Center(
                            child: Text(
                              cate,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoriesList.length,
                    itemBuilder: (context, index) {
                      final cate = categoriesList[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to ProductListScreen with the selected category
                          Get.to(() => ProductListScreen(category: cate.title));
                        },
                        child: categoryTile(
                          title: cate.title,
                          image: cate.image,
                          price: cate.price,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Discover",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: discoverList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 150,
                  ),
                  itemBuilder: (context, index) {
                    final disc = discoverList[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate based on the discover item clicked
                        switch (index) {
                          case 0:
                            Get.to(() => CustomizationScreen());
                            break;
                          case 1:
                            Get.to(() => DesignerCollection());
                            break;
                          case 2:
                            Get.to(() => PoseDetectorView());
                            break;
                          case 3:
                            Get.to(() => AddMeasurementScreen(
                                  imageUrl: 'assets/shirt1.png',
                                  price: '50 USD', // Provide a valid price
                                  title: 'Shirt Measurement',
                                ));
                            break;
                        }
                      },
                      child: discoverTile(
                        image: disc.image,
                        title: disc.title,
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade400,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              SizedBox(width: 10),
                              Text("Ali"),
                            ],
                          ),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 15,
                              );
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "The Tailoring App offers an impressively intuitive interface that makes custom clothing design accessible for everyone. Its precise measurement tools and vast fabric library empower users to create bespoke garments effortlessly.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20), // Ensure spacing after review
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xff2a87ef)),
            accountName: Text("Khalid"),
            accountEmail: Text("kalidawan@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                "SA",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Cart'),
            onTap: () {
              Get.to(() => CartScreen()); // Navigate to CartPage
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Get.to(() => ProfilePage()); // Navigate to ProfilePage
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Handle logout functionality
              Get.offAll(() => LoginScreen()); // Navigate to LoginPage
            },
          ),
        ],
      ),
    );
  }

  Widget discoverTile({
    required String image,
    required String title,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xff2a87ef),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0xff8256ea),
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryTile({
    required String title,
    required String image,
    required String price,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 130,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xff2a87ef),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "PKR",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      price,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
                Image.asset(image),
              ],
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Color(0xff8256ea),
            ),
          ),
        ],
      ),
    );
  }
}

// Top-level definitions for Discover and Category classes
class Discover {
  final String title;
  final String image;
  Discover({required this.title, required this.image});
}

class Category {
  final String price;
  final String image;
  final String title;
  Category({required this.price, required this.image, required this.title});
}
