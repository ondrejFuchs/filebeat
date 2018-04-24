#!/bin/bash
touch filebeat.yml

cat <<'EOF' >>filebeat.yml
###################### Filebeat Configuration Example #########################

# This file is an example configuration file highlighting only the most common
# options. The filebeat.full.yml file from the same directory contains all the
# supported options with more comments. You can use it as a reference.
#
# You can find the full configuration reference here:
# https://www.elastic.co/guide/en/beats/filebeat/index.html


#==========================  Modules configuration ============================
filebeat.config.modules:
  # Glob pattern for configuration loading
  path: ${path.config}/modules.d/*.yml

  # Set to true to enable config reloading
  reload.enabled: false

#=========================== Filebeat prospectors =============================
filebeat:
  prospectors:
    - paths:
        - "/var/log/Rpi.log"
      document_type: log 
      scan_frequency: 1s
      
    - paths:
        - "/var/log/power.log" 
      document_type: log
      scan_frequency: 1s

    - paths:
        - "/var/log/diod.log" 
      document_type: log
      scan_frequency: 1s

    - paths:
        - "/var/log/box.log" 
      document_type: log
      scan_frequency: 1s
            
    - paths:
        - "/var/log/dmesg.log"
      document_type: log
      scan_frequency: 1s
 
    - paths:
        - "/var/log/dpkg.log"
      document_type: log  
      scan_frequency: 1s

    - paths:
        - "/var/log/temperature.log"
      document_type: log
      scan_frequency: 1s

    - paths:
        - "/var/log/apt/*"
      document_type: log
      scan_frequency: 1s

#filebeat.prospectors:

#-------------------------- Elasticsearch output ------------------------------
#output.elasticsearch:
 # Array of hosts to connect to.
 # hosts: ["18.195.71.186:9200"]
 # template.name: "filebeat"
 # template.path: "filebeat.template.json"
 # template.overwrite: false
 # Optional protocol and basic auth credentials.
 # protocol: "https"
 # username: "elastic"
 # password: "elasticnsw"

#----------------------------- Logstash output --------------------------------
output.logstash:
  enabled: true
  # The Logstash hosts
  hosts: ["monitor.neuronsw.com:5044"]
  ssl:
    certificate_authorities: "/etc/ssl/certs/root-ca.crt"
    certificate: "/etc/ssl/certs/filebeat.crt.pem"
    key: "/etc/ssl/certs/filebeat.key.pem"
    
EOF
