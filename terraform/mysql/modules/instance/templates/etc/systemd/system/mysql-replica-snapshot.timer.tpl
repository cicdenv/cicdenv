[Unit]
Description=Perform replica sourced, MySQL physical backups according to a schedule

[Timer]
OnCalendar=${schedule}
Unit=mysql-replica-snapshot.service
Persistent=true

[Install]
WantedBy=timers.target
