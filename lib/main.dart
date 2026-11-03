import 'package:flutter/material.dart';

void main() {
  runApp(const ArtisanChocolateApp());
}

class ArtisanChocolateApp extends StatelessWidget {
  const ArtisanChocolateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Artisan Chocolate',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF3E2723), // Dark Brown theme
        primaryColor: const Color(0xFFFFD700), // Gold
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  int currentRecipeIndex = 0;

  final List> recipes = [
    {
      'name': 'Dark Chocolate Truffle',
      'needed': ['Cocoa Beans', 'Heavy Cream', 'Cocoa Powder'],
      'collected': <String>[],
    },
    {
      'name': 'Hazelnut Praline',
      'needed': ['Milk Chocolate', 'Roasted Hazelnuts', 'Caramel'],
      'collected': <String>[],
    },
    {
      'name': 'White Choco Raspberry',
      'needed': ['White Chocolate', 'Raspberries', 'Vanilla'],
      'collected': <String>[],
    }
  ];

  final List<String> allIngredients = [
    'Cocoa Beans', 'Heavy Cream', 'Cocoa Powder', 
    'Milk Chocolate', 'Roasted Hazelnuts', 'Caramel',
    'White Chocolate', 'Raspberries', 'Vanilla',
    'Salt', 'Chili', 'Garlic' // Traps
  ];

  void handleIngredientTap(String ingredient) {
    var currentRecipe = recipes[currentRecipeIndex];
    List<String> needed = List<String>.from(currentRecipe['needed']);
    List<String> collected = List<String>.from(currentRecipe['collected']);

    if (collected.contains(ingredient)) return;

    setState(() {
      if (needed.contains(ingredient)) {
        recipes[currentRecipeIndex]['collected'].add(ingredient);
        score += 10;
        
        if (recipes[currentRecipeIndex]['collected'].length == needed.length) {
          score += 50; 
          if (currentRecipeIndex < recipes.length - 1) {
            currentRecipeIndex++;
          } else {
            showGameOverDialog();
          }
        }
      } else {
        score -= 5;
      }
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFFDD0),
        title: const Text('Boutique Closed!', style: TextStyle(color: Color(0xFF3E2723), fontWeight: FontWeight.bold)),
        content: Text('All orders completed!\nYour Total Score: $score', style: const TextStyle(fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                score = 0;
                currentRecipeIndex = 0;
                for (var r in recipes) {
                  r['collected'] = <String>[];
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Play Again', style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentRecipe = recipes[currentRecipeIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artisan Chocolate Boutique', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[900],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Score: $score',
              style: const TextStyle(fontSize: 28, color: Color(0xFFFFD700), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDD0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text('Current Order:', style: TextStyle(fontSize: 20, color: Colors.brown)),
                  Text(
                    currentRecipe['name'],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Collected: ${currentRecipe['collected'].length} / ${currentRecipe['needed'].length}',
                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text('Select Ingredients:', style: TextStyle(fontSize: 22, color: Colors.white)),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: allIngredients.length,
                itemBuilder: (context, index) {
                  String ingredient = allIngredients[index];
                  bool isCollected = currentRecipe['collected'].contains(ingredient);
                  
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCollected ? Colors.grey : const Color(0xFFFFD700),
                      foregroundColor: Colors.brown[900],
                      padding: const EdgeInsets.all(8),
                    ),
                    onPressed: isCollected ? null : () => handleIngredientTap(ingredient),
                    child: Text(
                      ingredient,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
