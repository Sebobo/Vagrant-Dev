backend apache {
    .host = "localhost";
    .port = "8000";
}

sub vcl_recv {
    if (req.http.x-forwarded-for) {
        set req.http.X-Forwarded-For =
        req.http.X-Forwarded-For + ", " + client.ip;
    } else {
        set req.http.X-Forwarded-For = client.ip;
    }

    set req.backend = apache;

    if (req.request == "POST") {
        ban("req.url == " + req.url);
        set req.http.X-Test = req.url;
        return (pass);
    }

    if (req.request != "GET" &&
        req.request != "HEAD" &&
        req.request != "PUT" &&
        req.request != "POST" &&
        req.request != "TRACE" &&
        req.request != "OPTIONS" &&
        req.request != "DELETE") {
        return (pipe);
    }
    if (req.request != "GET" && req.request != "HEAD") {
        return (pass);
    }
    if (req.http.Authorization || req.http.Cookie) {
        return (pass);
    }

    if(req.http.host ~ "/typo3"){
        ## TYPO3-Backend nicht cachen
        if (req.http.cookie ~ "be_typo_user"){
            ## Inhalten löschen wenn Shift+reload gedrückt wird, aber nur bei eingeloggtem user (Backend-Cookie)
            if (req.http.Cache-Control ~ "no-cache") {
                set req.ttl = 0s;
                ban("req.url == " + req.url);
                return (pass);
            }
        }
        else{
            ## Cookies von TYPO3-Seiten löschen
            unset req.http.Cookie;
        }
    }
    if (req.http.Cache-Control ~ "no-cache") {
        return (pass);
    }

    return (lookup);
}

sub vcl_fetch {
    set beresp.ttl = 12h;
    set req.grace = 24h;
    if (req.url ~ "\.(jpeg|jpg|png|gif|ico|swf|js|css|txt|gz|zip|rar|bz2|tgz|tbz|html|htm|pdf|pls|torrent)$") {
        set beresp.ttl = 1m;
        unset beresp.http.set-cookie;
    }
    if(req.http.host ~ "/typo3"){
        if (beresp.http.set-cookie ~ "be_typo_user"){
        }
        else{
            unset beresp.http.set-cookie;
        }
    }
    if (beresp.http.Pragma ~ "nocache") {
        return (hit_for_pass);
    }
    return (deliver);
}

sub vcl_deliver {
    if (resp.http.magicmarker) {
        /* Remove the magic marker */
        unset resp.http.magicmarker;

        /* By definition we have a fresh object */
        set resp.http.age = "0";
    }

    if (obj.hits > 0) {
        set resp.http.X-Varnish-Cache = "HIT";
        set resp.http.X-Cache-Hits = obj.hits;
    } else {
        set resp.http.X-Varnish-Cache = "MISS";
    }
}
