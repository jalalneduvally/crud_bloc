import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import '../../../models/product_model.dart';
import '../../category/bloc/category_bloc.dart';
import '../../widget bloc/image_bloc.dart';
import '../../widget bloc/widget_bloc.dart';
import '../bloc/product_bloc.dart';


class UpdateProductScreen extends StatefulWidget {
  final ProductList productList;
  const UpdateProductScreen({super.key,required this.productList});
  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {

  TextEditingController nameController= TextEditingController();
  TextEditingController mrpController= TextEditingController();
  TextEditingController descriptionController= TextEditingController();
  TextEditingController stockController= TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameController.text= widget.productList.productName;
    mrpController.text= widget.productList.mrp.toString();
    descriptionController.text= widget.productList.details??"";
    stockController.text= widget.productList.stock.toString();
    BlocProvider.of<RadioBloc>(context).add(ChangeValue(!widget.productList.available));
    BlocProvider.of<DropDownBloc>(context).add(DropDownChanged(widget.productList.category.isEmpty?null:widget.productList.category));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    mrpController.dispose();
    descriptionController.dispose();
    stockController.dispose();
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
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Stack(
                          children: [
                            Container(
                              height: h*0.1,
                              width: w*0.25,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(image: NetworkImage(widget.productList.image),fit: BoxFit.fill)
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
                      );
                    }else{
                      return Align(
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
                      );
                    }
                  },
                ),
                SizedBox(height: h*0.025,),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    var val = value ?? '';
                    if (val.isEmpty) {
                      return 'Please enter Name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      constraints: BoxConstraints(maxHeight: h*0.07),
                      labelText: "Product Name*",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w*0.02),
                      )
                  ),
                ),
                SizedBox(height: h*0.02,),
                const Text("Select Catalog*",
                  style: TextStyle(
                    color: Colors.blue,
                  ),),
                Container(
                    height: w*0.13,
                    width:w* 0.5,
                    // margin: EdgeInsets.only(left:w*0.02),
                    padding: EdgeInsets.only(left:w*0.02,right: w*0.02),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(w*0.03)
                    ),
                    child:  BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if(state is CategoryInitial ||state is CategoryLoadingState){
                          return const Center(child: CircularProgressIndicator(),);
                        }else if(state is CategoryError){
                          String error=state.error;
                          return Center(child: Text(error),);
                        }else if(state is ReadCategoryState) {
                          return BlocBuilder<DropDownBloc, String?>(
                            builder: (context, value) {
                              return DropdownButton(
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
                                },);
                            },
                          );
                        }else{
                          print(state.runtimeType);
                          return const Text(" No state}");
                        }
                      },
                    )
                ),
                SizedBox(height: h*0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: w*0.45,
                      child: TextFormField(
                        controller: mrpController,
                        validator: (value) {
                          var val = value ?? '';
                          if (val.isEmpty) {
                            return 'Please enter Mrp';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            constraints: BoxConstraints(maxHeight: h*0.07),
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
                SizedBox(height: h*0.01,),
                Column(
                  children: [
                    TextFormField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        var val = value ?? '';
                        if (val.isEmpty) {
                          return 'Please enter stock';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          constraints: BoxConstraints(maxHeight: h*0.07),
                          labelText: "Stock",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(w*0.02),
                          )
                      ),
                    ),
                    SizedBox(height: h*0.01,),
                    TextFormField(
                      controller: descriptionController,
                      validator: (value) {
                        var val = value ?? '';
                        if (val.isEmpty) {
                          return 'Please enter Details';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          constraints: BoxConstraints(maxHeight: h*0.07),
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
                      BlocProvider.of<ProductBloc>(context).add(
                        UpdateProduct(productName: nameController.text.trim(),
                            available: BlocProvider.of<RadioBloc>(context).state,
                            context: context, mrp: double.tryParse(mrpController.text.trim())??0,
                            details: descriptionController.text.trim(),
                            category: BlocProvider.of<DropDownBloc>(context).state??widget.productList.category,
                            stock: int.tryParse(stockController.text.trim())??0,
                            product: widget.productList,
                            file:BlocProvider.of<ImagePickerBloc>(context).state.file!=null?
                            File(BlocProvider.of<ImagePickerBloc>(context).state.file!.path.toString()):null,
                            image: widget.productList.image)
                      );
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
