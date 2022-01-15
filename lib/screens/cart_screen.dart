import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/widgets/cart_item.dart';
import 'package:shop_app/providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final order = Provider.of<Orders>(context,listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text('\$${cart.totalAmount}',style: TextStyle(color: Colors.white),),
                  ),
                  OrderButton(order: order, cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemBuilder: (ctx,i) => CartItem(
                      id: cart.items.values.toList()[i].id,
                      productId: cart.items.keys.toList()[i],
                      title: cart.items.values.toList()[i].title,
                      quantity: cart.items.values.toList()[i].quantity,
                      price: cart.items.values.toList()[i].price,
                  ),
                itemCount: cart.items.length,
              ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.order,
    required this.cart,
  }) : super(key: key);

  final Orders order;
  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (widget.cart.totalAmount<= 0 || isLoading) ? null : () async{
          setState(() {
            isLoading = true;
          });
          await widget.order.addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
          setState(() {
            isLoading = false;
          });
          widget.cart.clear();
        },
        child: isLoading ? CircularProgressIndicator() : Text(
            'ORDER NOW',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
    );
  }
}
