import 'package:crud_bloc/features/category/bloc/category_bloc.dart';
import 'package:crud_bloc/features/widget%20bloc/image_bloc.dart';
import 'package:crud_bloc/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import '../../../core/common/firebase_constants.dart';
import '../../widget bloc/widget_bloc.dart';
import '../bloc/product_bloc.dart';


class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  TextEditingController nameController= TextEditingController();
  TextEditingController mrpController= TextEditingController();
  TextEditingController detailsController= TextEditingController();
  TextEditingController stockController= TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // var file;
  // void selectImage() async {
  //   final res= await pickImage();
  //   if(res !=null){
  //     setState(() {
  //       file=File(res.path);
  //     });
  //   }
  // }

  List  category=[];
  var dropdownvalue;
  var selectUnit;
  bool toggle = false;

  @override
  void initState() {
    context.read<CategoryBloc>().add(FetchCategories());
    BlocProvider.of<DropDownBloc>(context).add(DropDownChanged(null));
    BlocProvider.of<ImagePickerBloc>(context).add(GalleryImagePickerExited());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    mrpController.dispose();
    detailsController.dispose();
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
        }, icon: const Icon(Icons.arrow_back,color: Colors.white,)),
        title: const Text("Upload Product"),
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: w*0.035,right: w*0.035),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h*0.02,),
                BlocBuilder<ImagePickerBloc, ImagePickerState>(
                  builder: (context, state) {
                    if(state.file == null){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Stack(
                              children: [
                                Container(
                                  height: h*0.1,
                                  width: w*0.25,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                    context.read<ImagePickerBloc>().add(GalleryImagePicker());
                                    },
                                    child: CircleAvatar(
                                      radius: w*0.04,
                                      backgroundColor: Colors.black54,
                                      child:  Icon(Icons.camera_alt_outlined,color: Colors.white,size: w*0.05,),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Text("Select Image*",
                          style: TextStyle(
                            color:Colors.red,
                          ),)
                        ],
                      );
                    }else{
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Stack(
                              children: [
                                Container(
                                  height: h*0.1,
                                  width: w*0.25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(image: FileImage(File(state.file!.path.toString())),fit: BoxFit.fill)
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      context.read<ImagePickerBloc>().add(GalleryImagePicker());
                                    },
                                    child: CircleAvatar(
                                      radius: w*0.04,
                                      backgroundColor: Colors.black54,
                                      child:  Icon(Icons.camera_alt_outlined,color: Colors.white,size: w*0.05,),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Text("Select Image*",
                            style: TextStyle(
                              color:Colors.blue,
                            ),)
                        ],
                      );
                    }
                  },
                ),
                SizedBox(height: h*0.025,),
                TextFormField(
                  controller: nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    var val = value ?? '';
                    if (val.isEmpty) {
                      return 'Please enter Name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      constraints: BoxConstraints(maxHeight: h*0.08),
                      labelText: "Product Name*",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w*0.02),
                      )
                  ),
                ),
                SizedBox(height: h*0.02,),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if(state is CategoryInitial ||state is CategoryLoadingState){
                      return const Center(child: CircularProgressIndicator(),);
                    }else if(state is CategoryError){
                      String error=state.error;
                      return Center(child: Text(error),);
                    }else if(state is ReadCategoryState) {
                      return BlocBuilder<DropDownBloc, String?>(
                        builder: (context, value) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Select Catalog*",
                                style: TextStyle(
                                  color:value==null?Colors.red:Colors.blue,
                                ),),
                              Container(
                                  height: h*0.06,
                                  width:w* 0.5,
                                  // margin: EdgeInsets.only(left:w*0.02),
                                  padding: EdgeInsets.only(left:w*0.02,right: w*0.02),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(w*0.03)
                                  ),
                                  child:DropdownButton(
                                    underline: const SizedBox(),
                                    isExpanded: true,
                                    hint: const Text("select Catalog"),
                                    icon: const Icon(Icons.keyboard_arrow_down_outlined),
                                    borderRadius: BorderRadius.circular(w * 0.03),
                                    value:value,
                                    items: state.categories.map((e) =>
                                        DropdownMenuItem(
                                            value: e.name,
                                            child: Text(e.name))).toList(),
                                    onChanged: (value) {

                                      BlocProvider.of<DropDownBloc>(context).add(DropDownChanged(value));
                                    },),
                              ),
                            ],
                          );
                        },
                      );
                    }else{
                      print(state.runtimeType);
                      return const Text(" No state}");
                    }
                  },
                ),
                SizedBox(height: h*0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: w*0.45,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: mrpController,
                        validator: (value) {
                          var val = value ?? '';
                          if (val.isEmpty) {
                            return 'Please enter Mrp';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            constraints: BoxConstraints(maxHeight: h*0.09),
                            labelText: "MRP ₹",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(w*0.02),
                            )
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h*0.02,),
                 Column(
                  children: [
                    TextFormField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        var val = value ?? '';
                        if (val.isEmpty) {
                          return 'Please enter stock';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          constraints: BoxConstraints(maxHeight: h*0.09),
                          labelText: "Stock",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(w*0.02),
                          )
                      ),
                    ),
                    SizedBox(height: h*0.01,),
                    TextFormField(
                      controller: detailsController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        var val = value ?? '';
                        if (val.isEmpty) {
                          return 'Please enter Details';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          constraints: BoxConstraints(maxHeight: h*0.09),
                          labelText: "Product Details (optional)",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(w*0.02),
                          )
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h*0.02,),
                SizedBox(height: h*0.01,),
                const Text("Is Active ?",
                  style: TextStyle(
                      color: Colors.blue
                  ),),
                BlocBuilder<RadioBloc, bool>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Radio(value: true,
                          activeColor:Colors.blue ,
                          groupValue: state,
                          onChanged: (value) {
                          print(state);
                          context.read<RadioBloc>().add(ChangeValue(value =!value!));
                          // state=!state;
                            // setState(() {
                            //   toggle =! toggle;
                            // });
                          },),
                        const Text("Yes"),
                        SizedBox(width: w*0.02,),
                        Radio(
                          value: false,
                          activeColor:Colors.blue ,
                          groupValue: state,
                          onChanged: (value) {
                            print(state);
                            context.read<RadioBloc>().add(ChangeValue(value =!value!));
                            // state=!state;
                            // setState(() {
                            //   toggle =! toggle;
                            // });
                          },),
                        const Text("No"),
                        SizedBox(width: w*0.02,),
                      ],
                    );
                  },
                ),
                SizedBox(height: h*0.01,),
                ElevatedButton(
                  onPressed: ()  {
                    if(_formKey.currentState!.validate()){
                      if(BlocProvider.of<ImagePickerBloc>(context).state.file!=null &&
                          BlocProvider.of<DropDownBloc>(context).state!=null
                      ){
                        BlocProvider.of<ProductBloc>(context).add(AddProduct(
                            productName: nameController.text,
                            available: BlocProvider.of<RadioBloc>(context).state,
                            mrp: double.tryParse(mrpController.text)??0, details: detailsController.text,
                            category: BlocProvider.of<DropDownBloc>(context).state??"",
                            stock: int.tryParse(stockController.text)??0, context: context,
                            file: File(BlocProvider.of<ImagePickerBloc>(context).state.file!.path.toString())));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(w, h*0.06),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Upload Product",
                      style: TextStyle(color: Colors.white,
                          fontSize: w*0.045,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
