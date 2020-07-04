#!/bin/bash

set -eux -o pipefail

ephemeral_dir="/mnt/ephemeral"

#
# Ephemeral (fast storage) bind mounts.
#
# Example:
#   binds: [
#     /var/log/nginx:nginx-logs
#   ]
#   results:
#     /var/log/nginx => /mnt/ephemral/nginx-logs
#
for binding in  \
"/var/log/nginx:nginx-logs" \
; do
	# Bind path
    bind_dir="${binding%%:*}"

    # Create a subfolder to mount under $ephemeral_dir
    real_dir="${ephemeral_dir}/${binding##*:}"

    if ! findmnt -rno TARGET "$bind_dir"; then
        mkdir -p "$real_dir"
        mkdir -p "$bind_dir"

        chown -R nginx:nginx "$real_dir"
        chown -R nginx:nginx "$bind_dir"

        mount -o bind "$real_dir" "$bind_dir"
    fi
done
