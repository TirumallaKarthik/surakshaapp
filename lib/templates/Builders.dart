import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surakshaapp/Scripts/User.dart';


abstract class Builder{
  User idx = new User();
  Widget builder();
}


class CarouselBuilder extends Builder{
   var _height;
   var _width;
   var _dotsize;
   List<Map<String,dynamic>> _objects;

   CarouselBuilder(this._height,this._width,this._dotsize,this._objects);
   @override
   Widget builder(){

     return Carousel(
       images: this._objects.map((dict){
          return  Container(
                   height: this._height,
                   width: this._width,
                   padding: dict['padding'],
                   child: dict['child'],
                   decoration: dict['decoration']
                 );
         }).toList(),
       dotSize: this._dotsize,
       dotSpacing: this._dotsize!*10,
       dotColor: Colors.lightGreenAccent,
       indicatorBgPadding: this._dotsize!*5,
       dotBgColor: Colors.purple.withOpacity(0.5),
       borderRadius: false,
       autoplay: false,
       noRadiusForIndicator: true,
     );
   }
}

class TextBuilder extends Builder{

  var _text;
  var _font;
  var _size;
  var _weight;
  var _color;
  TextBuilder(this._text,this._font,this._size,this._weight,this._color);
  @override
  Widget builder(){
    return Text(this._text,style: TextStyle(fontFamily: this._font,fontSize: this._size,fontWeight: this._weight,color: this._color));
  }

}

class TextInputBuilder extends Builder{

  var _inputtype;
  var _label;
  var _hint;
  var _radius;
  var _controller;
  TextInputBuilder(this._inputtype,this._label,this._hint,this._radius,this._controller);
  @override
  Widget builder(){
    return TextField(
        keyboardType: this._inputtype,
        decoration: InputDecoration(
            labelText: this._label,
            hintText: this._hint,
            border: OutlineInputBorder(
                borderRadius: this._radius
            )
        ),
        controller: this._controller
    );
  }

}

class ProfileBuilder extends Builder {

  var _height;
  var _width;
  var _name;
  var _identity;
  var _state;
  var _orphans_count;
  var _context;

  ProfileBuilder(this._height, this._width, this._name, this._identity,
      this._state, this._orphans_count, this._context);

  @override
  Widget builder() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Image(
                    image: AssetImage('assets/back.png'), height: _height / 4),
                Positioned(child: TextBuilder(
                    this._name, 'Staatliches', 15.0, FontWeight.bold,
                    Colors.white).builder(), top: this._height / 6),
                Positioned(
                    child: Icon(Icons.person, size: 70, color: Colors.white),
                    top: this._height / 16)
              ]
          )),

          Center(child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                    child: Image(image: AssetImage('assets/back_bo.png')),
                    height: this._height / 8,
                    width: 9 * this._width / 10),
                TextBuilder(
                    this._identity, 'Staatliches', 12.0, FontWeight.bold,
                    Colors.white).builder()
              ]
          )),

          Center(child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                    child: Image(image: AssetImage('assets/back_bo.png')),
                    height: this._height / 8,
                    width: 9 * this._width / 10),
                TextBuilder(this._state, 'Staatliches', 12.0, FontWeight.bold,
                    Colors.white).builder()
              ]
          )),

          Center(child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                    child: Image(image: AssetImage('assets/back_bo.png')),
                    height: this._height / 8,
                    width: 9 * this._width / 10),
                TextBuilder(
                    'orphans count : ${this._orphans_count}', 'Staatliches',
                    12.0, FontWeight.bold, Colors.white).builder()
              ]
          )),

          Container(
              child: ElevatedButton(
                onPressed: () async {
                  idx.signout().then((_){
                    Navigator.of(this._context).pushNamedAndRemoveUntil('Login',(Route<dynamic> route) => false);
                  });
                },
                child: Text('Log Out'),
              )
          ),
          SizedBox(
            height: this._height / 10,
          )
        ]

    );
  }
}


class OrphansListViewBuilder extends Builder{

  var _orphans;
  var _type;
  OrphansListViewBuilder(this._type,this._orphans);
  @override
  Widget builder(){

      return Flexible(

               child: ListView.builder(
               itemCount: this._orphans.length,
               itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shadowColor: Colors.black12,
                  child: ListTile(
                      leading: Icon(Icons.account_box_rounded),
                      trailing: Text(this._type=='member'?this._orphans[index].adoptedby:this._orphans[index].reportedby),
                      title: Text(this._orphans[index].name),
                      onTap: () {
                        Navigator.of(context).pushNamed('Orphan',arguments: {'orphan':this._orphans[index]});
                      }
                  )
                );
              },
                shrinkWrap: true,
                scrollDirection: Axis.vertical
               ) );
  }

}
