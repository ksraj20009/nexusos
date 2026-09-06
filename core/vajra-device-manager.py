#!/usr/bin/env python3
"""Vajra OS Device Manager — hardware detection, driver loading, device tree.
Like Windows Device Manager / Linux udev+lsmod+lspci+lsusb.
This is the fundamental device management layer of the OS."""
import os
import sys
import subprocess
from pathlib import Path

SYSFS_DIR = Path("/sys")
DEV_DIR = Path("/dev")

def show_pci_devices():
    """Show PCI devices — like lspci."""
    print("\n  --- PCI Devices ---")
    try:
        result = subprocess.run(["lspci"], capture_output=True, text=True, timeout=5)
        if result.stdout:
            for line in result.stdout.strip().split("\n"):
                print(f"  {line}")
        else:
            print("  lspci not available")
    except:
        # Fallback: read from sysfs
        bus_dir = Path("/sys/bus/pci/devices")
        if bus_dir.exists():
            for dev in sorted(bus_dir.iterdir()):
                try:
                    vendor = (dev / "vendor").read_text().strip()
                    device = (dev / "device").read_text().strip()
                    cls = (dev / "class").read_text().strip()
                    print(f"  {dev.name}  vendor={vendor} device={device} class={cls}")
                except:
                    pass
        else:
            print("  No PCI devices found")

def show_usb_devices():
    """Show USB devices — like lsusb."""
    print("\n  --- USB Devices ---")
    try:
        result = subprocess.run(["lsusb"], capture_output=True, text=True, timeout=5)
        if result.stdout:
            for line in result.stdout.strip().split("\n"):
                print(f"  {line}")
        else:
            print("  lsusb not available")
    except:
        bus_dir = Path("/sys/bus/usb/devices")
        if bus_dir.exists():
            for dev in sorted(bus_dir.iterdir()):
                if ":" not in dev.name:
                    continue
                try:
                    vendor = (dev / "idVendor").read_text().strip()
                    product = (dev / "idProduct").read_text().strip()
                    name = (dev / "product").read_text().strip() if (dev / "product").exists() else "Unknown"
                    print(f"  {dev.name}  {vendor}:{product}  {name}")
                except:
                    pass
        else:
            print("  No USB devices found")

def show_loaded_drivers():
    """Show loaded kernel modules/drivers — like lsmod."""
    print("\n  --- Loaded Kernel Modules (Drivers) ---")
    print(f"  {'Module':20s}  {'Size':>10s}  {'Used by'}")
    print("  " + "-" * 55)
    try:
        with open("/proc/modules") as f:
            for line in f:
                parts = line.split()
                if len(parts) >= 3:
                    print(f"  {parts[0]:20s}  {parts[1]:>10s}  {parts[2]}")
    except:
        print("  Cannot read /proc/modules")

def show_cpu_info():
    """Show CPU information — like lscpu."""
    print("\n  --- CPU Information ---")
    try:
        with open("/proc/cpuinfo") as f:
            cores = 0
            model = ""
            for line in f:
                if line.startswith("processor"):
                    cores += 1
                elif line.startswith("model name"):
                    model = line.split(":")[1].strip()
        print(f"  CPU: {model}")
        print(f"  Cores: {cores}")
    except:
        pass
    # CPU frequency
    try:
        freq_dir = Path("/sys/devices/system/cpu/cpu0/cpufreq")
        if freq_dir.exists():
            cur = int((freq_dir / "scaling_cur_freq").read_text()) // 1000
            max_freq = int((freq_dir / "cpuinfo_max_freq").read_text()) // 1000
            min_freq = int((freq_dir / "cpuinfo_min_freq").read_text()) // 1000
            governor = (freq_dir / "scaling_governor").read_text().strip()
            print(f"  Frequency: {cur} MHz (min: {min_freq}, max: {max_freq})")
            print(f"  Governor: {governor}")
    except:
        pass

def show_gpu_info():
    """Show GPU information."""
    print("\n  --- GPU Information ---")
    try:
        result = subprocess.run(["lspci"], capture_output=True, text=True, timeout=5)
        for line in result.stdout.split("\n"):
            if "VGA" in line or "Display" in line or "3D" in line:
                print(f"  {line.strip()}")
    except:
        pass
    # Check for loaded GPU drivers
    gpu_drivers = ["nvidia", "amdgpu", "radeon", "i915", "nouveau", "xe"]
    loaded = []
    try:
        with open("/proc/modules") as f:
            for line in f:
                mod = line.split()[0]
                if mod in gpu_drivers:
                    loaded.append(mod)
    except:
        pass
    if loaded:
        print(f"  Loaded GPU drivers: {', '.join(loaded)}")
    else:
        print("  No GPU drivers loaded")

def show_network_interfaces():
    """Show network interfaces — like ip link."""
    print("\n  --- Network Interfaces ---")
    try:
        result = subprocess.run(["ip", "link", "show"], capture_output=True, text=True, timeout=5)
        for line in result.stdout.split("\n"):
            if line.strip():
                print(f"  {line.strip()}")
    except:
        net_dir = Path("/sys/class/net")
        if net_dir.exists():
            for iface in sorted(net_dir.iterdir()):
                state = "up" if (iface / "operstate").read_text().strip() == "up" else "down"
                mac = (iface / "address").read_text().strip() if (iface / "address").exists() else ""
                print(f"  {iface.name:15s}  {state:5s}  {mac}")

def show_block_devices():
    """Show block devices — like lsblk."""
    print("\n  --- Block Devices ---")
    try:
        result = subprocess.run(["lsblk", "-o", "NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL"],
                              capture_output=True, text=True, timeout=5)
        for line in result.stdout.split("\n"):
            if line.strip():
                print(f"  {line}")
    except:
        pass

def show_audio_devices():
    """Show audio devices — like aplay -l."""
    print("\n  --- Audio Devices ---")
    try:
        result = subprocess.run(["aplay", "-l"], capture_output=True, text=True, timeout=5)
        for line in result.stdout.split("\n"):
            if line.strip():
                print(f"  {line}")
    except:
        snd_dir = Path("/proc/asound")
        if snd_dir.exists():
            for card in sorted(snd_dir.iterdir()):
                if card.name.startswith("card"):
                    print(f"  {card.name}")
        else:
            print("  No audio devices found")

def show_input_devices():
    """Show input devices — keyboard, mouse, touchscreen."""
    print("\n  --- Input Devices ---")
    try:
        with open("/proc/bus/input/devices") as f:
            current = ""
            for line in f:
                if line.startswith("N: Name="):
                    name = line.split("=")[1].strip().strip('"')
                    print(f"  {name}")
                elif line.startswith("H: Handlers="):
                    handlers = line.split("=")[1].strip()
                    print(f"    Handlers: {handlers}")
    except:
        print("  Cannot read input devices")

def detect_hardware():
    """Detect all hardware — full hardware scan."""
    print("\n  ============================================")
    print("  Vajra OS Hardware Detection Scan")
    print("  ============================================")
    show_cpu_info()
    show_gpu_info()
    show_pci_devices()
    show_usb_devices()
    show_network_interfaces()
    show_block_devices()
    show_audio_devices()
    show_input_devices()
    show_loaded_drivers()
    print("\n  ============================================")
    print("  Hardware scan complete")
    print("  ============================================")

def load_driver():
    """Load a kernel module — like modprobe."""
    module = input("  Module name to load: ").strip()
    if module:
        os.system(f"sudo modprobe {module}")
        print(f"  [+] Attempted to load module: {module}")

def unload_driver():
    """Unload a kernel module — like rmmod."""
    module = input("  Module name to unload: ").strip()
    if module:
        os.system(f"sudo rmmod {module}")
        print(f"  [+] Attempted to unload module: {module}")

def show_device_tree():
    """Show device tree (ARM/embedded) or ACPI info (x86)."""
    print("\n  --- Device Tree / ACPI ---")
    dt_dir = Path("/proc/device-tree")
    if dt_dir.exists():
        print("  Device Tree (ARM/embedded):")
        try:
            model = (dt_dir / "model").read_text().strip().strip("\x00")
            compatible = (dt_dir / "compatible").read_text().strip().strip("\x00")
            print(f"  Model: {model}")
            print(f"  Compatible: {compatible}")
        except:
            pass
    else:
        print("  ACPI (x86):")
        acpi_dir = Path("/sys/firmware/acpi")
        if acpi_dir.exists():
            print(f"  ACPI tables: {list(acpi_dir.iterdir())}")
        else:
            print("  No device tree or ACPI information available")

def main():
    print("=" * 55)
    print("  Vajra OS Device Manager")
    print("  Hardware Detection | Drivers | Device Tree")
    print("=" * 55)
    while True:
        print("\n  1. Full hardware scan")
        print("  2. PCI devices")
        print("  3. USB devices")
        print("  4. CPU info")
        print("  5. GPU info")
        print("  6. Network interfaces")
        print("  7. Block devices")
        print("  8. Audio devices")
        print("  9. Input devices")
        print("  10. Loaded drivers (lsmod)")
        print("  11. Load driver (modprobe)")
        print("  12. Unload driver (rmmod)")
        print("  13. Device tree / ACPI")
        print("  0. Exit")
        c = input("  Choice: ").strip()
        if c == "1": detect_hardware()
        elif c == "2": show_pci_devices()
        elif c == "3": show_usb_devices()
        elif c == "4": show_cpu_info()
        elif c == "5": show_gpu_info()
        elif c == "6": show_network_interfaces()
        elif c == "7": show_block_devices()
        elif c == "8": show_audio_devices()
        elif c == "9": show_input_devices()
        elif c == "10": show_loaded_drivers()
        elif c == "11": load_driver()
        elif c == "12": unload_driver()
        elif c == "13": show_device_tree()
        elif c == "0": break

if __name__ == "__main__":
    main()
