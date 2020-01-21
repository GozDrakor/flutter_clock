import 'package:flutter/material.dart';

/////////////////////////////////////
// this code will process each column on the display, Hour/Minute/Second
// it assumes each digit of the time is passed individually through this with specific parameters set
// you can customize the sizeW (width) and sizeH (height) on how you'd like  the columns displayed
/////////////////////////////////////
List<AnimatedContainer> processClock(String amount, int colMin, int colMax,
    double sizeW, double sizeH, double contMargin, var textStyle) {
  //padding to shrink font on some columns of the clock
  double colPad = 25 - (double.parse(colMax.toString()) * 4);
  int animDuration = 750;
  if (colPad < 0) {
    colPad = 0;
  }

  int nstColor = 250;
  int stColor = 250; //starting primary colors
  var titleShown = false;

  List<AnimatedContainer> childrenContainers = List<AnimatedContainer>();
  for (int i = colMax; i >= colMin; i--) {
    String title = "";
    if (colMax > 1 && colMax <= 10) {
      title = i.toString();
    }
    if (colMax > 1) {
      if (int.parse(amount) >= i) {
        if (titleShown == false) {
          //only display number for the actual time
          titleShown = true;
        } else {
          title = "";
        }

        //gradually shade the following columns and gradient within the current cell
        if (stColor > 20) {
          nstColor = stColor - 60;
          if (nstColor < 20) {
            nstColor = 20;
          }
        }
        childrenContainers.add(
          new AnimatedContainer(
            duration: Duration(milliseconds: animDuration),
            margin: EdgeInsets.all(contMargin),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(20, stColor, 20, 0.8),
                    Color.fromRGBO(20, nstColor, 20, 0.8)
                  ]),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              color: Color.fromRGBO(20, stColor, 20, 0.85),
            ),
            // below will dynamically shrink/grow the font within the cell size
            child: FittedBox(
                fit: BoxFit.contain,
                child: Center(child: Text(title, style: textStyle))),
            width: sizeW,
            padding: EdgeInsets.all(colPad),
            height: sizeH,
          ),
        );
        //creates the fade in the color, resets min when falls below
        if (stColor > 20) {
          stColor = nstColor;
        }
      } else {
        //un-used grey cells for display purposes to round out the column cell #s
        //but are dark grey not to draw too much attention to them, but completes a nice
        //dark theme look/feel
        childrenContainers.add(new AnimatedContainer(
          duration: Duration(milliseconds: animDuration),
          margin: EdgeInsets.all(contMargin),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            color: Color.fromRGBO(20, 20, 20, 0.70),
          ),
          width: sizeW,
          height: sizeH,
        ));
      }
    } else {
      //blank middle divider for clock display
      childrenContainers.add(new AnimatedContainer(
        duration: Duration(milliseconds: animDuration),
        margin: EdgeInsets.all(contMargin),
        width: sizeW,
        height: sizeH,
      ));
    }
  }
  return childrenContainers;
}

/////////////////////////////////////
// This will handle displaying the high and low temperature for the day
// this also displays a nice matching red to blue thermometer display between the high and low temp
/////////////////////////////////////
List<Container> tempGauge(String highTemp, String lowTemp, double sizeW,
    double sizeH, double contMargin, var textStyle) {
  int stColor, nstColor; //starting primary color
  Color gaugeColor, ngaugeColor;
  int colNum = 7; //show 7 lines for hot & cold
  List<Container> childrenContainers = List<Container>();
  //dynamically size the temp gauge to the screen size
  double colSizeH = ((sizeH - 26) * .35) / 14;
  //show high value
  childrenContainers.add(new Container(
    margin: EdgeInsets.all(contMargin),
    padding: EdgeInsets.all(3.0),
    decoration: BoxDecoration(
      border: Border.all(width: 1, color: Color.fromRGBO(225, 10, 10, 0.6)),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      color: Color.fromRGBO(245, 40, 40, 0.6),
    ),
    width: sizeW,
    child: FittedBox(
        fit: BoxFit.contain,
        child: Center(child: Text(highTemp, style: textStyle))),
    height: sizeH * .10,
  ));

  // loop twice for hot and cold display
  for (int x = 0; x < 2; x++) {
    if (x == 0) {
      stColor = 250;
      nstColor = 220;
    } else {
      stColor = 40;
      nstColor = 70;
    }
    for (int i = 0; i <= colNum; i++) {
      if (x == 0) {
        //hot
        gaugeColor = Color.fromRGBO(stColor, 20, 20, 0.65);
        ngaugeColor = Color.fromRGBO(nstColor, 20, 20, 0.65);
      } else {
        gaugeColor = Color.fromRGBO(20, 20, stColor, 0.65);
        ngaugeColor = Color.fromRGBO(20, 20, nstColor, 0.65);
      }
      childrenContainers.add(new Container(
        margin: EdgeInsets.all(contMargin),
        width: sizeW,
        height: colSizeH,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                gaugeColor,
                ngaugeColor,
              ]),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          color: gaugeColor,
        ),
      ));
      //creates the fade in the color, resets min when falls below
      if (x == 0) {
        //hot
        if (stColor > 40) {
          stColor = stColor - 30;
          nstColor = stColor - 30;
          if (stColor < 40) {
            stColor = 40;
          }
          if (nstColor < 40) {
            nstColor = 40;
          }
        }
      } else {
        //cold
        if (stColor < 240) {
          stColor = stColor + 30;
          nstColor = stColor + 30;
          if (stColor > 240) {
            stColor = 240;
          }
          if (nstColor > 240) {
            nstColor = 240;
          }
        }
      }
    }
  }

  //show cold/low value
  childrenContainers.add(new Container(
    margin: EdgeInsets.all(contMargin),
    padding: EdgeInsets.all(3.0),
    decoration: BoxDecoration(
      border: Border.all(width: 1, color: Color.fromRGBO(10, 10, 225, 0.6)),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      color: Color.fromRGBO(40, 40, 245, 0.6),
    ),
    width: sizeW,
    child: FittedBox(
        fit: BoxFit.contain,
        child: Center(child: Text(lowTemp, style: textStyle))),
    height: sizeH * .10,
  ));

  return childrenContainers;
}
