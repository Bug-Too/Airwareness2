import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/location_result.dart';
import '../data/services/weather_service.dart';
import '../providers/app_provider.dart';


class SearchScreen extends StatefulWidget {
  final bool isFirstRun;
  const SearchScreen({super.key, this.isFirstRun = false});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final WeatherService _service = WeatherService();
  final TextEditingController _controller = TextEditingController();
  List<LocationResult> _results = [];
  bool _isLoading = false;
  String? _error;

  void _search() async {
    if (_controller.text.isEmpty) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await _service.searchCity(_controller.text);
      setState(() {
        _results = results;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to find location. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Location'),
        automaticallyImplyLeading: !widget.isFirstRun,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter city name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _search,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          if (_isLoading)
            const LinearProgressIndicator(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final loc = _results[index];
                return ListTile(
                  title: Text(loc.name),
                  subtitle: Text(loc.country),
                  leading: const Icon(Icons.location_on_outlined),
                  onTap: () {
                    final provider = Provider.of<AppProvider>(context, listen: false);
                    provider.setLocation(loc);
                    
                    if (!widget.isFirstRun) {
                      Navigator.pop(context);
                    }
                    // If isFirstRun, MainWrapper detects location change and switches to Home automatically.
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
