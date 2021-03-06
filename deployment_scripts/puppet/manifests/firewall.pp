# Copyright 2015 Mirantis, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

notice('fuel-plugin-influxdb-grafana: firewall.pp')

class {'::firewall':}

firewall { '000 accept all icmp requests':
  proto  => 'icmp',
  action => 'accept',
}

firewall { '001 accept all to lo interface':
  proto   => 'all',
  iniface => 'lo',
  action  => 'accept',
}

firewall { '002 accept related established rules':
  proto  => 'all',
  state  => ['RELATED', 'ESTABLISHED'],
  action => 'accept',
}

firewall { '020 ssh':
  dport  => 22,
  proto  => 'tcp',
  action => 'accept',
}

firewall { '113 corosync-input':
  dport  => 5404,
  proto  => 'udp',
  action => 'accept',
}

firewall { '114 corosync-output':
  sport  => 5405,
  proto  => 'udp',
  action => 'accept',
}

firewall { '200 influxdb':
  dport  => [8083, hiera('lma::influxdb::influxdb_port'), 8088, 8091],
  proto  => 'tcp',
  action => 'accept',
}

firewall { '201 grafana':
  dport  => hiera('lma::influxdb::grafana_port'),
  proto  => 'tcp',
  action => 'accept',
}

firewall { '999 drop all other requests':
  proto  => 'all',
  chain  => 'INPUT',
  action => 'drop',
}
