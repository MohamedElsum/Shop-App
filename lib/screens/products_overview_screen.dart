import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/product_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions{
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {

  var showOnlyFavorites = false;
  var isInit = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    if(isInit){
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetData();
      setState(() {
        isLoading = false;
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
        actions: [
          PopupMenuButton(
              itemBuilder: (_) => [
                PopupMenuItem(child: Text('Only Favorites'),value: FilterOptions.favorites,),
                PopupMenuItem(child: Text('All Shop'),value: FilterOptions.all,),
              ],
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedValue){
                setState(() {
                  if(selectedValue == FilterOptions.favorites){
                    showOnlyFavorites = true;
                  }else{
                    showOnlyFavorites = false;
                  }
                });
            },
          ),
          Consumer<Cart>(
            builder: (_,cart,ch) => Badge(
                child: ch as Widget,
                value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: (){
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading ? Center(child: CircularProgressIndicator(),) : ProductGrid(showFav: showOnlyFavorites),
    );
  }
}