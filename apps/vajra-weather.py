#!/usr/bin/env python3
"""Vajra OS Weather App - Indian cities weather with ISD data."""
import urllib.request, json, datetime

INDIAN_CITIES = {
    "Delhi": 1273294, "Mumbai": 1275339, "Bangalore": 1277333,
    "Chennai": 1264527, "Kolkata": 1275004, "Hyderabad": 1269823,
    "Pune": 1259229, "Ahmedabad": 1279233, "Jaipur": 1269515,
    "Lucknow": 1264733, "Kochi": 1268895, "Goa": 1271004,
    "Varanasi": 1253610, "Shimla": 1256208, "Guwahati": 1270770,
}

def fetch_weather(city_id):
    try:
        url = f"http://wttr.in/{city_id}?format=j1"
        req = urllib.request.Request(url, headers={"User-Agent": "VajraOS/1.0"})
        with urllib.request.urlopen(req, timeout=10) as r:
            data = json.loads(r.read())
        current = data.get("current_condition", [{}])[0]
        return {
            "temp": current.get("temp_C", "N/A"),
            "feels": current.get("FeelsLikeC", "N/A"),
            "humidity": current.get("humidity", "N/A"),
            "desc": current.get("weatherDesc", [{}])[0].get("value", "N/A"),
            "wind": current.get("windspeedKmph", "N/A"),
        }
    except Exception:
        return None

def main():
    print("=" * 50)
    print("  Vajra OS Weather")
    print("=" * 50)
    print()
    for i, city in enumerate(INDIAN_CITIES, 1):
        print(f"  {i:2d}. {city}")
    choice = input(f"\n  Select city [1]: ").strip() or "1"
    cities = list(INDIAN_CITIES.keys())
    idx = int(choice) - 1 if choice.isdigit() and 1 <= int(choice) <= len(cities) else 0
    city = cities[idx]
    print(f"\n  Fetching weather for {city}...")
    w = fetch_weather(INDIAN_CITIES[city])
    if w:
        print(f"  Temperature: {w['temp']}C (Feels like {w['feels']}C)")
        print(f"  Condition:   {w['desc']}")
        print(f"  Humidity:    {w['humidity']}%")
        print(f"  Wind:        {w['wind']} km/h")
    else:
        print("  Could not fetch weather. Check internet connection.")

if __name__ == "__main__":
    main()