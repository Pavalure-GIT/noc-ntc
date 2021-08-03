if [[ "${configuration}" == "ansible" ]]; then
    cat << EOF > $IAC_DIR/alertmanager-config.json
${merged_ansible_alertmanager_settings}
EOF
    yum install -y dwp-ansible-prometheus-alertmanager-$${PROMETHEUS_ALERTMANAGER_VERSION}
    echo >> $IAC_DIR/site.yaml "    - prometheus-alertmanager"

    # construct the extra_vars commandline
    for config_file in $IAC_DIR/*-config.json; do
      EXTRA_VARS="$EXTRA_VARS --extra-vars @$${config_file}"
    done

    cd $IAC_DIR
    ansible-playbook site.yaml -c local -i localhost, $EXTRA_VARS
fi
