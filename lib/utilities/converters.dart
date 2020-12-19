double kelvinToCelsius(double kelvin) => kelvin - 273.5;
double kelvinToFahrenheit(double kelvin) =>
    kelvinToCelsius(kelvin) * 1.8 + 32.0;
