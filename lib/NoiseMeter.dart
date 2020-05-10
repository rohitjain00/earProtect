import 'dart:async';

import 'package:earprotect/timeCalculate.dart';
import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';

class NoiseMeter extends StatefulWidget {
  @override
  _NoiseMeterState createState() => new _NoiseMeterState();
}

class _NoiseMeterState extends State<NoiseMeter> {
  bool _isRecording = false;
  StreamSubscription<NoiseEvent> _noiseSubscription;
  int _noiseLevel;
  Noise _noise;

  @override
  void initState() {
    super.initState();
  }

  void onData(NoiseEvent e) {
    this.setState(() {
      this._noiseLevel = e.decibel;
      if (!this._isRecording) {
        this._isRecording = true;
      }
    });
  }

  void startRecorder() async {
    try {
      _noise = new Noise(500); // New observation every 500 ms
      _noiseSubscription = _noise.noiseStream.listen(onData);
    } on NoiseMeterException catch (exception) {
      print(exception);
    }
  }

  void stopRecorder() async {
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription.cancel();
        _noiseSubscription = null;
      }
      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Ear Protect"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text(
                "Noise Level",
              ),
              Text(
                _noiseLevel == null ? 'unknown' : '$_noiseLevel db',
                style: Theme.of(context).textTheme.display1,
              ),
              Expanded(child: TimeCalculate(decibal: _noiseLevel)),
              RaisedButton(
                child: Text('Clear All'),
                onPressed: () {
                  TimeCalculateState.timeElapsed = [];
                },
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (!this._isRecording) {
                return this.startRecorder();
              }
              this.stopRecorder();
            },
            child: Icon(this._isRecording ? Icons.stop : Icons.mic)),
      ),
    );
  }
}