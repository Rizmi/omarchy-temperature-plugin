# CPU Temperature — Omarchy Bar Widget

A lightweight, modern, and native [Omarchy](https://omarchy.org/) status bar widget to monitor real-time CPU hardware temperatures and thermal status directly from your desktop bar.

---

## Requirements & Prerequisites

Before installing the widget, ensure your system has:

1. **Omarchy Linux** with Quickshell status bar (`omarchy plugin` / `omarchy bar` CLI available).
2. **Linux Kernel Thermal Sensors** (`/sys/class/hwmon` or `/sys/class/thermal` supported by Intel, AMD, ARM, and ACPI).
3. **Nerd Font** (standard on Omarchy, used for dynamic thermometer glyphs).
4. **`btop`** (standard on Omarchy, launched when clicking the widget for interactive monitoring).

---

<p align="center">
  <img width="195" height="66" alt="CPU Temperature Normal" src="https://imglink.cc/cdn/D-9NzwP-Tu.png" />
  &nbsp;&nbsp;
  <img width="195" height="66" alt="CPU Temperature Status" src="https://imglink.cc/cdn/kCHm7G81ey.png" />
</p>

---

## Installation

### Option 1: Using `omarchy plugin` (Recommended)

```bash
omarchy plugin add https://github.com/Rizmi/omarchy-temperature-plugin.git --enable
```

### Option 2: Manual Installation

1. Clone the repository into your Omarchy plugins directory:
   ```bash
   git clone https://github.com/Rizmi/omarchy-temperature-plugin.git \
     ~/.config/omarchy/plugins/io.github.rizmi.temperature
   ```

2. Validate and enable the plugin on your status bar:
   ```bash
   omarchy plugin validate ~/.config/omarchy/plugins/io.github.rizmi.temperature
   omarchy plugin enable io.github.rizmi.temperature --section right
   ```

---

## Removal

```bash
omarchy plugin disable io.github.rizmi.temperature
rm -rf ~/.config/omarchy/plugins/io.github.rizmi.temperature
omarchy-shell shell rescanPlugins
```

---

## Configuration & Settings

### Enable in `~/.config/omarchy/shell.json`

Add `io.github.rizmi.temperature` to your preferred bar layout section (`left`, `center`, or `right`):

```json
{
  "bar": {
    "layout": {
      "right": [
        {
          "id": "io.github.rizmi.temperature",
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
omarchy bar move io.github.rizmi.temperature --section right
```

---

### Settings Reference

| Field | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `refreshIntervalSec` | integer | `5` | Polling frequency in seconds (`1 – 60`). |
| `warningThreshold` | integer | `85` | Warning temperature (°C) triggering orange alert (`40 – 105`). |
| `criticalThreshold` | integer | `90` | Critical temperature (°C) triggering red/urgent alert (`50 – 115`). |

---

## Dynamic Thermal Indicators

| Glyph | Thermal Range | State | Alert Color |
| :---: | :--- | :--- | :--- |
| `` | `< 45°C` | Cool / Idle | Theme Foreground |
| `` | `45°C – 59°C` | Low / Mild | Theme Foreground |
| `` | `60°C – < Warning` | Normal | Theme Foreground |
| `` | `Warning – < Critical` | Elevated / High | **Orange** (`#ff9900`) |
| `` | `≥ Critical` | Critical | **Red** (`#ff5555` / `Color.urgent`) |

---

## Usage

* **Left-click** bar widget: Launch or focus `btop` interactive hardware monitor (`omarchy-launch-or-focus-tui btop`).
* **Hover** bar widget: Display tooltip with live temperature and thermal alert state (`[HIGH TEMP]`, `[CRITICAL TEMP]`).

---

## Shell IPC Commands

```bash
# Trigger an immediate sensor refresh
omarchy-shell io.github.rizmi.temperature refresh

# Check status / formatted temperature text
omarchy-shell io.github.rizmi.temperature status
```

---

## File Structure

```
~/.config/omarchy/plugins/io.github.rizmi.temperature/
├── BarWidget.qml    # QML widget UI, sensor loop & IPC handler
├── manifest.json    # Omarchy plugin manifest and settings schema
├── README.md        # Documentation and usage guide
└── LICENSE          # MIT License
```

---

## License

MIT — see [LICENSE](LICENSE).
