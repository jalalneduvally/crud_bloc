import 'package:crud_bloc/features/category/bloc/category_bloc.dart';
import 'package:crud_bloc/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/common/firebase_constants.dart';
import 'dart:io';


class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController categoryController=TextEditingController();
  bool isActive=true;

  @override
  void dispose() {
    super.dispose();
    categoryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w=MediaQuery.of(context).size.width;
    var h=MediaQuery.of(context).size.height;

   return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        title: const Text("Add Catalog"),
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(w*0.03),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: categoryController,
                validator: (value) {
                  var val = value ?? '';
                  if (val.isEmpty) {
                    return 'Please enter Name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    constraints: BoxConstraints(maxHeight: h*0.07),
                    labelText: "Catalog Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w*0.02),
                    )
                ),
              ),
              SizedBox(height: h*0.02,),
              const Text("Is Active ?",
                style: TextStyle(
                    color: Colors.blue
                ),),
              Row(
                children: [
                  Radio(value: true,
                    activeColor:Colors.blue ,
                    groupValue: isActive,
                    onChanged: (value) {
                     setState(() {
                       isActive=! isActive;
                     });
                    },),
                  const Text("Yes"),
                  SizedBox(width: w*0.02,),
                  Radio(value: false,
                    activeColor:Colors.blue ,
                    groupValue:isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive=! isActive;
                      });
                      },),
                  const Text("No"),
                  SizedBox(width: w*0.02,),
                ],
              ),
              SizedBox(height: h*0.02,),
              ElevatedButton(
                onPressed: ()  {
                  if(_formKey.currentState!.validate()){
                    BlocProvider.of<CategoryBloc>(context).add(
                        AddCategoryEvent(context: context, name: categoryController.text.trim(),
                            active: isActive));
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(w, h*0.06),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Add Catalog",
                    style: TextStyle(color: Colors.white,
                        fontSize: w*0.045,
                        fontWeight: FontWeight.w500)),
              ),
              BlocBuilder<CategoryBloc,CategoryState>(
                builder: (context, state) {
                  if(state is CategoryInitial ||state is CategoryLoadingState){
                    return const Center(child: CircularProgressIndicator(),);
                  }else if(state is CategoryError){
                    String error=state.error;
                    return Center(child: Text(error),);
                  }else if(state is ReadCategoryState) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        CategoryModel category=state.categories[index];
                        return ListTile(
                          title: Text(category.name,
                          style: TextStyle(
                            fontSize: w*0.04,
                            fontWeight: FontWeight.w700
                          ),),
                          trailing: InkWell(
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
                                              var a =category.copyWith( delete: true );
                                              category.reference.update(a.toJson());
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
                                size: w * 0.06,
                                color: Colors.redAccent,
                              )),
                        );
                      },);
                  }else{
                    print(state.runtimeType);
                    return const Text(" No state}");
                  }
              },)
            ],
          ),
        ),
      ),
    );
  }
}
