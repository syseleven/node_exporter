{
  _config+:: {
    // Selectors are inserted between {} in Prometheus queries.
    diskDeviceSelector: 'device=~"(sd|xvd|nvme).+"',
    fstypeSelector: 'fstype=~"ext.|xfs",mountpoint!="/var/lib/docker/aufs"',
    hostNetworkInterfaceSelector: 'device="eth0"',
    nodeExporterSelector: 'job="node-exporter"',
  },
}
