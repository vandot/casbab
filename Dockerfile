FROM vandot/alpine-bash

LABEL maintainer "ivan@vandot.rs"

ADD casbab.sh /

ENTRYPOINT ["bash", "/casbab.sh"]