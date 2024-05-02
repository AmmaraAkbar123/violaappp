import 'package:flutter/material.dart';
import 'package:viola/json_models/feature_model.dart';

class HorizontalCard extends StatelessWidget {
  final FeatureDatum data;
  const HorizontalCard({super.key,required this.data});

  @override
  Widget build(BuildContext context) {
    
    final double width = MediaQuery.of(context).size.width * 0.6;
     return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: width,
        child: Column(
          children: [
           
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child:  Image.network(
                    data.media.isNotEmpty ? data.media.first.url :
      
                    'https://tse4.mm.bing.net/th?id=OIP.P964u_TuURYpxhlzDpVBIwHaEo&pid=Api&P=0&h=180',
                    
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context,error,stackTrace)=>
                    Image.network("https://tse4.mm.bing.net/th?id=OIP.P964u_TuURYpxhlzDpVBIwHaEo&pid=Api&P=0&h=180",
                      height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                      )
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.closed? Colors.red.withOpacity(0.4):Colors.green.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                     data.closed?
                     "Closed":"Open",
                  
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
           
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                         data.name.en,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(60, 8, 74, 1),
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(height: 4),
                      Text(
                        data.description.en,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blueGrey,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
              ],
            ),
           
          ],
        ),
      ),
    );
   
  }
}