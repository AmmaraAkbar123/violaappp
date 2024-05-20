import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:viola/json_models/mydata_model.dart';

class MainContainers extends StatefulWidget {
  final Datum data;
  const MainContainers({super.key, required this.data});

  @override
  State<MainContainers> createState() => _MainContainersState();
}

class _MainContainersState extends State<MainContainers> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 5, 20),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 247, 247, 247),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(6),
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
                                      Image.network(
                                          'https://tse3.mm.bing.net/th?id=OIP.9hetfdrodOfI9KzE_g_dDAAAAA&pid=Api&P=0&h=180',
                                          fit: BoxFit.cover),
                                )
                              : Image.network(
                                  'https://tse3.mm.bing.net/th?id=OIP.9hetfdrodOfI9KzE_g_dDAAAAA&pid=Api&P=0&h=180',
                                  fit: BoxFit.cover),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            child: Container(
                                width: 110,
                                color: widget.data.closed
                                    ? Colors.red.withOpacity(0.3)
                                    : Colors.green.withOpacity(0.3),
                                padding: const EdgeInsets.all(3),
                                child: Text(
                                  widget.data.closed ? "close" : "Open",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )),
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
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.data.name.en,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(75, 0, 95, 1),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${widget.data.distance.toStringAsFixed(2)} كم",
                            style: const TextStyle(color: Colors.blueGrey),
                          ),
                        ],
                      ),
                      Text(
                        widget.data.description.en,
                        style: const TextStyle(color: Colors.purple),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.data.addressDesc,
                        style: const TextStyle(
                            color: Colors.purple,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            if (widget.data.description.en.isNotEmpty)
              Divider(
                color: Colors.grey[300],
                thickness: 1,
                indent: 118,
                endIndent: 5,
              ),
            Transform.translate(
                offset: const Offset(0, 10),
                child: Container(
                    padding: const EdgeInsets.all(5),
                    height: 25,
                    width: double.infinity,
                    color: const Color.fromRGBO(255, 218, 108, 0.949),
                    child: Marquee(
                      text: widget.data.description.en,
                      scrollAxis: Axis.horizontal,
                      blankSpace: 350,
                      velocity: 50,
                      pauseAfterRound: const Duration(seconds: 2),
                    ))),
          ],
        ),
      ),
    );
  }
}
