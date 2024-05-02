import 'package:flutter/material.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:EdgeInsets.all(16),
      
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(
          15
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Text("لما اتفرّقت العقول كل واحد عجبه عقله، ولما اتفرّقت الأرزاق ماحدش عجبه رزقه",style: TextStyle(
            fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold
          ),),
          Text("القرد في عين أمه غزال",style: TextStyle(
            fontSize: 18,color: Colors.amber
          ),)
        ]
      )
    );
  }
}