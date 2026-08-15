# CPU Temperature — Omarchy Status Bar Widget

A lightweight, native [Omarchy](https://omarchy.org/) status bar widget that displays real-time CPU hardware temperatures with dynamic thermometer icons, multi-tier thermal color alerts, and quick access to system hardware monitors.

---

## ✨ Features

- **⚡ Native Sensor Polling:** Reads directly from `/sys/class/hwmon` and `/sys/class/thermal` without third-party background daemons.
- **🎯 Broad Hardware Support:** Automatically detects CPU thermal sensors across Intel (`coretemp`), AMD (`k10temp`/`zenpower`), ARM/SBCs (`cpu_thermal`), and ACPI thermal zones.
- **🌡️ Dynamic Thermometer Glyphs:**
  - `` *(< 50°C)* — Low / Idle
  - `` *(50°C – 74°C)* — Normal
  - `` *(75°C – Warning Threshold)* — Warm
  - `` *(≥ Critical Threshold)* — High / Hot
- **🎨 Color-Coded Thermal Tiers:**
  - **Normal (`< Warning Threshold`):** Matches active desktop theme colors.
  - **Warning (`Warning Threshold – Critical Threshold`):** **Orange** (`#ff9900`) alert.
  - **Critical (`≥ Critical Threshold`):** **Red** (`#ff5555` / `Color.urgent`) alert.
- **🖥️ One-Click Hardware Monitor:** Left-clicking the widget immediately launches the interactive hardware monitor (`btop`) via `omarchy-launch-or-focus-tui`.
- **🔌 Shell IPC Integration:** Query live temperature or trigger instant refreshes from scripts and hotkeys via `omarchy-shell`.
- **⚙️ Fully Configurable:** Customize refresh interval and temperature thresholds directly from your bar configuration.

---

## 🚀 Installation & Configuration

### Enable in `~/.config/omarchy/shell.json`

Add `omarchy.temperature` to your preferred bar layout section (`left`, `center`, or `right`):

```json
{
  "bar": {
    "layout": {
      "right": [
        {
          "id": "omarchy.temperature",
          "refreshIntervalSec": 5,
          "warningThreshold": 85,
          "criticalThreshold": 90
        }
      ]
    }
  }
}
```

Or move it via the Omarchy CLI:

```bash
omarchy bar move omarchy.temperature --section right
```

---

## ⚙️ Settings Schema

| Key | Type | Default | Range | Description |
| :--- | :--- | :--- | :--- | :--- |
| `refreshIntervalSec` | `integer` | `5` | `1 – 60` | Polling frequency in seconds. |
| `warningThreshold` | `integer` | `85` | `50 – 100` | Warning temperature (°C) for orange alert. |
| `criticalThreshold` | `integer` | `90` | `60 – 115` | Critical temperature (°C) for red/urgent alert. |

---

## ⌨️ Shell IPC Commands

```bash
# Trigger an immediate sensor refresh
omarchy-shell omarchy.temperature refresh

# Check status / current temperature
omarchy-shell omarchy.temperature status
```

---

## 📁 File Structure

```
omarchy-temperature-plugin/
├── BarWidget.qml    # QML widget UI, sensor polling loop & IPC handler
├── manifest.json    # Omarchy plugin manifest and settings schema
├── README.md        # Documentation and usage guide
└── LICENSE          # MIT License
```

---

## 📄 License

MIT — see [LICENSE](LICENSE).
