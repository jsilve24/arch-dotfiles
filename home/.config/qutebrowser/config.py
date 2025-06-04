# Load existing settings made via :set
config.load_autoconfig()

### Key Bindings

config.bind('xs', 'config-cycle statusbar.show always never')
config.bind('xt', 'config-cycle tabs.show always never')
config.bind('xx', 'config-cycle tabs.show always never;; config-cycle statusbar.show always never')
config.bind('gt', 'set-cmd-text -s :tab-take')
config.bind('gD', 'download-delete')
config.bind('gd', 'download-open')
config.bind('gx', 'tab-give')
config.bind('ta', 'set content.blocking.enabled false ;; reload -f ;; cmd-later 5s set content.blocking.enabled true')
config.bind(';r', 'hint --rapid')
config.bind(';R', 'hint --rapid links tab-bg')
config.bind(',l', 'spawn --userscript org-protocol store-link')  
config.bind(',,w', 'spawn --userscript org-protocol capture Pw')
config.bind(',,z', "set content.unknown_url_scheme_policy allow-all;; jseval location.href=('org-protocol://zotra?url='+ encodeURIComponent(location.href)).replace(/'/gi,\"%27\");; cmd-later 5s set content.unknown_url_scheme_policy allow-from-user-interaction")
config.bind('sh', 'history')
