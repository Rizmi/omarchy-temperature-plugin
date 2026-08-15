import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "io.github.rizmi.temperature"

  property var settings: ({})

  function setting(name, fallback) {
    var value = settings ? settings[name] : undefined
    return value === undefined || value === null ? fallback : value
  }

  function intSetting(name, fallback, min, max) {
    var n = parseInt(String(setting(name, fallback)), 10)
    if (!isFinite(n)) n = fallback
    if (n < min) n = min
    if (n > max) n = max
    return n
  }

  readonly property int refreshIntervalSec: intSetting("refreshIntervalSec", 5, 1, 60)
  readonly property int warningThreshold: intSetting("warningThreshold", 85, 40, 105)
  readonly property int criticalThreshold: intSetting("criticalThreshold", 90, 50, 115)

  property int temperature: 0
  property string tempText: "--°C"
  property string tempIcon: "\uf2c9"

  readonly property bool isCritical: temperature >= criticalThreshold
  readonly property bool isWarning: temperature >= warningThreshold && temperature < criticalThreshold

  function updateTemp(output) {
    var raw = String(output || "").trim()
    var val = parseInt(raw, 10)
    if (!isNaN(val) && val > 0) {
      root.temperature = val
      root.tempText = val + "°C"
      if (val >= root.criticalThreshold) {
        root.tempIcon = "\uf2c7" // thermometer-full
      } else if (val >= root.warningThreshold) {
        root.tempIcon = "\uf2c8" // thermometer-three-quarters
      } else if (val >= 60) {
        root.tempIcon = "\uf2c9" // thermometer-half
      } else if (val >= 45) {
        root.tempIcon = "\uf2ca" // thermometer-quarter
      } else {
        root.tempIcon = "\uf2cb" // thermometer-empty
      }
    }
  }

  function fetchTemp() {
    if (!tempProc.running) {
      tempProc.running = true
    }
  }

  function openMonitor() {
    if (root.bar) {
      root.bar.run("omarchy-launch-or-focus-tui btop")
    }
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Process {
    id: tempProc
    running: false
    command: [
      "bash",
      "-c",
      "for h in /sys/class/hwmon/hwmon*; do n=$(cat $h/name 2>/dev/null); if [[ $n =~ (coretemp|k10temp|zenpower|cpu_thermal) && -f $h/temp1_input ]]; then echo $(( $(cat $h/temp1_input) / 1000 )); exit 0; fi; done; for h in /sys/class/hwmon/hwmon*; do n=$(cat $h/name 2>/dev/null); if [[ $n =~ (acpitz) && -f $h/temp1_input ]]; then echo $(( $(cat $h/temp1_input) / 1000 )); exit 0; fi; done; for t in /sys/class/thermal/thermal_zone*; do ty=$(cat $t/type 2>/dev/null); if [[ $ty =~ (x86_pkg_temp|coretemp|k10temp|cpu_thermal|TCPU|acpitz) ]]; then echo $(( $(cat $t/temp 2>/dev/null) / 1000 )); exit 0; fi; done"
    ]

    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.updateTemp(text)
    }
  }

  Timer {
    interval: root.refreshIntervalSec * 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.fetchTemp()
  }

  IpcHandler {
    target: "io.github.rizmi.temperature"
    function refresh(): void { root.fetchTemp() }
    function status(): string { return root.tempText }
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.tempIcon + " " + root.tempText
    foreground: root.isCritical
      ? (root.bar && root.bar.urgent ? root.bar.urgent : "#ff5555")
      : (root.isWarning ? "#ff9900" : (root.bar ? root.bar.barForeground : Color.foreground))
    tooltipText: "CPU Temperature: " + root.tempText + (root.isCritical ? " [CRITICAL TEMP]" : (root.isWarning ? " [HIGH TEMP]" : ""))
    onPressed: root.openMonitor()
  }
}
