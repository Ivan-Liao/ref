"""
Creates 3 text files on desktop that updates every hour
1. min_weather.txt shows minutely forecast for the next hour
2. hour_weather.txt shows hourly forecast for next 4 days
3. day_weather.txt shows daily forecast for next 16 days
"""
import json
import requests
import sys
import os
import pendulum

APPID = "*"
LAT = '38.795300'
LONG = '-77.639680'
UNITS = 'imperial'
HOMEDIR = 'C:\\Users\\Festi\\Desktop'

def create_weather_files():
    url = 'https://api.openweathermap.org/data/2.5/onecall?lat={LAT}&lon={LONG}&units={units}&appid={APPID}'
    response = requests.get(url)
    data = json.loads(response.text)
    print(data)
    with open(os.path.join(HOMEDIR, 'min_weather.txt'), 'w') as f:
        for row in data['current']['minutely']:
            f.writelines('mm of precipitation: ' + str(row['precipitation']) + '\r\n')
        f.writelines('\r\n' + row['alerts']['description'])
    with open(os.path.join(HOMEDIR, 'hour_weather.txt'), 'w') as f:
        f.writelines('Datetime'.rjust(20) + "|" + 
            ('Temperature (F)').rjust(20) + "|" + 
            ('Feels like (F)').rjust(20) + "|" + 
            ('Wind speed (mph)').rjust(20) + "|" + 
            ('Wind gust (mph)').rjust(20) + "|" + 
            ('Description').rjust(50) + 
            '\r\n')
        for row in data['current']['hourly']:
            dt = pendulum.from_timestamp(row['dt'], tz='America/New_York')
            f.writelines((str(dt.month) + '/' + str(dt.day) + ' ' + str(dt.hour) + ':' + str(dt.minute)).rjust(20) + "|" + 
                ('mm of precipitation: ' + str(row['temp'])).rjust(20) + "|" + 
                ('mm of precipitation: ' + str(row['feels_like'])).rjust(20) + "|" + 
                ('mm of precipitation: ' + str(row['wind_speed'])).rjust(20) + "|" + 
                ('mm of precipitation: ' + str(row['wind_gust'])).rjust(20) + "|" + 
                ('mm of precipitation: ' + str(row['weather']['description'])).rjust(50) + 
                '\r\n')
    with open(os.path.join(HOMEDIR, 'day_weather.txt'), 'w') as f:
        f.writelines('Datetime'.rjust(20) + "|" + 
            ('Min Temperature (F)').rjust(20) + "|" + 
            ('Max Temperature (F)').rjust(20) + "|" + 
            ('Wind speed (mph)').rjust(20) + "|" + 
            ('Precipitation (mm)').rjust(20) + "|" + 
            ('Description').rjust(50) + 
            '\r\n')
        for row in data['current']['daily']:
            dt = pendulum.from_timestamp(row['dt'], tz='America/New_York')
            f.writelines((str(dt.month) + '/' + str(dt.day)).rjust(20) + "|" + 
                ('mm of precipitation: ' + str(row['temp']['min'])).rjust(20) + "|" + 
                ('mm of precipitation: ' + str(row['temp']['max'])).rjust(20) + "|" + 
                ('mm of precipitation: ' + str(row['wind_speed'])).rjust(20) + "|" + 
                ('mm of precipitation: ' + str(row['rain'])).rjust(20) + "|" + 
                ('mm of precipitation: ' + str(row['weather']['description'])).rjust(50) + 
                '\r\n')
    


def main():
    create_weather_files()

if __name__ == "__main__":
    main()