#!/usr/bin/env python3

import subprocess
import json
import sys
import time
import os
from pathlib import Path

try:
    from pyquery import PyQuery
except ImportError:
    print(json.dumps({
        "text": "⚠ Error",
        "tooltip": "pyquery not installed. Install with: pip install pyquery",
        "class": "error"
    }))
    sys.exit(0)

# Cache configuration
CACHE_FILE = "/tmp/weather_cache.json"
CACHE_DURATION = 600  # 10 minutes

# weather icons
weather_icons = {
    "sunnyDay": "滛",
    "clearNight": "望", 
    "cloudyFoggyDay": "",
    "cloudyFoggyNight": "",
    "rainyDay": "",
    "rainyNight": "",
    "snowyIcyDay": "",
    "snowyIcyNight": "",
    "severe": "",
    "default": "",
}

def get_cached_weather():
    """Get cached weather data if it's still valid."""
    try:
        if os.path.exists(CACHE_FILE):
            cache_time = os.path.getmtime(CACHE_FILE)
            if time.time() - cache_time < CACHE_DURATION:
                with open(CACHE_FILE, 'r') as f:
                    return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError, OSError):
        pass
    return None

def save_weather_cache(data):
    """Save weather data to cache."""
    try:
        with open(CACHE_FILE, 'w') as f:
            json.dump(data, f)
    except OSError:
        pass  # Ignore cache save errors

def fetch_weather_data():
    """Fetch fresh weather data from weather.com."""
    location_id = "a319796a4173829988d68c4e3a5f90c1b6832667ea7aaa201757a1c887ec667a"
    url = f"https://weather.com/en-IN/weather/today/l/{location_id}"
    
    try:
        html_data = PyQuery(url)
        
        # Extract weather data with error handling
        temp = html_data("span[data-testid='TemperatureValue']").eq(0).text()
        if not temp:
            raise ValueError("Temperature not found")
            
        status = html_data("div[data-testid='wxPhrase']").text()
        status = f"{status[:16]}.." if len(status) > 17 else status
        
        # Get status code safely
        header_class = html_data("#regionHeader").attr("class")
        if header_class:
            parts = header_class.split(" ")
            if len(parts) > 2:
                status_code = parts[2].split("-")[-1] if "-" in parts[2] else "default"
            else:
                status_code = "default"
        else:
            status_code = "default"
        
        # Get icon
        icon = weather_icons.get(status_code, weather_icons["default"])
        
        # Temperature feels like
        temp_feel = html_data("div[data-testid='FeelsLikeSection'] > span[data-testid='TemperatureValue']").text()
        temp_feel_text = f"Feels like {temp_feel}" if temp_feel else "N/A"
        
        # Min-max temperature
        temp_elements = html_data("div[data-testid='wxData'] > span[data-testid='TemperatureValue']")
        temp_min = temp_elements.eq(0).text() if temp_elements.length > 0 else "N/A"
        temp_max = temp_elements.eq(1).text() if temp_elements.length > 1 else "N/A"
        temp_min_max = f"  {temp_min}\t\t  {temp_max}"
        
        # Wind speed
        wind_element = html_data("span[data-testid='Wind']").text()
        wind_speed = wind_element.split("\n")[1] if "\n" in wind_element else wind_element
        wind_text = f"煮  {wind_speed}" if wind_speed else "煮  N/A"
        
        # Humidity
        humidity = html_data("span[data-testid='PercentageValue']").text()
        humidity_text = f"  {humidity}" if humidity else "  N/A"
        
        # Visibility
        visibility = html_data("span[data-testid='VisibilityValue']").text()
        visibility_text = f"  {visibility}" if visibility else "  N/A"
        
        # Air quality index
        air_quality_index = html_data("text[data-testid='DonutChartValue']").text()
        air_quality_index = air_quality_index if air_quality_index else "N/A"
        
        # Hourly rain prediction
        prediction_element = html_data("section[aria-label='Hourly Forecast'] div[data-testid='SegmentPrecipPercentage'] > span")
        prediction = prediction_element.text()
        if prediction:
            prediction = prediction.replace("Chance of Rain", "")
            prediction = f"\n\n    (hourly) {prediction}" if len(prediction) > 0 else ""
        else:
            prediction = ""
        
        # Tooltip text
        tooltip_text = str.format(
            "\t\t{}\t\t\n{}\n{}\n{}\n\n{}\n{}\n{}{}",
            f'<span size="xx-large">{temp}</span>',
            f"<big>{icon}</big>",
            f"<big>{status}</big>",
            f"<small>{temp_feel_text}</small>",
            f"<big>{temp_min_max}</big>",
            f"{wind_text}\t{humidity_text}",
            f"{visibility_text}\tAQI {air_quality_index}",
            f"<i>{prediction}</i>",
        )
        
        # Return structured data
        return {
            "text": f"{icon}   {temp}",
            "alt": status,
            "tooltip": tooltip_text,
            "class": status_code,
        }
        
    except Exception as e:
        return {
            "text": "⚠ Error",
            "tooltip": f"Failed to fetch weather: {str(e)}",
            "class": "error"
        }

def main():
    # Try to get cached data first
    cached_data = get_cached_weather()
    if cached_data:
        print(json.dumps(cached_data))
        return
    
    # Fetch fresh data
    weather_data = fetch_weather_data()
    
    # Save to cache if successful
    if weather_data.get("class") != "error":
        save_weather_cache(weather_data)
    
    print(json.dumps(weather_data))

if __name__ == "__main__":
    main()
