[Unit]
Description=Perform replica sourced, MySQL logical backups according to a schedule

[Timer]
OnCalendar=${schedule}
Unit=mysql-replica-dump.service
Persistent=true

[Install]
WantedBy=timers.target
