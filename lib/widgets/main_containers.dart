import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:viola/json_models/mydata_model.dart';

class MainContainers extends StatefulWidget {
  final Datum data;
  const MainContainers({super.key,required this.data});

  @override
  State<MainContainers> createState() => _MainContainersState();
}

class _MainContainersState extends State<MainContainers> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10,5 , 5, 20),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 243, 238, 238),
          borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                   margin: EdgeInsets.all(6),
                  width: 110,
                  height: 100,
                  child: ClipRRect(
                       borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Positioned.fill(
                        child: widget.data.media.isNotEmpty
                            ? Image.network(
                                widget.data.media.first.icon,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.network('https://tse3.mm.bing.net/th?id=OIP.9hetfdrodOfI9KzE_g_dDAAAAA&pid=Api&P=0&h=180',
                                        fit: BoxFit.cover),
                              )
                            : Image.network('https://tse3.mm.bing.net/th?id=OIP.9hetfdrodOfI9KzE_g_dDAAAAA&pid=Api&P=0&h=180',
                                fit: BoxFit.cover),
                      ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ClipRRect(
                             borderRadius: BorderRadius.only(
                                 bottomLeft: Radius.circular(20),
                                 bottomRight: Radius.circular(20)),
                            child: Container(
                              
                              width: 110,
                             color:  widget.data.closed? Colors.red.withOpacity(0.3): Colors.green.withOpacity(0.3),
                             padding: EdgeInsets.all(3),
                            child: 
                            Text(
                             widget.data.closed?
                                 "close":"Open",
                                 
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            
                            )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                 Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.data.name.en,
                             overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(75, 0, 95, 1),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                           "${widget.data.distance.toStringAsFixed(2)} كم",
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                    Text(
                     widget.data.description.en,
                      style: TextStyle(
                          color:  Colors.purple),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                    widget.data.addressDesc,
                      style: TextStyle(
                          color: Colors.purple,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(width: 10),
                    
                  ],
                ),
              ),
              ],
              
            ),
            SizedBox(width: 10),

            if(widget.data.description.en.isNotEmpty)
            Divider(
                      color: Colors.grey[300],
              thickness: 1,
               indent: 118,
               endIndent: 5,
                    ),
                    
                    Transform.translate(
        offset: const Offset(0, 10),
        child: Container(
            height: 25,
            width: double.infinity,
            color: Colors.amber,
            child: Marquee(
              text: widget.data.description.en,
              scrollAxis: Axis.horizontal,
              blankSpace: 350,
              velocity: 100,
            ))),
            
            
          ],
        ),
      ),
    );
  }
}