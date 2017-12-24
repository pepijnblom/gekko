#!/usr/bin/env sh
sed -i 's/127.0.0.1/0.0.0.0/g' ${WORKDIR}/web/vue/UIconfig.js
sed -i 's/localhost/'${HOST}'/g' ${WORKDIR}/web/vue/UIconfig.js
sed -i 's/3000/'${PORT}'/g' ${WORKDIR}/web/vue/UIconfig.js
