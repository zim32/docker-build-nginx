server {
        listen 80 default_server;
        #listen 443 ssl;

        server_name site.com;

        access_log /var/log/nginx/site.com.access.log;
        error_log /var/log/nginx/site.com.error.log info;

        #ssl_certificate /etc/nginx/cert/crt.pem;
        #ssl_certificate_key /etc/nginx/cert/private.pem;   

        location ~* \.(?:ico|css|js|gif|jpe?g|png|woff|woff2)$ {
                root /home/zim32/www/site.com;
        }

        location / {
                fastcgi_pass 127.0.0.1:8080;

                fastcgi_param   QUERY_STRING            $query_string;
                fastcgi_param   REQUEST_METHOD          $request_method;
                fastcgi_param   CONTENT_TYPE            $content_type;
                fastcgi_param   CONTENT_LENGTH          $content_length;

                fastcgi_param   SCRIPT_FILENAME         /home/zim32/www/app/web/app_dev.php;
                fastcgi_param   SCRIPT_NAME             /home/zim32/www/app/web/app_dev.php;
                fastcgi_param   REQUEST_URI             $request_uri;
                fastcgi_param   DOCUMENT_URI            $document_uri;
                fastcgi_param   DOCUMENT_ROOT           $document_root;
                fastcgi_param   SERVER_PROTOCOL         $server_protocol;

                fastcgi_param   GATEWAY_INTERFACE       CGI/1.1;
                fastcgi_param   SERVER_SOFTWARE         nginx/$nginx_version;

                fastcgi_param   REMOTE_ADDR             $remote_addr;
                fastcgi_param   REMOTE_PORT             $remote_port;
                fastcgi_param   SERVER_ADDR             $server_addr;
                fastcgi_param   SERVER_PORT             $server_port;
                fastcgi_param   SERVER_NAME             $server_name;

                fastcgi_param   CLIENT_CERT             $ssl_client_raw_cert;
                fastcgi_param   CLIENT_CERT_OK          $ssl_client_verify;

                fastcgi_param   HTTPS                   $https if_not_empty;
        }

}
