import 'package:flutter/material.dart';
import 'package:pro_time/main.dart';

class TimerControls extends StatefulWidget {
  TimerControls({
    this.startCallback,
    this.pauseCallback,
    this.stopCallback,
    this.initialState = TimerState.STOPPED,
    this.enabled = true,
    this.scaffoldKey,
  });

  final Function startCallback;
  final Function stopCallback;
  final Function pauseCallback;
  final TimerState initialState;
  final bool enabled;
  final GlobalKey<ScaffoldState> scaffoldKey;

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
        color: Color(0xFF37C33C),
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
            if (!widget.enabled) {
              if (widget.scaffoldKey != null) {
                widget.scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(
                        "You have to stop the current activity before starting another."),
                  ),
                );
              }
              return;
            }
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
            child: Image.asset("assets/images/play.png"),
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
        color: Color(0xFFFF3D00),
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
            if (!widget.enabled) {
              if (widget.scaffoldKey != null) {
                widget.scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(
                        "You have to stop the current activity before starting another."),
                  ),
                );
              }
              return;
            }
            setState(() {
              _state = TimerState.STOPPED;
            });
            if (widget.stopCallback != null) widget.stopCallback();
          },
          borderRadius: BorderRadius.circular(100.0),
          child: Container(
            padding: EdgeInsets.only(
              left: 46.0 * scale,
              right: 46.0 * scale,
              top: 46.0 * scale,
              bottom: 46.0 * scale,
            ),
            child: Image.asset("assets/images/stop.png"),
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
        color: Color(0xFFFFEB3B),
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
            if (!widget.enabled) {
              if (widget.scaffoldKey != null) {
                widget.scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(
                        "You have to stop the current activity before starting another."),
                  ),
                );
              }
              return;
            }
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
            child: Image.asset("assets/images/pause.png"),
          ),
        ),
      ),
    );
  }
}
