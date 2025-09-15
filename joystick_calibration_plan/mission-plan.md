# Mission Plan: Joystick Calibration and Settings Integration

This document outlines the plan for modifying the QGroundControl joystick calibration code and integrating the functionality of the `qgc_common_settings_update_linux.py` script directly into the application's C++ code and build process.

## 1. Structural Analysis of Joystick Calibration Code

The joystick calibration and management system in QGroundControl has a clear, three-tiered structure:

```
JoystickManager
├── Manages the lifecycle of all joysticks.
├── Discovers available joysticks using platform-specific code.
├── Handles the concept of an "active" joystick.
├── Uses QSettings to store the name of the active joystick.
└── Instantiates Joystick objects.

    └── Joystick (Base Class)
        ├── Defines the core interface for a joystick.
        ├── Manages all calibration data (axis min/max/center, deadbands, etc.).
        ├── Implements the logic for loading and saving all joystick settings via QSettings.
            └── This is the class that reads/writes the [Joysticks] section of the .ini file.
        ├── Contains the _setDefaultCalibration() method, which is the key entry point for this project.
        ├── Handles button action assignments.
        └── Is inherited by platform-specific implementations.

            └── JoystickSDL (for Linux/Windows/macOS)
                ├── Inherits from Joystick.
                ├── Implements the hardware abstraction layer using the SDL library.
                ├── Discovers and opens specific joystick devices.
                ├── Reads raw axis and button values from the hardware.
                ├── Contains a mechanism to load default controller mappings from a resource file (gamecontrollerdb.txt).
```

## 2. Action Plan: Integrating the Python Script

The `qgc_common_settings_update_linux.py` script will be made obsolete by integrating its functionality directly into the QGroundControl application. This will be done in two parts:

### A. Joystick Configuration

The goal is to have the "Turtle Beach VelocityOne Flightstick" configured automatically with the correct settings when it is first connected.

**To-Do List:**

1.  **Modify `Joystick::_setDefaultCalibration()` in `src/Joystick/Joystick.cc`:**
    *   Add a conditional check at the beginning of the method: `if (_name == "Turtle Beach VelocityOne Flightstick")`.
2.  **Implement the Turtle Beach specific settings:**
    *   Inside the `if` block, programmatically apply all the settings from the Python script. This will involve:
        *   Setting the calibration for each of the 8 axes using `setCalibration()`. The values for `min`, `max`, `center`, `deadband`, and `reversed` will be taken directly from the script's hardcoded settings.
        *   Assigning functions to axes (Roll, Pitch, Yaw, Throttle, etc.) using `setFunctionAxis()`.
        *   Assigning actions to buttons (e.g., "Focus Far", "Start Recording Video") using `setButtonAction()`.
        *   Setting the repeat property for buttons that need it using `setButtonRepeat()`.
        *   Setting miscellaneous properties like `setThrottleMode()`, `setNegativeThrust()`, `setExponential()`, etc.
3.  **Persist the new default settings:**
    *   After all the default settings have been applied, make a call to `_saveSettings()` to write this new default configuration to the `QGroundControl.ini` file. This will ensure the settings are loaded automatically on subsequent application runs.
4.  **Mark as calibrated:**
    *   Ensure the `_calibrated` flag is set to `true` and saved, so this default setup is only applied once.

### B. Branding Image Configuration

The goal is to have the custom branding images loaded by default without needing to download them.

**To-Do List:**

1.  **Add images to resources:**
    *   Download the `Normal-horizental-smallRes.png` and `White-horizental-smallRes.png` images.
    *   Create a new directory, `resources/branding/`.
    *   Add the downloaded images to this new directory.
    *   Add the new images to a `.qrc` resource file so they are compiled into the application binary. `qgcresources.qrc` is a likely candidate.
2.  **Update default settings in C++:**
    *   Use `grep` to find where the `userBrandImageIndoor` and `userBrandImageOutdoor` settings are read in the C++ source code. This is likely in a settings management or application initialization class.
    *   Modify the code to use the new Qt resource paths (e.g., `:/branding/Normal-horizental-smallRes.png`) as the *default value* when reading these settings from `QSettings`. This way, if the user hasn't specified a custom image, the application will fall back to the compiled-in resource.

## 3. Plan for CMake Integration

The term "CMake integration" in the original request is best interpreted as "making the changes within the C++ codebase that is built by CMake", thereby eliminating the need for any post-build Python scripts. The plan above achieves this.

*   The joystick configuration changes are made in the C++ source code (`.cc` files). CMake will compile this code into the final application. No changes to the `CMakeLists.txt` files themselves are necessary for this part.
*   The branding image changes involve adding new files to the resources (`.qrc`). This will require a small modification to the `CMakeLists.txt` file that handles the resource compilation (`src/CMakeLists.txt` or a similar file) to ensure the new images are included in the build.

By implementing the changes outlined above, the entire functionality of the Python script will be handled automatically by the QGroundControl application, providing a much cleaner and more robust user experience.
