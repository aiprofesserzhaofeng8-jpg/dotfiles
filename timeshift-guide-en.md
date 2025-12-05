# Snapshot and Backup Guidance (for ext4 & Wayland/Niri users)

**Important:** Your root partition is currently formatted as `ext4`, not `btrfs`:

```
nvme0n1p5  ext4  /
```

This means:

- ❗ You **cannot use Snapper / btrfs true snapshots** on this system.
- ✅ You **must use Timeshift in RSYNC mode** for system snapshots/backups.

Below are three parts to solve your immediate issues and give you practical steps.

---

## 1. Why `timeshift-gtk` won't open (on Wayland)

You are running on **Wayland (Niri)** and tried to launch a GUI with `sudo`. On Wayland, launching GUI apps with `sudo` is usually blocked and will produce:

```
Gtk-WARNING **: cannot open display: :1
```

**Correct ways to run Timeshift GUI (pick one):**

### Option 1 (recommended)
Run Timeshift as your normal user and let it prompt for authentication:

```bash
timeshift-gtk
```

This is Wayland-friendly and will show a password prompt for privileged actions.

### Option 2 (if PolicyKit not installed)
Install PolicyKit (polkit) first:

```bash
sudo pacman -S polkit
```

Then run:

```bash
timeshift-gtk
```

### Option 3 (command-line, reliable)
Use Timeshift CLI to create snapshots:

```bash
sudo timeshift --create --comments "Initial snapshot" --tags D
```

---

## 2. Creating snapshots on an `ext4` root (what to do)

Because your `/` is ext4, Timeshift will use the **RSYNC** mode (not btrfs snapshots). RSYNC snapshots are safe and work well, though they are not copy-on-write block snapshots.

### 1) Initialize Timeshift (one-time only)

Run the interactive setup:

```bash
sudo timeshift --setup
```

Choose options like:

- Device: `/dev/nvme0n1p5`  
- Type: `RSYNC`  
- Snapshot retention: keep 5–10 snapshots (adjust to your preference)

### 2) Create a manual snapshot

```bash
sudo timeshift --create --comments "Backup before installing X" --tags D
```

### 3) List existing snapshots

```bash
sudo timeshift --list
```

### 4) Restore a snapshot (system rollback)

```bash
sudo timeshift --restore
```

Follow the interactive prompts to select the snapshot to restore.

---

## 3. Should you switch to `btrfs` for true snapshots?

Current situation:

| Item                     | Status     |
|--------------------------|------------|
| Filesystem               | ext4       |
| Snapper (btrfs snapshots)| Not available |
| Timeshift (rsync)        | Available  |
| True copy-on-write snapshots | Not supported on ext4 |
| System rollback ability  | Supported via Timeshift (rsync) |

**Consider switching to btrfs if:**

- You frequently experiment and want fast atomic snapshots and rollbacks.
- You want integration with `snapper` and automatic grub boot menu entries for snapshots.
- You prefer the ability to roll back the entire system more like a VM snapshot.

I can guide you step-by-step to reinstall or convert to `btrfs` and set up `snapper + grub-btrfs` if you want.

---

## 4. One practical immediate command

To create a usable system backup snapshot right now, run:

```bash
sudo timeshift --create --comments "Current system backup" --tags D
```

This saves the current system state and is the recommended immediate action.

---

## 5. Optional next steps I can help with

- Automate snapshots before package upgrades.  
- Enable boot-time snapshots and auto-cleanup policies.  
- Provide a one-command rollback flow if an update breaks the system.  
- Or: guide you to reinstall with `btrfs + snapper + grub-btrfs` for true snapshot functionality.

---

If you want to continue, tell me one of:

- `I have created the snapshot`  
- `timeshift-gtk still won't open`  
- `I want to switch to btrfs`

I'll proceed based on your choice.
