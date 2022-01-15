import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_screen';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final priceFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final imageUrlController = TextEditingController();
  final imageFocusNode = FocusNode();
  final form = GlobalKey<FormState>();
  var isLoading = false;
  var editedProduct = Product(
      id: null,
      title: '',
      description: '',
      imageUrl: '',
      price: 0.0);
  var isInit = true;
  var initValues = {
    'title' : '',
    'price' : '',
    'description' : '',
    'imageUrl' : '',
  };

  @override
  void initState() {
    super.initState();
    imageFocusNode.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    if(isInit){
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if(productId != null){
        editedProduct = Provider.of<Products>(context).findById(productId);
        initValues = {
          'title' : editedProduct.title,
          'price' : editedProduct.price.toString(),
          'description' : editedProduct.description,
          'imageUrl' : '',
        };
        imageUrlController.text = editedProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  void updateImage() {
    if (!imageFocusNode.hasFocus) {
      if ((!imageUrlController.text.startsWith('http') &&
              !imageUrlController.text.startsWith('https')) ||
          (!imageUrlController.text.endsWith('jpg') &&
              !imageUrlController.text.endsWith('png') &&
              !imageUrlController.text.endsWith('jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    priceFocusNode.dispose();
    descriptionFocusNode.dispose();
    imageUrlController.dispose();
    imageFocusNode.removeListener(updateImage);
    imageFocusNode.dispose();
  }

  void saveForm() async{
    var isValid = form.currentState!.validate();
    if (!isValid) {
      return;
    }
    form.currentState!.save();
    setState(() {
      isLoading = true;
    });
    if(editedProduct.id != null){
      await Provider.of<Products>(context, listen: false).updateProducts(editedProduct.id as String, editedProduct);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    }else{
      try{
       await Provider.of<Products>(context,listen: false).addProduct(editedProduct);
      }catch(error){
         await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured'),
            content: Text('Something went wrong'),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.of(ctx).pop();
                },
                child: Text('Okay'),
              ),
            ],
          ),
        );
      }
      finally{
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
        actions: [
          IconButton(
            onPressed: saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: isLoading ? Center(child: CircularProgressIndicator(),) : Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a title';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(priceFocusNode);
                },
                onSaved: (value) {
                  editedProduct = Product(
                    isFavorite: editedProduct.isFavorite,
                      id: editedProduct.id,
                      title: value.toString(),
                      description: editedProduct.description,
                      imageUrl: editedProduct.imageUrl,
                      price: editedProduct.price);
                },
              ),
              TextFormField(
                initialValue: initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: priceFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a Price';
                  }
                  if (double.tryParse(value.toString()) == null) {
                    return 'Please enter a valid price';
                  }
                  if (double.parse(value.toString()) <= 0) {
                    return 'Price must br greater than zero';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(descriptionFocusNode);
                },
                onSaved: (value) {
                  editedProduct = Product(
                      isFavorite: editedProduct.isFavorite,
                      id: editedProduct.id,
                      title: editedProduct.title,
                      description: editedProduct.description,
                      imageUrl: editedProduct.imageUrl,
                      price: double.parse(value.toString()));
                },
              ),
              TextFormField(
                initialValue: initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: descriptionFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length < 10) {
                    return 'Description must be greater than 10';
                  }
                  return null;
                },
                onSaved: (value) {
                  editedProduct = Product(
                      isFavorite: editedProduct.isFavorite,
                      id: editedProduct.id,
                      title: editedProduct.title,
                      description: value.toString(),
                      imageUrl: editedProduct.imageUrl,
                      price: editedProduct.price);
                },
              ),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.0, color: Colors.grey),
                    ),
                    child: imageUrlController.text.isEmpty
                        ? Center(
                            child: Text(
                            'Enter a URL',
                            textAlign: TextAlign.center,
                          ))
                        : FittedBox(
                            child: Image.network(imageUrlController.text),
                            fit: BoxFit.fill,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'ImageUrl'),
                      keyboardType: TextInputType.url,
                      controller: imageUrlController,
                      focusNode: imageFocusNode,
                      onFieldSubmitted: (_) {
                        saveForm();
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                            isFavorite: editedProduct.isFavorite,
                            id: editedProduct.id,
                            title: editedProduct.title,
                            description: editedProduct.description,
                            imageUrl: value.toString(),
                            price: editedProduct.price);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
