if [[ "${configuration}" == "ansible" ]]; then
    cat << EOF > $IAC_DIR/grafana-config.json
${grafana_config}
EOF
    yum install -y dwp-ansible-grafana-saml-$${PROMETHEUS_GRAFANA_SAML_VERSION}
    echo >> $IAC_DIR/site.yaml "    - grafana-saml"

    # construct the extra_vars commandline
    for config_file in $IAC_DIR/*-config.json; do
      EXTRA_VARS="$EXTRA_VARS --extra-vars @$${config_file}"
    done

    cd $IAC_DIR
    ansible-playbook site.yaml -c local -i localhost, $EXTRA_VARS
fi
