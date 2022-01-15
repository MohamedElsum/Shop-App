import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  String? id;
  String title;
  String imageUrl;
  double price;
  String description;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false});

  void toggleFavorite(String? token,String? userId){
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse('https://shop-app-84a4a-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');
    try{
      http.put(url,body: json.encode(
        isFavorite,
      ));
    }catch(error){
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
