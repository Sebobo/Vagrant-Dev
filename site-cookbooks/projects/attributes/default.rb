default['projects']['sites'] = []
default['projects']['project_list'] = []
default['projects']['varnish']['caching_enabled'] = false

override['apache']['prefork']['startservers'] = 2
override['apache']['prefork']['minspareservers'] = 2
override['apache']['prefork']['maxspareservers'] = 4
