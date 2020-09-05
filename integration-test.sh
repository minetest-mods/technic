#!/bin/sh
# simple integration test

CFG=/tmp/minetest.conf
MTDIR=/tmp/mt
WORLDDIR=${MTDIR}/worlds/world
WORLDMODDIR=${WORLDDIR}/worldmods

# settings
cat <<EOF > ${CFG}
 enable_technic_integration_test = true
EOF

rm -rf ${WORLDDIR}
mkdir -p ${WORLDMODDIR}
git clone https://gitlab.com/VanessaE/basic_materials.git ${WORLDMODDIR}/basic_materials
git clone https://gitlab.com/VanessaE/pipeworks.git ${WORLDMODDIR}/pipeworks

chmod 777 ${MTDIR} -R
docker run --rm -i \
	-v ${CFG}:/etc/minetest/minetest.conf:ro \
	-v ${MTDIR}:/var/lib/minetest/.minetest \
	-v $(pwd):/var/lib/minetest/.minetest/worlds/world/worldmods/technic \
	registry.gitlab.com/minetest/minetest/server:${MINETEST_VERSION}

test -f ${WORLDDIR}/integration_test.json && exit 0 || exit 1
