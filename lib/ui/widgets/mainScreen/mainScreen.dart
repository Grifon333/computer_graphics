import 'package:flutter/material.dart';
import 'package:graphics/Theme/app_colors.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Graphics',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 24,
            color: AppColors.title,
            shadows: [
              Shadow(
                offset: Offset(-1, -1),
                color: Colors.black,
              ),
              Shadow(
                offset: Offset(1, -1),
                color: Colors.black,
              ),
              Shadow(
                offset: Offset(-1, 1),
                color: Colors.black,
              ),
              Shadow(
                offset: Offset(1, 1),
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
      body: const _ListLabsWidget(),
    );
  }
}

class _ListLabsWidget extends StatelessWidget {
  const _ListLabsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: const [
          _ListButtons(),
          SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: Text(
              '© KING',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _ListButtons extends StatelessWidget {
  const _ListButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 640,
      child: ListView.builder(
        itemCount: 1,
        itemExtent: 80,
        padding: const EdgeInsets.only(top: 30),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: index < 1
                    ? MaterialStateProperty.all(AppColors.buttonBG)
                    : MaterialStateProperty.all(AppColors.buttonBG_disable),
              ),
              onPressed: index < 1
                  ? () => Navigator.of(context).pushNamed('/lab${index + 1}')
                  : null,
              child: Text(
                'Lab ${index + 1}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}