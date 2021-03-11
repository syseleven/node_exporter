{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'node-exporter',
        rules: [
          {
            alert: 'NodeFilesystemSpaceFillingUp',
            expr: |||
              node_filesystem_avail_bytes{%(nodeExporterSelector)s,%(fstypeSelector)s} / node_filesystem_size_bytes{%(nodeExporterSelector)s,%(fstypeSelector)s} < 0.4
              and
              node_filesystem_readonly{%(nodeExporterSelector)s,%(fstypeSelector)s} == 0
              and
              predict_linear(node_filesystem_avail_bytes{%(nodeExporterSelector)s,%(fstypeSelector)s}[6h], 24*60*60) < 0
            ||| % $._config,
            'for': '1h',
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Filesystem on {{ $labels.device }} at {{ $labels.instance }} is predicted to run out of space within the next 24 hours.',
            },
          },
          {
            alert: 'NodeFilesystemSpaceFillingUp',
            expr: |||
              node_filesystem_avail_bytes{%(nodeExporterSelector)s,%(fstypeSelector)s} / node_filesystem_size_bytes{%(nodeExporterSelector)s,%(fstypeSelector)s} < 0.3
              and
              node_filesystem_readonly{%(nodeExporterSelector)s,%(fstypeSelector)s} == 0
              and
              predict_linear(node_filesystem_avail_bytes{%(nodeExporterSelector)s,%(fstypeSelector)s}[6h], 4*60*60) < 0
            ||| % $._config,
            'for': '1h',
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Filesystem on {{ $labels.device }} at {{ $labels.instance }} is predicted to run out of space within the next 4 hours.',
            },
          },
          {
            alert: 'NodeFilesystemOutOfSpace',
            expr: |||
              node_filesystem_avail_bytes{%(nodeExporterSelector)s,%(fstypeSelector)s} / node_filesystem_size_bytes{%(nodeExporterSelector)s,%(fstypeSelector)s} * 100 < 5
              and
              node_filesystem_readonly{%(nodeExporterSelector)s,%(fstypeSelector)s} == 0
            ||| % $._config,
            'for': '1h',
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Filesystem on {{ $labels.device }} at {{ $labels.instance }} has only {{ $value }}% available space left.',
            },
          },
          {
            alert: 'NodeFilesystemOutOfSpace',
            expr: |||
              node_filesystem_avail_bytes{%(nodeExporterSelector)s,%(fstypeSelector)s} / node_filesystem_size_bytes{%(nodeExporterSelector)s,%(fstypeSelector)s} * 100 < 3
              and
              node_filesystem_readonly{%(nodeExporterSelector)s,%(fstypeSelector)s} == 0
            ||| % $._config,
            'for': '1h',
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Filesystem on {{ $labels.device }} at {{ $labels.instance }} has only {{ $value }}% available space left.',
            },
          },
          {
            alert: 'NodeFilesystemFilesFillingUp',
            expr: |||
              node_filesystem_files_free{%(nodeExporterSelector)s,%(fstypeSelector)s} / node_filesystem_files{%(nodeExporterSelector)s,%(fstypeSelector)s} < 0.4
              and
              node_filesystem_readonly{%(nodeExporterSelector)s,%(fstypeSelector)s} == 0
              and
              predict_linear(node_filesystem_files_free{%(nodeExporterSelector)s,%(fstypeSelector)s}[6h], 24*60*60) < 0
            ||| % $._config,
            'for': '1h',
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Filesystem on {{ $labels.device }} at {{ $labels.instance }} is predicted to run out of files within the next 24 hours.',
            },
          },
          {
            alert: 'NodeFilesystemFilesFillingUp',
            expr: |||
              node_filesystem_files_free{%(nodeExporterSelector)s,%(fstypeSelector)s} / node_filesystem_files{%(nodeExporterSelector)s,%(fstypeSelector)s} < 0.2
              and
              node_filesystem_readonly{%(nodeExporterSelector)s,%(fstypeSelector)s} == 0
              and
              predict_linear(node_filesystem_files_free{%(nodeExporterSelector)s,%(fstypeSelector)s}[6h], 4*60*60) < 0
            ||| % $._config,
            'for': '1h',
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Filesystem on {{ $labels.device }} at {{ $labels.instance }} is predicted to run out of files within the next 4 hours.',
            },
          },
          {
            alert: 'NodeFilesystemOutOfFiles',
            expr: |||
              node_filesystem_files_free{%(nodeExporterSelector)s,%(fstypeSelector)s} / node_filesystem_files{%(nodeExporterSelector)s,%(fstypeSelector)s} * 100 < 5
              and
              node_filesystem_readonly{%(nodeExporterSelector)s,%(fstypeSelector)s} == 0
            ||| % $._config,
            'for': '1h',
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Filesystem on {{ $labels.device }} at {{ $labels.instance }} has only {{ $value }}% available inodes left.',
            },
          },
          {
            alert: 'NodeFilesystemOutOfSpace',
            expr: |||
              node_filesystem_files_free{%(nodeExporterSelector)s,%(fstypeSelector)s} / node_filesystem_files{%(nodeExporterSelector)s,%(fstypeSelector)s} * 100 < 3
              and
              node_filesystem_readonly{%(nodeExporterSelector)s,%(fstypeSelector)s} == 0
            ||| % $._config,
            'for': '1h',
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Filesystem on {{ $labels.device }} at {{ $labels.instance }} has only {{ $value }}% available inodes left.',
            },
          },
          {
            alert: 'NodeNetworkReceiveErrs',
            expr: |||
              increase(node_network_receive_errs_total{%(nodeExporterSelector)s,%(hostNetworkInterfaceSelector)s}[5m]) / 5 > 0
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: '{{ $labels.instance }} interface {{ $labels.device }} shows errors while receiving packets ({{ $value }} errors per minute).',
            },
          },
          {
            alert: 'NodeNetworkTransmitErrs',
            expr: |||
              increase(node_network_transmit_errs_total{%(nodeExporterSelector)s,%(hostNetworkInterfaceSelector)s}[5m]) / 5 > 0
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: '{{ $labels.instance }} interface {{ $labels.device }} shows errors while transmitting packets ({{ $value }} errors per minute).',
            },
          },
        ],
      },
    ],
  },
}
