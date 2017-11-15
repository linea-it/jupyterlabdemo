#!/bin/bash
USER=jupyter
GROUP=jupyter
HOMEDIR=/home/${USER}
if ! [ -d ${HOMEDIR} ]; then
    mkdir -p ${HOMEDIR}
fi
if ! [ -f ${HOMEDIR}/jupyterhub.sqlite ]; then
    touch ${HOMEDIR}/jupyterhub.sqlite
fi
chmod 0600 ${HOMEDIR}/jupyterhub.sqlite
chown -R ${USER}:${GROUP} ${HOMEDIR}

export HUB_BIND_IP=$(/sbin/ifconfig | grep 'inet ' | awk '{print $2}' | \
			 grep -v '127.0.0.1' | head -1)
cd /opt/lsst/software/jupyterhub/config
rm jupyterhub_config.py
for i in jupyterhub_config.d/*.py ; do
    cat $i >> jupyterhub_config.py
done
cd ${HOMEDIR}
exec sudo -E -u ${USER} /usr/bin/jupyterhub --debug -f \
  /opt/lsst/software/jupyterhub/jupyterhub_config_monolithic.py
