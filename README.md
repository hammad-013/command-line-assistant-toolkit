# 🛠️ Command-Line Assistant Toolkit

A collection of practical and interactive Bash scripts designed to streamline common Linux command-line tasks. Each tool supports useful options, safety checks, and user-friendly output.

---

## 📁 Included Tools

### 1. `quickfind.sh` – 🔎 Smart File Finder

Search for files or directories by name, type, size, and more.

**Features:**

- `-p <pattern>`: File pattern (e.g., `"*.log"`)
- `-t <type>`: File type (`f` for file, `d` for directory)
- `-d <directory>`: Directory to search in
- `--size <+/-N[B|K|M|G]>`: Size filter (e.g., `--size -100K`)
- `--count`: Show number of matches
- `--open`: Open selected file
- `--delete`: Delete matched files/directories (with confirmation)

**Example:**

```bash
./quickfind.sh -p "*.log" -t f -d /var/log --size -1M --open
```

### 2. `envdump.sh` – 🌐 Environment Variable Dumper

Filter, format, and save environment variables.

**Features:**

- `--filter <pattern>`: Only show variables matching a pattern
- `--save <file>`: Save the output to a file
- `--json`: Output the variables in JSON format

**Example:**

```bash
./envdump.sh --filter PATH --json --save env.json
```

### 3. `tarbackup.sh` – 🗜️ Smart Directory Backup

Backup folders with compression, logging, and exclusions.

**Features:**

- `-s <source-dir>`: Directory to back up
- `-o <output-file>`: Optional output archive name (defaults to timestamped name)
- `--exclude <dir1,dir2,...>`: Skip directories like `node_modules`, `.git`
- `--log`: Save backup log with time, size, and archive path

**Example:**

```bash
./tarbackup.sh -s /home/user/project --exclude node_modules,.git --log
```

### 4. `permfix.sh` – 🔐 Permission Fixer

Fix file and directory permissions safely with preview.

**Features:**

- `--file-mode <mode>`: Mode for files (default: 644)
- `--dir-mode <mode>`: Mode for directories (default: 755)
- `--dry-run`: Preview changes without applying
- `--confirm`: Ask for confirmation before changing each item

**Example:**

```bash
./permfix.sh /var/www --file-mode 600 --dir-mode 700 --dry-run
```

### 5. `psclean.sh` – 🚫 Process Cleaner

Search and interactively kill unwanted processes.

**Features:**

- `--name <pattern>`: Filter processes by name
- `--safe`: Ask before killing each process
- `--top`: Sort by CPU or memory usage
- `--kill-all`: Kill all matched processes without asking

**Example:**

```bash
./psclean.sh --name firefox --top --safe
```

---

## 🚀 How to Use

1. Make Main script executable:

```bash
chmod +x assistant.sh
```

2. Run:

```bash
./assistant.sh
```

---

## 🧠 Requirements

- Bash
- Standard Unix tools: `find`, `ps`, `awk`, `tar`, `jq` (optional), `xdg-open` (for `--open`)

---

## 📄 License

MIT License — use freely and modify for your needs.
