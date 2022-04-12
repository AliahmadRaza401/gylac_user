import 'package:flutter/material.dart';

class ProcessLoading extends StatefulWidget{

  @override
  State createState() {
    return _ProcessLoadingState();
  }
}

class _ProcessLoadingState extends State<ProcessLoading> with SingleTickerProviderStateMixin{

  AnimationController? _cont;
  Animation<Color?>? _anim;

  @override
  void initState() {
    _cont=AnimationController(duration: Duration(seconds: 1,),vsync: this);
    _cont!.addListener(() {
      setState(() {
        //print("val: "+_cont.value.toString());
      });
    });
    ColorTween col=ColorTween(begin: Color.fromRGBO(251, 176, 59,1),
        end:Color.fromRGBO(221, 056, 5,0.4),);
    _anim=col.animate(_cont!);
    _cont!.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _cont!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(color:Color.fromRGBO(0, 0, 0, 0.5),
        child: Center(
          child: Container(width: 50*_cont!.value,height: 50*_cont!.value,
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(_anim!.value,),)),
        ));
  }
}
