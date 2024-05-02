import 'package:flutter/material.dart';
import 'package:viola/services/models/homePage_model.dart';
import 'package:viola/utils/colors.dart';

class RadioButtonsModel extends StatefulWidget {
  const RadioButtonsModel({Key? key}) : super(key: key);

  @override
  _RadioButtonsModelState createState() => _RadioButtonsModelState();
}

class _RadioButtonsModelState extends State<RadioButtonsModel> {
  int _currentSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myTheme.hintColor, 
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                Spacer(),  
                Text(
                  "Flutter",
                  style: TextStyle(fontSize: 20, color: Colors.purple),
                  textAlign: TextAlign.center,
                ),
                Spacer(),  
                IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_forward_ios,))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: radioOptions.asMap().entries.map((e) {
                  int idx = e.key;
                  RadioModel option = e.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),  
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                      children: [
                        Spacer(),  
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(option.title),
                            Text(option.subtitle),
                          ],
                        ),
                        Radio<int>(
                          value: idx,
                          groupValue: _currentSelectedIndex,
                          onChanged: (int? value) {
                            setState(() {
                              _currentSelectedIndex = value ?? 0;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
