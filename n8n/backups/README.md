# n8n backups

Run the backup script to create a timestamped archive of your n8n data directory.

## Usage

```bash
cd /home/sanvi/Automation-Lab/n8n
chmod +x backups/backup.sh
./backups/backup.sh
```

Backups are stored in this folder as `.tar.gz` files and the script keeps the latest 5 copies.
