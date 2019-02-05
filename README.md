# fluentd

fluentdのプラグインのインストール、設定について

## プラグインのインストール

SodiumServerを使用するために、fluentdに out-http、geoip、anonymizer、record-modifier プラグインをインストールします。

      $ apt install build-essential
      $ apt install libgeoip-dev
      $ apt install geoip-database
      $ apt install libgeoip-dev
      $ apt install libmaxminddb-dev

      $ td-agent-gem install fluent-plugin-out-http
      $ td-agent-gem install fluent-plugin-geoip
      $ td-agent-gem install fluent-plugin-anonymizer
      $ td-agent-gem install fluent-plugin-record-modifier

## 設定

        # HTTP input
        # POST http://localhost:8888/<tag>?json=<json>
        # POST http://localhost:8888/td.myapp.login?json={"user"%3A"me"}
        # @see http://docs.fluentd.org/articles/in_http
        <source>
          @type http
          @id input_http
          port 8888
          add_remote_addr # <- リモートIPの設定 
        </source>
        ...

        <filter sodium>
          @type geoip

          # Specify one or more geoip lookup field which has ip address (default: host)
          geoip_lookup_keys REMOTE_ADDR

          # Specify optional geoip database (using bundled GeoLiteCity databse by default)
          # geoip_database    "/path/to/your/GeoIPCity.dat"
          # Specify optional geoip2 database
          # geoip2_database   "/path/to/your/GeoLite2-City.mmdb" (using bundled GeoLite2-City.mmdb by default)
          geoip2_database   "/opt/sodium/location_data/GeoIP2-City.mmdb"  <-- MaxMindのDBファイル
          # Specify backend library (geoip2_c, geoip, geoip2_compat)
          backend_library geoip2_c

          # Set adding field with placeholder (more than one settings are required.)
          <record>
            country         ${country.iso_code["REMOTE_ADDR"]}
            subdivision     ${subdivisions.0.iso_code["REMOTE_ADDR"]}
          </record>

          # To avoid get stacktrace error with `[null, null]` array for elasticsearch.
          skip_adding_null_record  true

          # Set @log_level (default: warn)
          @log_level         info
        </filter>

        <filter sodium>
          @type geoip

          # Specify one or more geoip lookup field which has ip address (default: host)
          geoip_lookup_keys REMOTE_ADDR

          # Specify optional geoip database (using bundled GeoLiteCity databse by default)
          # geoip_database    "/path/to/your/GeoIPCity.dat"
          # Specify optional geoip2 database
          # geoip2_database   "/path/to/your/GeoLite2-City.mmdb" (using bundled GeoLite2-City.mmdb by default)
          geoip2_database   "/opt/sodium/location_data/GeoIP2-ISP.mmdb"  <-- MaxMindのDBファイル
          # Specify backend library (geoip2_c, geoip, geoip2_compat)
          backend_library geoip2_c

          # Set adding field with placeholder (more than one settings are required.)
          <record>
            isp            ${isp["REMOTE_ADDR"]}
          </record>

          # To avoid get stacktrace error with `[null, null]` array for elasticsearch.
          skip_adding_null_record  false

          # Set @log_level (default: warn)
          @log_level         info
        </filter>

        <filter sodium>
          @type anonymizer

          # Specify rounding address keys with comma and subnet mask
          <mask network>
            keys  REMOTE_ADDR
            ipv4_mask_bits  24
            ipv6_mask_bits  104
          </mask>
        </filter>

        <filter sodium>
          @type record_modifier
          remove_keys _dummy_1
          <record>
            _dummy_1 ${if record['country'] == nil || record['country'] == ''; record['country'] = '--'; end; nil}
          </record>
        </filter>

        <filter sodium>
          @type record_modifier
          remove_keys _dummy_2
          <record>
            _dummy_2 ${if record['subdivision'] == nil || record['subdivision'] == ''; record['subdivision'] = '0'; end; nil}
          </record>
        </filter>

        <filter sodium>
          @type record_modifier
          remove_keys _dummy_3
          <record>
            _dummy_3 ${if record['isp'] == nil || record['isp'] == ''; record['isp'] = 'unknown'; end; nil}
          </record>
        </filter>

        <match sodium>　# <- タグがsodiumだった場合、ファイルへの出力とHTTPによる転送を行う
          @type copy
          <store>
            @type file
            path /var/log/fluent/sodium
          </store>
          <store>
            @type http
            endpoint_url    http://localhost:6889/api/sodium
            #http_method     put    # default: post
            serializer      json   # default: form
            #rate_limit_msec 100    # default: 0 = no rate limiting
            raise_on_error  false  # default: true
            #authentication  basic  # default: none
            #username        alice  # default: ''
            #password        bobpop # default: '', secret: true
          </store>
        </match> 
