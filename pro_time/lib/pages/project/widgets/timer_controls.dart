import 'package:flutter/material.dart';
import 'package:pro_time/model/time.dart';

class TimerControls extends StatelessWidget {
  TimerControls({
    this.startCallback,
    this.pauseCallback,
    this.stopCallback,
    this.state = TimerState.STOPPED,
    this.enabled = true,
    this.scaffoldKey,
  });

  final Function startCallback;
  final Function stopCallback;
  final Function pauseCallback;
  final TimerState state;
  final bool enabled;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case TimerState.STOPPED:
        return _buildStartButton(context);
      case TimerState.STARTED:
        return Column(
          children: [
            _buildPauseButton(context),
            SizedBox(height: 30.0),
            _buildStopButton(context, scale: 0.5),
          ],
        );
      case TimerState.PAUSED:
        return Column(
          children: [
            _buildStartButton(context),
            SizedBox(height: 30.0),
            _buildStopButton(context, scale: 0.5),
          ],
        );
      case TimerState.DISABLED:
        return Column(
          children: [
            _buildStartButton(context, color: Theme.of(context).disabledColor),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _buildStartButton(BuildContext context,
      {double scale = 1.0, Color color = const Color(0xFF37C33C)}) {
    return Container(
      height: 150.0 * scale,
      width: 150.0 * scale,
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          Theme.of(context).brightness == Brightness.dark
              ? BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2.0,
                  offset: Offset(0.0, 4.0),
                )
              : BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2.0,
                  offset: Offset(0.0, 4.0),
                )
        ],
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          enableFeedback: enabled,
          onTap: () => startCallback(),
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

  Widget _buildStopButton(BuildContext context, {double scale = 1.0}) {
    return Container(
      height: 150.0 * scale,
      width: 150.0 * scale,
      decoration: BoxDecoration(
        color: Color(0xFFFF3D00),
        boxShadow: [
          Theme.of(context).brightness == Brightness.dark
              ? BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2.0,
                  offset: Offset(0.0, 4.0),
                )
              : BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2.0,
                  offset: Offset(0.0, 4.0),
                )
        ],
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          enableFeedback: enabled,
          onTap: () => stopCallback(),
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

  Widget _buildPauseButton(BuildContext context, {double scale = 1.0}) {
    return Container(
      height: 150.0 * scale,
      width: 150.0 * scale,
      decoration: BoxDecoration(
        color: Color(0xFFFFEB3B),
        boxShadow: [
          Theme.of(context).brightness == Brightness.dark
              ? BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2.0,
                  offset: Offset(0.0, 4.0),
                )
              : BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2.0,
                  offset: Offset(0.0, 4.0),
                )
        ],
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          enableFeedback: enabled,
          onTap: () => pauseCallback(),
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
