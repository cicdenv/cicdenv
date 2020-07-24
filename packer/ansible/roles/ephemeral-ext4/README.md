## Purpose
Provisioning role for servers that want to treat all fast local storage as a single block device.

Note: `This isn't a safe config for datastores.`

Scripts/hooks for making a single (possibly multi-device striped raid0)
logical block device out of all ephemeral instance stores on `i3*|c5d|m5*d|r5*d|z1d` instance types.

## Usage
Creates an `md` device if more than 1 PCI-e flash storage device is detected.
Either the single or *multi-device raid0* gets an ext4 filesystem mounted to `ephemeral_pool_mount_point`.

The list of Bind mounts `ephemeral_pool_bind_mounts` are created 
pointing to sub-folders on `ephemeral_pool_mount_point`.

To ensure this config (block device, filesystem, and bind mounts) are recreated
before needed after restarts use the `ephemeral_pool_wanted_by` list systemd hook.

## Limitations
```
#
# NOTE: these instance families are not supported
#    x1
#    x1e
#    g2
#    f1
#    p3dn
#    i2                                         
#    c3
#    m3                    
#    r3                                         
```
