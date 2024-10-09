# yaml-language-server: $schema=https://raw.githubusercontent.com/Relativ-IT/Butane-Schemas/Release/Butane-Schema.json
---
variant: fcos
version: 1.5.0
passwd:
  users:
  - name: core
storage:
  files:
  - path: /etc/hostname
    mode: 0644
    contents:
      inline: OOBM-SRV
  - path: /etc/dnsmasq.conf
    overwrite: true
    contents:
      local: fcos/oobm-srv/dnsmasq.conf
  - path: /var/ftp/pct6248.cfg
    user:
      id: 1000
    contents:
      local: fcos/oobm-srv/pct6248.scr
  - path: /var/ftp/pss4810.cfg
    user:
      id: 1000
    contents:
      local: fcos/oobm-srv/pss4810.cfg
  - path: /etc/containers/systemd/dnsmasq-oobm.container
    contents:
      inline: |
        [Unit]
        Description=OOBM dnsmasq Service
        Wants=network-online.target install-ARCHIVE-assets.service
        After=network-online.target install-ARCHIVE-assets.service
        [Container]
        ContainerName=dnsmasq
        Image=ghcr.io/doubleu-labs/dnsmasq:latest
        AddCapability=NET_ADMIN,NET_RAW
        Volume=/etc/dnsmasq.conf:/etc/dnsmasq.conf:z
        Volume=/var/ftp:/var/tftp:z
        Network=host
        [Service]
        Restart=always
        [Install]
        WantedBy=multi-user.target
  - path: /etc/NetworkManager/system-connections/end0.nmconnection
    mode: 0600
    contents:
      inline: |
        [connection]
        id=end0
        type=ethernet
        autoconnect=true
        interface-name=end0
        [ipv4]
        method=manual
        address1=10.0.1.1/24
        dns=127.0.0.1;
        dns-search=oobm.home.doubleu.codes
        [ipv6]
        method=ignore
systemd:
  units:
  - name: systemd-resolved.service
    mask: true
  - name: chronyd.service
    mask: true
  - name: zincati.service
    mask: true
  - name: fwupd-refresh.timer
    mask: true
  - name: var-mnt-ARCHIVE.automount
    enabled: true
    contents: |
      [Unit]
      Description=Automount ARCHIVE Partition
      [Automount]
      Where=/var/mnt/ARCHIVE
      [Install]
      WantedBy=multi-user.target
  - name: var-mnt-ARCHIVE.mount
    contents: |
      [Unit]
      Description=Mount ARCHIVE Partition
      [Mount]
      What=/dev/disk/by-label/ARCHIVE
      Where=/var/mnt/ARCHIVE
      Type=vfat
      Options=ro
      [Install]
      WantedBy=multi-user.target
  - name: install-ARCHIVE-assets.service
    enabled: true
    contents: |
      [Unit]
      Description=Install ARCHIVE Assets
      Wants=var-mnt-ARCHIVE.mount
      ConditionPathExists=!/var/lib/%N.stamp
      [Service]
      Type=oneshot
      RemainAfterExit=true
      ExecStart=podman image load -i /var/mnt/ARCHIVE/dnsmasq.tar
      ExecStartPost=/bin/touch /var/lib/%N.stamp
      [Install]
      WantedBy=multi-user.target
