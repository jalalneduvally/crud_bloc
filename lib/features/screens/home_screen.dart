// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
//
// class MainPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Users'),
//       ),
//       body: BlocBuilder<UserBloc, UserState>(
//         builder: (context, state) {
//           if (state is UsersLoaded) {
//             return ListView.builder(
//               itemCount: state.users.length,
//               itemBuilder: (context, index) {
//                 final user = state.users[index];
//                 return ListTile(
//                   title: Text(user.name),
//                   trailing: IconButton(
//                     icon: Icon(Icons.delete),
//                     onPressed: () {
//                       BlocProvider.of<UserBloc>(context).add(DeleteUser(user.id));
//                     },
//                   ),
//                 );
//               },
//             );
//           } else if (state is UsersError) {
//             return Center(child: Text(state.message));
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showAddUserDialog(context);
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
//
//   void _showAddUserDialog(BuildContext context) {
//     TextEditingController nameController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Add User'),
//           content: TextField(
//             controller: nameController,
//             decoration: InputDecoration(labelText: 'Name'),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 String name = nameController.text.trim();
//                 if (name.isNotEmpty) {
//                   BlocProvider.of<UserBloc>(context).add(AddUser(User(id: '', name: name)));
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'package:crud_bloc/features/products/bloc/product_bloc.dart';
import 'package:crud_bloc/features/products/screen/product_add_screen.dart';
import 'package:crud_bloc/features/products/screen/update_product.dart';
import 'package:crud_bloc/features/widget%20bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import '../category/screen/category_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController=TextEditingController();
  
  @override
  void initState() {
    context.read<ProductBloc>().add(FetchProducts(null));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w=MediaQuery.of(context).size.width;
    var h=MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home"),
      ),
      floatingActionButton: SpeedDial(
        closedForegroundColor: Colors.black,
        openForegroundColor: Colors.white,
        closedBackgroundColor: Colors.white,
        openBackgroundColor: Colors.black,
        // labelsStyle: /* Your label TextStyle goes here */,
        labelsBackgroundColor: Colors.white,
        // controller: /* Your custom animation controller goes here */,
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            child: const Icon(Icons.widgets_outlined),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            label: "Add Product",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen(),));
            },
            closeSpeedDialOnPressed: true,
          ),
          SpeedDialChild(
            child: const Icon(Icons.category),
            foregroundColor: Colors.white,
            backgroundColor: Colors.indigo,
            label: 'Category',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CatalogPage(),));
            },
          ),
          //  Your other SpeedDialChildren go here.
        ],
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: h * 0.05,
              width: w,
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  // BlocProvider.of<SearchBloc>(context).add(SearchChanged(value));
                  context.read<ProductBloc>().add(FetchProducts(value));
                },
                // obscureText: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: w * 0.02, vertical: w * 0.02),
                  hintText: 'Search Product Name',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF1F4F8),
                  prefixIcon: const Icon(
                    Icons.search_outlined,
                    color: Color(0xFF57636C),
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear,color: Colors.green,),
                    onPressed: () {
                      searchController.clear();
                      context.read<ProductBloc>().add(FetchProducts(null));
                      // BlocProvider.of<SearchBloc>(context).add(SearchChanged(null));
                    },
                  )
                      : const Icon(
                    Icons.shop,
                    color: Colors.greenAccent,
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xFF1D2429),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(height: h*0.02,),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if(state is ProductInitial ||state is ProductLoadingState){
                  return const Center(child: CircularProgressIndicator(),);
                }else if(state is ProductsError){
                  String error=state.error;
                  return Center(child: Text(error),);
                }else if(state is ReadProductsState){
                  return RefreshIndicator(
                      onRefresh: ()async {
                        context.read<ProductBloc>().add(FetchProducts(null));
                      },
                      child:
                      state.products.isEmpty? Center(child: Text("No Data..",
                        style: TextStyle(fontSize: w*0.06,fontWeight: FontWeight.bold),),):
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.products.length,
                        itemBuilder: (BuildContext context, int index) {
                          final product = state.products[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: w * 0.4,
                                    width: w * 0.3,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(w * 0.03),
                                        image: DecorationImage(
                                            image:
                                            NetworkImage(product.image),
                                            fit: BoxFit.cover)),
                                  ),
                                  Positioned(
                                    bottom: w * 0.025,
                                    child: Container(
                                      height: w * 0.07,
                                      width: w * 0.3,
                                      color: Colors.white60,
                                      child: Center(
                                          child: Text(
                                            product.available
                                                ? "Available"
                                                : "Not Available",
                                            style: TextStyle(
                                                fontSize: w * 0.04,
                                                fontWeight: FontWeight.w600),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text("Name: ${product.productName}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: w * 0.04)),
                                  SizedBox(
                                    height: w * 0.03,
                                  ),
                                  Text("Mrp: ${product.mrp.toString()}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: w * 0.04)),
                                  SizedBox(
                                    height: w * 0.03,
                                  ),
                                  // Text(
                                  //     "description: ${product.details.toString()}",
                                  //     style: TextStyle(
                                  //         fontWeight: FontWeight.w600,
                                  //         fontSize: w * 0.04)),
                                  Text(
                                      "Stock: ${product.stock.toString()}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: w * 0.04)),
                                  SizedBox(
                                    height: w * 0.03,
                                  ),
                                  Text(
                                      "Category: ${product.category.toString()}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: w * 0.04)),
                                ],
                              ),
                              InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Are You Sure to Update..?"),
                                          content: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);

                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                        builder: (context) => UpdateProductScreen(productList: product),
                                                      ));
                                                },
                                                child: Container(
                                                  height: w * 0.1,
                                                  width: w * 0.15,
                                                  decoration: BoxDecoration(
                                                    color: Colors.purple,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        w * 0.03),
                                                  ),
                                                  child: const Center(
                                                    child: Text("Yes",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  height: w * 0.1,
                                                  width: w * 0.15,
                                                  decoration: BoxDecoration(
                                                    color: Colors.purple,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        w * 0.03),
                                                  ),
                                                  child: const Center(
                                                    child: Text("No",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    size: w * 0.08,
                                    color: Colors.blueAccent,
                                  )),
                              InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Are You Sure to delete..?"),
                                          content: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  var a =product.copyWith( delete: true );
                                                  product.reference.update(a.toJson());
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  height: w * 0.1,
                                                  width: w * 0.15,
                                                  decoration: BoxDecoration(
                                                    color: Colors.purple,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        w * 0.03),
                                                  ),
                                                  child: const Center(
                                                    child: Text("Yes",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  height: w * 0.1,
                                                  width: w * 0.15,
                                                  decoration: BoxDecoration(
                                                    color: Colors.purple,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        w * 0.03),
                                                  ),
                                                  child: const Center(
                                                    child: Text("No",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    size: w * 0.08,
                                    color: Colors.redAccent,
                                  )),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: w * 0.03,
                          );
                        },
                      )
                  );
             } else {
                  print("state.....");
                  print(state.runtimeType);
               return const Text(" No state}");
             }
              },
            ),
          ],
        ),
      ),
    );
  }
}
