import 'package:flutter/material.dart';
import 'api_service.dart';
import 'ReminderScreen.dart';

class HealthScreen extends StatefulWidget {
  @override
  _HealthScreenState createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  Future<List<Map<String, dynamic>>>? _aqiData;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _aqiData = apiService.fetchMultipleCitiesAqiData([
      'warsaw', 'krakow', 'lodz', 'wroclaw', 'poznan', 'gdansk', 'szczecin',
      'bydgoszcz', 'lublin', 'bialystok', 'katowice', 'gorzow wielkopolski',
      'kielce', 'opole', 'rzeszow', 'olsztyn'
    ]);
  }

  Color getColorForAQI(int? aqi) {
    if (aqi == null) return Colors.grey;
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.yellow;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    if (aqi <= 300) return Colors.purple;
    return Colors.brown;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Indeks Jakości Powietrza'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            iconSize: 36.0,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReminderScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _aqiData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Błąd: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var cityDataList = snapshot.data;

            if (cityDataList == null || cityDataList.isEmpty) {
              return Center(child: Text('Brak danych'));
            }

            return ListView.builder(
              itemCount: cityDataList.length,
              itemBuilder: (context, index) {
                var data = cityDataList[index]['data'];

                if (data is String || data == null) {
                  return SizedBox.shrink(); 
                } else if (data is Map) {
                  var aqiStr = data?['aqi']?.toString() ?? '0';

                  if (!RegExp(r'^[0-9]+$').hasMatch(aqiStr)) {
                    return SizedBox.shrink(); 
                  }

                  int aqi = int.tryParse(aqiStr) ?? 0;

                  var city = data?['city']?['name'] != null ? data['city']['name'].toString() : 'Brak danych';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: getColorForAQI(aqi),
                      radius: 10,
                    ),
                    title: Text('Miasto: $city'),
                    subtitle: Text('AQI: $aqi'),
                  );
                } else {
                  return SizedBox.shrink(); 
                }
              },
            );
          } else {
            return Center(child: Text('Brak danych'));
          }
        },
      ),
    );
  }
}
