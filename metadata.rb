name              "ktc-keepalived"
maintainer        "KT Cloudware, Inc."
maintainer_email  "chamankang@kt.com"
description       "Wrapper cookbook for rcb's keepalived"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.5"
supports          "ubuntu"

depends "keepalived"

recipe "keepalived", ""
