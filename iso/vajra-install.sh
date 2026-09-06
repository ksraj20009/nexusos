#!/bin/busybox sh
# ============================================================================
# Vajra OS Installer — installs Vajra OS to a hard disk
# ============================================================================
echo ""
echo "  ============================================"
echo "  Vajra OS Installer"
echo "  ============================================"
echo ""
echo "Available disks:"
for dev in $(ls /sys/block 2>/dev/null | grep -E 'sd|vd|nvme|hd'); do
    if [ -b /dev/$dev ]; then
        SIZE=$(cat /sys/block/$dev/size 2>/dev/null)
        if [ -n "$SIZE" ] && [ "$SIZE" -gt 0 ]; then
            MB=$((SIZE * 512 / 1024 / 1024))
            echo "  /dev/$dev — ${MB} MB"
        fi
    fi
done
echo ""
read -p "Install to which disk? (e.g. sda): " DISK
if [ -z "$DISK" ]; then echo "[-] No disk specified"; exit 1; fi
if [ ! -b "/dev/$DISK" ]; then echo "[-] /dev/$DISK not found"; exit 1; fi
echo ""
echo "  WARNING: This will ERASE ALL DATA on /dev/$DISK!"
read -p "Type 'YES' to continue: " CONFIRM
if [ "$CONFIRM" != "YES" ]; then echo "[-] Cancelled"; exit 0; fi
echo ""
echo "[1/7] Partitioning disk..."
cat << EOF | /bin/busybox fdisk /dev/$DISK
o
n
p
1


a
w
EOF
PART="/dev/${DISK}1"
echo "[+] Partition: $PART"
echo "[2/7] Formatting ext4..."
/bin/busybox mke2fs -t ext4 -L vajra-root "$PART" 2>/dev/null
echo "[3/7] Mounting..."
mkdir -p /mnt/vajra
/bin/busybox mount "$PART" /mnt/vajra
echo "[4/7] Copying Vajra OS..."
for dir in bin sbin usr/bin usr/sbin etc lib root; do
    if [ -d "/$dir" ]; then
        mkdir -p "/mnt/vajra/$dir"
        /bin/busybox cp -a "/$dir/." "/mnt/vajra/$dir/" 2>/dev/null
    fi
done
echo "[5/7] fstab..."
cat > /mnt/vajra/etc/fstab << FSTAB
$PART / ext4 defaults 0 1
proc /proc proc defaults 0 0
sysfs /sys sysfs defaults 0 0
devtmpfs /dev devtmpfs defaults 0 0
tmpfs /tmp tmpfs defaults 0 0
FSTAB
echo "[6/7] Bootloader..."
mkdir -p /mnt/vajra/boot
if [ -f /vmlinuz ]; then
    /bin/busybox cp /vmlinuz /mnt/vajra/boot/vmlinuz 2>/dev/null
fi
cat > /mnt/vajra/boot/extlinux.conf << EXTCONF
DEFAULT vajra
LABEL vajra
  KERNEL /boot/vmlinuz
  APPEND root=$PART rw init=/init
EXTCONF
echo "[7/7] Finalizing..."
/bin/busybox sync
/bin/busybox umount /mnt/vajra 2>/dev/null
echo ""
echo "  ============================================"
echo "  Vajra OS installed!"
echo "  ============================================"
echo "  Remove USB/CD and reboot."
echo "  Dharmo Rakshati Rakshitah"
