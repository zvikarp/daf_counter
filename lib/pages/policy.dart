import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:daf_plus_plus/utils/theme.dart';

class PolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Privacy Policy'),
        ),
        body: Container(
          child: FutureBuilder(
              future: DefaultAssetBundle.of(context)
                  .loadString('assets/legal/privacy-policy.md'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Markdown(
                    data: snapshot.data,
                    styleSheet: themeUtil.isDarkTheme(context)
                        ? MarkdownStyleSheet(
                            h1: TextStyle(color: Colors.white),
                            h3: TextStyle(color: Colors.white),
                          )
                        : MarkdownStyleSheet(
                            h1: TextStyle(color: Colors.black),
                          ),
                  );
                } else {
                  return Container(child: Text("Loading"));
                }
              }),
        ),
      ),
    );
  }
}
