if [[ "${configuration}" == "ansible" ]]; then
    cat << EOF > $IAC_DIR/prometheus-config.json
${merged_ansible_prometheus_settings}
EOF
    yum install -y gem
    gem install aws-sdk-ssm
    yum install -y dwp-ansible-prometheus-$${PROMETHEUS_VERSION} dwp-ansible-prometheus-cloudwatch-exporter-$${PROMETHEUS_CLOUDWATCH_EXPORTER_VERSION} dwp-ansible-prometheus-blackbox-exporter-$${PROMETHEUS_BLACKBOX_EXPORTER_VERSION} dwp-ansible-prometheus-pushgateway-$${PROMETHEUS_PUSHGATEWAY_VERSION}
    echo >> $IAC_DIR/site.yaml "    - prometheus"
    echo >> $IAC_DIR/site.yaml "    - prometheus-cloudwatch-exporter"
    echo >> $IAC_DIR/site.yaml "    - prometheus-blackbox-exporter"
    echo >> $IAC_DIR/site.yaml "    - prometheus-pushgateway"

    # construct the extra_vars commandline
    for config_file in $IAC_DIR/*-config.json; do
      EXTRA_VARS="$EXTRA_VARS --extra-vars @$${config_file}"
    done

    cd $IAC_DIR
    ansible-playbook site.yaml -c local -i localhost, $EXTRA_VARS
fi

