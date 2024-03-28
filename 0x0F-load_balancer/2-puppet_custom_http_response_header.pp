# Use Puppet to automate the task of creating a custom HTTP header response

exec {'update':
  command => '/usr/bin/apt-get update',
}
 package {'nginx':
	ensure => 'present',
	require => Exec['update system']
}
 file_line { 'http_header':
  path  => '/etc/nginx/nginx.conf',
  match => 'http {',
  line  => "http {\n\tadd_header X-Served-By \"${hostname}\";",
}
 exec {'run':
  command => '/usr/sbin/service nginx restart',
}
file {'/var/www/html/index.html':
	content => 'Hello World!'
}
exec {'redirect_me':
	command => 'sed -i "24i\	rewrite ^/redirect_me https://th3-gr00t.tk/ permanent;" /etc/nginx/sites-available/default',
	provider => 'shell'
}
service {'nginx':
	ensure => running,
	require => Package['nginx']
}
