import configparser
import os
from pathlib import Path
import sys

import requests
from urllib.parse import urlparse


################### IMAGES #####################

# 🔧 List of GitHub raw image URLs
image_urls = [
    "https://raw.githubusercontent.com/DroneLeaf/Assets/refs/heads/main/Normal-horizental-smallRes.png",
    "https://raw.githubusercontent.com/DroneLeaf/Assets/refs/heads/main/White-horizental-smallRes.png"
]

def download_droneleaf_images_for_qgc():
    # 📂 Config path setup
    home = os.path.expanduser("~")
    config_dir = os.path.join(home, ".config", "QGroundControl.org")
    ini_path = os.path.join(config_dir, "QGroundControl.ini")

    # 🛡️ Validate paths
    if not os.path.isdir(config_dir):
        print(f"❌ Folder not found: {config_dir}")
        exit(1)
    if not os.path.isfile(ini_path):
        print(f"❌ INI file not found: {ini_path}")
        exit(1)

    # 📥 Download images and identify which is White/Normal
    indoor_image_path = None
    outdoor_image_path = None

    for url in image_urls:
        filename = os.path.basename(urlparse(url).path)
        full_path = os.path.join(config_dir, filename)

        try:
            response = requests.get(url)
            if response.status_code == 200:
                with open(full_path, "wb") as f:
                    f.write(response.content)
                print(f"✅ Downloaded: {filename}")

                if "White" in filename:
                    indoor_image_path = f"file:///{full_path}"
                elif "Normal" in filename:
                    outdoor_image_path = f"file:///{full_path}"
            else:
                print(f"❌ Failed to download {url} (status code {response.status_code})")
        except Exception as e:
            print(f"⚠️ Error downloading {url}: {e}")

    # ✅ Ensure both images are set
    if not indoor_image_path or not outdoor_image_path:
        print("❌ Missing required 'White' or 'Normal' image.")
        exit(1)

    # 🛠️ Update INI file in [Branding] section
    with open(ini_path, "r") as f:
        lines = f.readlines()

    new_lines = []
    in_branding = False
    indoor_set = False
    outdoor_set = False

    for line in lines:
        stripped = line.strip()
        if stripped.startswith("[") and stripped.endswith("]"):
            # Leaving the Branding section
            if in_branding and not (indoor_set and outdoor_set):
                if not indoor_set:
                    new_lines.append(f"userBrandImageIndoor={indoor_image_path}\n")
                if not outdoor_set:
                    new_lines.append(f"userBrandImageOutdoor={outdoor_image_path}\n")
            in_branding = stripped == "[Branding]"

        if in_branding:
            if stripped.startswith("userBrandImageIndoor"):
                line = f"userBrandImageIndoor={indoor_image_path}\n"
                indoor_set = True
            elif stripped.startswith("userBrandImageOutdoor"):
                line = f"userBrandImageOutdoor={outdoor_image_path}\n"
                outdoor_set = True

        new_lines.append(line)

    # Handle missing [Branding] section
    if not any("[Branding]" in l for l in lines):
        new_lines.append("\n[Branding]\n")
        new_lines.append(f"userBrandImageIndoor={indoor_image_path}\n")
        new_lines.append(f"userBrandImageOutdoor={outdoor_image_path}\n")
    elif in_branding and not (indoor_set and outdoor_set):
        if not indoor_set:
            new_lines.append(f"userBrandImageIndoor={indoor_image_path}\n")
        if not outdoor_set:
            new_lines.append(f"userBrandImageOutdoor={outdoor_image_path}\n")

    # 💾 Save updated INI file
    with open(ini_path, "w") as f:
        f.writelines(new_lines)

    print("✅ QGroundControl.ini updated successfully.")


################### JOYSTICK #####################
def clean_joysticks_section(ini_path):
    config = configparser.ConfigParser(strict=False)
    config.optionxform = str  # preserve case sensitivity
    config.read(ini_path)

    if 'Joysticks' in config:
        keys_to_remove = [k for k in config['Joysticks'] if k.startswith('Turtle%20Beach%20VelocityOne%20Flightstick')]
        for key in keys_to_remove:
            print(f"Removing entry: {key}")
            del config['Joysticks'][key]

        with open(ini_path, 'w') as configfile:
            config.write(configfile)
        print(f"Cleaned {len(keys_to_remove)} entries from [Joysticks] in {ini_path}")
    else:
        print("No [Joysticks] section found in the .ini file.")


def insert_under_joysticks(ini_path, raw_entries):
    """Inserts raw joystick entries directly under [Joysticks] section."""
    with open(ini_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    output_lines = []
    inserted = False

    for i, line in enumerate(lines):
        output_lines.append(line)

        if not inserted and line.strip() == "[Joysticks]":
            # Insert raw entries on the next line
            output_lines.append(raw_entries)
            inserted = True

    if not inserted:
        print("[Joysticks] section not found. Adding section.")
        output_lines.append("[Joysticks]\n")
        output_lines.append(raw_entries)

    with open(ini_path, 'w', encoding='utf-8') as f:
        f.writelines(output_lines)

    print("Inserted new joystick entries under [Joysticks].")

def wait_for_keypress():
    print("Press any key to exit...")
    try:
        # Windows
        import msvcrt
        msvcrt.getch()
    except ImportError:
        # Unix/Linux/macOS
        import termios
        import tty
        tty.setcbreak(sys.stdin.fileno())
        sys.stdin.read(1)

if __name__ == "__main__":
    print("Starting QGC settings update tool...")
    ini_file_path = Path.home() / ".config" / "QGroundControl.org" / "QGroundControl.ini"

    if ini_file_path.is_file():
        print(f"Opening QGC Settings File: {ini_file_path}")
        clean_joysticks_section(str(ini_file_path))
        print("Updatign Turtle Beach VelocityOne Settings...")
        raw_joystick_entries = r"""
Turtle%20Beach%20VelocityOne%20Flightstick\Accumulator=false
Turtle%20Beach%20VelocityOne%20Flightstick\Axis0Deadbnd=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis0Max=32767
Turtle%20Beach%20VelocityOne%20Flightstick\Axis0Min=-32768
Turtle%20Beach%20VelocityOne%20Flightstick\Axis0Rev=false
Turtle%20Beach%20VelocityOne%20Flightstick\Axis0Trim=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis1Deadbnd=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis1Max=32767
Turtle%20Beach%20VelocityOne%20Flightstick\Axis1Min=-32768
Turtle%20Beach%20VelocityOne%20Flightstick\Axis1Rev=true
Turtle%20Beach%20VelocityOne%20Flightstick\Axis1Trim=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis2Deadbnd=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis2Max=32767
Turtle%20Beach%20VelocityOne%20Flightstick\Axis2Min=-32768
Turtle%20Beach%20VelocityOne%20Flightstick\Axis2Rev=false
Turtle%20Beach%20VelocityOne%20Flightstick\Axis2Trim=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis3Deadbnd=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis3Max=32767
Turtle%20Beach%20VelocityOne%20Flightstick\Axis3Min=-32768
Turtle%20Beach%20VelocityOne%20Flightstick\Axis3Rev=false
Turtle%20Beach%20VelocityOne%20Flightstick\Axis3Trim=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis4Deadbnd=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis4Max=32767
Turtle%20Beach%20VelocityOne%20Flightstick\Axis4Min=-32768
Turtle%20Beach%20VelocityOne%20Flightstick\Axis4Rev=true
Turtle%20Beach%20VelocityOne%20Flightstick\Axis4Trim=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis5Deadbnd=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis5Max=32767
Turtle%20Beach%20VelocityOne%20Flightstick\Axis5Min=-32768
Turtle%20Beach%20VelocityOne%20Flightstick\Axis5Rev=false
Turtle%20Beach%20VelocityOne%20Flightstick\Axis5Trim=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis6Deadbnd=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis6Max=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis6Min=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis6Rev=false
Turtle%20Beach%20VelocityOne%20Flightstick\Axis6Trim=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis7Deadbnd=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis7Max=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis7Min=0
Turtle%20Beach%20VelocityOne%20Flightstick\Axis7Rev=false
Turtle%20Beach%20VelocityOne%20Flightstick\Axis7Trim=0
Turtle%20Beach%20VelocityOne%20Flightstick\AxisFrequency=@Variant(\0\0\0\x87\x41\xc8\0\0)
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonActionName12=Focus Far
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonActionName13=Focus Near
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonActionName14=Auto Focus
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonActionName15=Start Recording Video
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonActionName16=Stop Recording Video
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonActionName17=Trigger Camera
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonActionName18=Gimbal Center
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonActionName24=Continuous Zoom In
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonActionName25=Continuous Zoom Out
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonActionRepeat12=true
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonActionRepeat13=true
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonActionRepeat14=false
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonActionRepeat15=false
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonActionRepeat16=false
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonActionRepeat17=false
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonActionRepeat18=false
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonActionRepeat24=true
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonActionRepeat25=true
Turtle%20Beach%20VelocityOne%20Flightstick\ButtonFrequency=@Variant(\0\0\0\x87\x41\xc8\0\0)
Turtle%20Beach%20VelocityOne%20Flightstick\Calibrated4=true
Turtle%20Beach%20VelocityOne%20Flightstick\Circle_Correction=false
Turtle%20Beach%20VelocityOne%20Flightstick\Deadband=false
Turtle%20Beach%20VelocityOne%20Flightstick\Exponential=@Variant(\0\0\0\x87\0\0\0\0)
Turtle%20Beach%20VelocityOne%20Flightstick\GimbalPitchAxis=4
Turtle%20Beach%20VelocityOne%20Flightstick\GimbalPitchGain=13.0
Turtle%20Beach%20VelocityOne%20Flightstick\GimbalYawAxis=3
Turtle%20Beach%20VelocityOne%20Flightstick\GimbalYawGain=13.0
Turtle%20Beach%20VelocityOne%20Flightstick\NegativeThrust=false
Turtle%20Beach%20VelocityOne%20Flightstick\PitchAxis=1
Turtle%20Beach%20VelocityOne%20Flightstick\RollAxis=0
Turtle%20Beach%20VelocityOne%20Flightstick\ThrottleAxis=5
Turtle%20Beach%20VelocityOne%20Flightstick\ThrottleMode=1
Turtle%20Beach%20VelocityOne%20Flightstick\YawAxis=2
"""
        insert_under_joysticks(str(ini_file_path), raw_joystick_entries)
    else:
        print(f"File not found: {ini_file_path}")

    download_droneleaf_images_for_qgc()

    wait_for_keypress()

