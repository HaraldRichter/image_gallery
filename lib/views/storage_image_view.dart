import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StorageImageView extends StatelessWidget {
  final Reference image;
  const StorageImageView({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
        // Little trick: By providing the data type for the FutureBuiler,
        // (here Uint8List), our snapshot will be of the exact same
        //  type instead of just being a generic "Object".
        future: image.getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            // TODO: Handle this case.
            case ConnectionState.waiting:
            // TODO: Handle this case.

            case ConnectionState.active:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return Image.memory(
                  data,
                  fit: BoxFit.cover,
                );
              } else {
                // Hint: Normally we should implement also some Error Handling here.
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              break;
          }
        });
  }
}
