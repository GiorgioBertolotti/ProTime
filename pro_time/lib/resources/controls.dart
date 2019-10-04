import 'package:flutter/material.dart';
import 'package:pro_time/main.dart';

class TimerControls extends StatefulWidget {
  TimerControls({
    this.startCallback,
    this.pauseCallback,
    this.stopCallback,
    this.initialState = TimerState.STOPPED,
    this.enabled = true,
  });

  final Function startCallback;
  final Function stopCallback;
  final Function pauseCallback;
  final TimerState initialState;
  final bool enabled;

  @override
  _TimerControlsState createState() => _TimerControlsState();
}

class _TimerControlsState extends State<TimerControls> {
  TimerState _state = TimerState.STOPPED;

  @override
  void initState() {
    if (widget.enabled) _state = widget.initialState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case TimerState.STOPPED:
        return _buildStartButton();
      case TimerState.STARTED:
        return Column(
          children: <Widget>[
            _buildPauseButton(),
            SizedBox(height: 30.0),
            _buildStopButton(scale: 0.5),
          ],
        );
      case TimerState.PAUSED:
        return Column(
          children: <Widget>[
            _buildStartButton(),
            SizedBox(height: 30.0),
            _buildStopButton(scale: 0.5),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _buildStartButton({double scale = 1.0}) {
    return Container(
      height: 150.0 * scale,
      width: 150.0 * scale,
      decoration: BoxDecoration(
        color: Colors.green,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2.0,
            offset: Offset(0.0, 4.0),
          )
        ],
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          enableFeedback: widget.enabled,
          onTap: () {
            if (!widget.enabled) return;
            setState(() {
              _state = TimerState.STARTED;
            });
            if (widget.startCallback != null) widget.startCallback();
          },
          borderRadius: BorderRadius.circular(100.0),
          child: Container(
            padding: EdgeInsets.only(
              left: 40.0 * scale,
              right: 30.0 * scale,
              top: 30.0 * scale,
              bottom: 30.0 * scale,
            ),
            child: Image.asset("assets/play.png"),
          ),
        ),
      ),
    );
  }

  Widget _buildStopButton({double scale = 1.0}) {
    return Container(
      height: 150.0 * scale,
      width: 150.0 * scale,
      decoration: BoxDecoration(
        color: Colors.red,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2.0,
            offset: Offset(0.0, 4.0),
          )
        ],
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          enableFeedback: widget.enabled,
          onTap: () {
            if (!widget.enabled) return;
            setState(() {
              _state = TimerState.STOPPED;
            });
            if (widget.stopCallback != null) widget.stopCallback();
          },
          borderRadius: BorderRadius.circular(100.0),
          child: Container(
            padding: EdgeInsets.only(
              left: 38.0 * scale,
              right: 38.0 * scale,
              top: 38.0 * scale,
              bottom: 38.0 * scale,
            ),
            child: Image.asset("assets/stop.png"),
          ),
        ),
      ),
    );
  }

  Widget _buildPauseButton({double scale = 1.0}) {
    return Container(
      height: 150.0 * scale,
      width: 150.0 * scale,
      decoration: BoxDecoration(
        color: Colors.yellow,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2.0,
            offset: Offset(0.0, 4.0),
          )
        ],
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          enableFeedback: widget.enabled,
          onTap: () {
            if (!widget.enabled) return;
            setState(() {
              _state = TimerState.PAUSED;
            });
            if (widget.pauseCallback != null) widget.pauseCallback();
          },
          borderRadius: BorderRadius.circular(100.0),
          child: Container(
            padding: EdgeInsets.only(
              left: 45.0 * scale,
              right: 45.0 * scale,
              top: 45.0 * scale,
              bottom: 45.0 * scale,
            ),
            child: Image.asset("assets/pause.png"),
          ),
        ),
      ),
    );
  }
}
