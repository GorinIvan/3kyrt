import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../data/animal_repository.dart';
import '../data/cart_service.dart';
import '../data/models/animal.dart';

class ZooShopPage extends StatefulWidget {
  const ZooShopPage({super.key});

  @override
  State<ZooShopPage> createState() => _ZooShopPageState();
}

class _ZooShopPageState extends State<ZooShopPage> {
  final _searchController = TextEditingController();
  final _repository = GetIt.instance<AnimalRepository>();
  final _cartService = GetIt.instance<CartService>();

  List<Animal> _animals = [];
  bool _isLoading = false;

  Future<void> _searchAnimal() async {
    if (_searchController.text.trim().isEmpty) return;
    
    setState(() {
      _isLoading = true;
      _animals = [];
    });

    try {
      final result = await _repository.searchAnimals(_searchController.text.trim());
      setState(() {
        _animals = result;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openCart() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListenableBuilder(
          listenable: _cartService,
          builder: (context, child) {
            final items = _cartService.cartItems;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Корзина', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  if (items.isEmpty)
                    const Text('Корзина пуста')
                  else ...[
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) => ListTile(
                          leading: const Icon(Icons.pets),
                          title: Text(items[index].name),
                          subtitle: Text('Класс: ${items[index].className}'),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _cartService.clearCart();
                        Navigator.pop(context);
                      },
                      child: const Text('Очистить корзину', style: TextStyle(color: Colors.red)),
                    ),
                  ]
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zoo Shop (Поиск животных)'),
        actions: [
          // Кнопка корзины со счетчиком
          ListenableBuilder(
            listenable: _cartService,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: _openCart,
                  ),
                  if (_cartService.cartCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '${_cartService.cartCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Введите название (Lion, Dog...)',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _searchAnimal(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _isLoading ? null : _searchAnimal,
                  icon: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_animals.isEmpty && !_isLoading)
              const Expanded(
                child: Center(child: Text('Введите название животного для поиска')),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _animals.length,
                  itemBuilder: (context, index) {
                    final animal = _animals[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.pets, color: Colors.white),
                        ),
                        title: Text(animal.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Класс: ${animal.className}\nРацион: ${animal.diet}\nМеста: ${animal.location}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_shopping_cart, color: Colors.blue),
                          onPressed: () {
                            _cartService.addToCart(animal);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${animal.name} добавлен в корзину!'), duration: const Duration(seconds: 1)),
                            );
                          },
                        ),
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