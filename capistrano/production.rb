set :user, 'deploy'
set :port, 30000

set :deploy_to, "/home/deploy/public_html/#{application}"
set :rails_env, "production"

# Specify production server
set :server_name, 'production server url or ip'
role :app, server_name
role :web, server_name
role :db, server_name, :primary => true

set :vhost_template, <<-EOF
<VirtualHost *>
    <Directory #{deploy_to}/current/public>
        Options FollowSymLinks
        AllowOverride None
        Order allow,deny
        Allow from All
    </Directory>

  	DocumentRoot #{deploy_to}/current/public
    ServerName #{server_name}

    RailsEnv production

    ErrorLog #{deploy_to}/shared/log/production_error.log
    CustomLog #{deploy_to}/shared/log/production_access.log combined

    # Gzip/Deflate
    AddOutputFilterByType DEFLATE text/html text/plain text/xml text/javascript text/css application/x-javascript
    BrowserMatch ^Mozilla/4 gzip-only-text/html
    BrowserMatch ^Mozilla/4\.0[678] no-gzip
    BrowserMatch \bMSIE !no-gzip !gzip-only-text/html

    # No Etags
    FileETag None

    RewriteEngine On

    # Check for maintenance file and redirect all requests
    RewriteCond %{DOCUMENT_ROOT}/system/maintenance.html -f
    RewriteCond %{SCRIPT_FILENAME} !maintenance.html
    RewriteRule ^.*$ /system/maintenance.html [L]

    # Static cache
    RewriteCond %{REQUEST_METHOD} !^POST$
    RewriteCond #{deploy_to}/current/tmp/cache/static$1/index.html -f
    RewriteRule ^(.*)$ #{deploy_to}/current/tmp/cache/static$1/index.html [L]
</VirtualHost>
EOF
