import 'package:flutter/material.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

class UserProductItem extends StatelessWidget {
  String id;
 String title;
 String imageUrl;

 UserProductItem({required this.id,required this.title,required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100.0,
        child: Row(
          children: [
            IconButton(
                onPressed: (){
                  Navigator.of(context).pushNamed(EditProductScreen.routeName , arguments: id);
                },
                icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
                onPressed: () async{
                  try{
                    await Provider.of<Products>(context,listen: false).deletePrdouct(id);
                  }catch(error){
                    scaffold.showSnackBar(SnackBar(content: Text('Deleted failed!!')));
                  }
                },
                icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
