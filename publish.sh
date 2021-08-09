#!/usr/bin/env bash

set -x

hugo -D

scp -r public/ effekthasch.org:/opt/public/avs-blog_new \
    || ssh effekthasch.org rm -rf /opt/public/avs-blog_new \
    && ssh effekthasch.org /usr/bin/bash << EOF
        rm -rf /opt/public/avs-blog_old \
        mv /opt/public/avs-blog{,_old} \
            && mv /opt/public/avs-blog{_new,} \
            || mv /opt/public/avs-blog{_old,}
EOF
