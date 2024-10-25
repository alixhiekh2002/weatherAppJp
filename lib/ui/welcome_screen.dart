import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/models/weather_services.dart';
import 'package:weatherapp/services/services.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  TextEditingController textEditingController =
      TextEditingController(text: "karachi");
  late WeatherData weatherInfo;
  bool isLoading = false;
  void myWeather(String city) async {
    isLoading = true;
    setState(() {});
    try {
      WeatherData? weatherData = await WeatherServices().fetchWeather(city);
      if (weatherData != null) {
        setState(() {
          weatherInfo = weatherData;
        });
      } else {
        // Handle no data received
        // Show error message to user
      }
    } catch (error) {
      // Handle API call error
      // Show error message to user
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    weatherInfo = WeatherData(
      name: '',
      temperature: Temperature(current: 0.0),
      humidity: 0,
      wind: Wind(speed: 0),
      maxTemperature: 0,
      minTemperature: 0,
      pressure: 0,
      seaLevel: 0,
      weather: [],
    );
    isLoading = false;
    WeatherServices().fetchWeather(textEditingController.text).then((value) {
      setState(() {
        weatherInfo = value;
        isLoading = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('EEEE d, MMMM yyyy').format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    return Scaffold(
      backgroundColor: const Color(0xFF676BD0),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: WeatherDetail(
                onTap: () {
                  myWeather(textEditingController.text);
                },
                controller: textEditingController,
                weather: weatherInfo,
                formattedDate: formattedDate,
                formattedTime: formattedTime,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherDetail extends StatelessWidget {
  final TextEditingController controller;
  final Function() onTap;
  final WeatherData weather;
  final String formattedDate;
  final String formattedTime;
  const WeatherDetail({
    super.key,
    required this.weather,
    required this.formattedDate,
    required this.formattedTime,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
        ),

        ElevatedButton(
          onPressed: onTap,
          child: Text("Temp"),
        ),
        // for current address name
        Text(
          weather.name,
          style: const TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // for current temperature of my location
        Text(
          "${weather.temperature.current.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // fpr weather condition
        if (weather.weather.isNotEmpty) //
          Text(
            weather.weather[0].main,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        // const SizedBox(height: 30),
        // for current date and time
        Text(
          formattedDate,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          formattedTime,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // const SizedBox(height: 30),
        if (weather.temperature.current > 25)
          Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/clear.png"),
              ),
            ),
          ),
        if (weather.temperature.current < 25 &&
            weather.temperature.current > 15)
          Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/heavycloud.png"),
              ),
            ),
          ),
        if (weather.temperature.current < 15)
          Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/heavyrain.png"),
              ),
            ),
          ),
        const SizedBox(height: 30),
        // for more weather detail
        Container(
          height: 290,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          height: 40,
                          width: 40,
                          image: AssetImage("assets/windspeed.png"),
                        ),
                        const SizedBox(height: 5),
                        weatherInfoCard(
                            title: "Wind", value: "${weather.wind.speed}km/h"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          height: 45,
                          width: 45,
                          image: AssetImage("assets/max-temp.png"),
                        ),
                        const SizedBox(height: 5),
                        weatherInfoCard(
                            title: "Max",
                            value:
                                "${weather.maxTemperature.toStringAsFixed(2)}°C"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          height: 45,
                          width: 45,
                          image: AssetImage("assets/sleet.png"),
                        ),
                        const SizedBox(height: 5),
                        weatherInfoCard(
                            title: "Min",
                            value:
                                "${weather.minTemperature.toStringAsFixed(2)}°C"),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          height: 45,
                          width: 45,
                          image: AssetImage("assets/humidity.png"),
                        ),
                        const SizedBox(height: 5),
                        weatherInfoCard(
                            title: "Humidity", value: "${weather.humidity}%"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.air,
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 5),
                        weatherInfoCard(
                            title: "Pressure", value: "${weather.pressure}hPa"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.leaderboard,
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 5),
                        weatherInfoCard(
                            title: "Sea-Level", value: "${weather.seaLevel}m"),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column weatherInfoCard({required String title, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        )
      ],
    );
  }
}
