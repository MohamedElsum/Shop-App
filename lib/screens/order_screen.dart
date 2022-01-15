import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order_screen';
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var isLoading = false;

  @override
  void initState(){
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration.zero).then((_) async{
      await Provider.of<Orders>(context,listen: false).fetchAndSetOrders();
    });
    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      drawer: AppDrawer(),
      body:isLoading ? Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: orderData.orders.length,
          itemBuilder: (ctx,i) => OrderItem(order: orderData.orders[i]),
      ),
    );
  }
}
