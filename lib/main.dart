import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class RecursiveItem {
  final String title;
  final List<RecursiveItem> children;
  RecursiveItem? parent; // Add parent property

  RecursiveItem(this.title, this.children, this.parent);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Recursive List Example')),
        body: ParentListView(data: createData()),
      ),
    );
  }
}

class ParentListView extends StatelessWidget {
  final List<RecursiveItem> data;

  ParentListView({required this.data});

  int _countLevelsAbove(RecursiveItem item) {
    int count = 0;
    RecursiveItem? currentItem = item.parent;

    while (currentItem != null) {
      count++;
      currentItem = currentItem.parent;
    }

    return count;
  }

  void _showDialog(BuildContext context, RecursiveItem item) {
    int parentCount = _countLevelsAbove(item);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<RecursiveItem> children = item.children;
        return AlertDialog(
          title: Text('${item.title}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Over: ($parentCount)"),
              ),
              ElevatedButton(
                onPressed: () {
                  _showChildrenDialog(
                      context, item); // Pass the item to _showChildrenDialog
                },
                child: Text("Under: (${children.length})"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showChildrenDialog(BuildContext context, RecursiveItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Children'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var child in item.children)
                ListTile(
                  title: Text(child.title),
                  onTap: () {
                    Navigator.pop(context); // Close the child dialog
                    _showDialog(context, child); // Show the parent dialog
                  },
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return ListTile(
          title: Text(item.title),
          onTap: () {
            _showDialog(context, item); // Show dialog on tap
          },
        );
      },
    );
  }
}

List<RecursiveItem> createData() {
  final RecursiveItem grandChild1 = RecursiveItem('Grandchild 1', [], null);
  final RecursiveItem grandChild2 = RecursiveItem('Grandchild 2', [], null);
  final RecursiveItem child2 =
      RecursiveItem('Child 2', [grandChild1, grandChild2], null);
  final RecursiveItem child1 = RecursiveItem('Child 1', [], null);
  final RecursiveItem parent1 =
      RecursiveItem('Parent 1', [child1, child2], null);

  child2.parent = parent1;
  child1.parent = parent1;
  grandChild1.parent = child1.parent;
  grandChild2.parent = child2.parent;

  final RecursiveItem grandChild3 = RecursiveItem('Grandchild 3', [], null);
  final RecursiveItem child3 = RecursiveItem('Child 3', [grandChild3], null);
  final RecursiveItem parent3 = RecursiveItem('Parent 3', [grandChild3], null);
  child3.parent = parent3;
  grandChild3.parent = parent3;

  final RecursiveItem parent2 = RecursiveItem('Parent 2', [], null);

  return [parent1, parent2, parent3];
}
