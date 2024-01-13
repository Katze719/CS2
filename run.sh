if [ ! -d "${INSTALL_DIR}/game" ]; then
    steamcmd +force_install_dir ${INSTALL_DIR} +login anonymous +app_update ${STEAMAPPID} +quit
fi

if [ "${UPDATE}" = "1" ]; then
    echo "Updating >>>"
    steamcmd +force_install_dir ${INSTALL_DIR} +login anonymous +app_update ${STEAMAPPID} +quit
fi

# steamclient.so fix
mkdir -p ~/.steam/sdk64
ln -sfT ${STEAMCMDDIR}/linux64/steamclient.so ~/.steam/sdk64/steamclient.so

# Install server.cfg
cp /etc/server.cfg "${STEAMAPPDIR}"/game/csgo/cfg/server.cfg

# Rewrite Config Files

sed -i -e "s/{{SERVER_HOSTNAME}}/${CS2_SERVERNAME}/g" \
       -e "s/{{SERVER_CHEATS}}/${CS2_CHEATS}/g" \
       -e "s/{{SERVER_HIBERNATE}}/${CS2_SERVER_HIBERNATE}/g" \
       -e "s/{{SERVER_PW}}/${CS2_PW}/g" \
       -e "s/{{SERVER_RCON_PW}}/${CS2_RCONPW}/g" \
       -e "s/{{TV_ENABLE}}/${TV_ENABLE}/g" \
       -e "s/{{TV_PORT}}/${TV_PORT}/g" \
       -e "s/{{TV_AUTORECORD}}/${TV_AUTORECORD}/g" \
       -e "s/{{TV_PW}}/${TV_PW}/g" \
       -e "s/{{TV_RELAY_PW}}/${TV_RELAY_PW}/g" \
       -e "s/{{TV_MAXRATE}}/${TV_MAXRATE}/g" \
       -e "s/{{TV_DELAY}}/${TV_DELAY}/g" \
       "${STEAMAPPDIR}"/game/csgo/cfg/server.cfg

cp /etc/cs2-patched.sh "${INSTALL_DIR}/game/"

echo "Starting CS2 Dedicated Server"

bash "${INSTALL_DIR}/game/cs2-patched.sh" -dedicated \
        "${CS2_IP_ARGS}" -port "${CS2_PORT}" \
        -console \
        -usercon \
        -maxplayers "${CS2_MAXPLAYERS}" \
        "${CS2_GAME_MODE_ARGS}" \
        +mapgroup "${CS2_MAPGROUP}" \
        +map "${CS2_STARTMAP}" \
        +rcon_password "${CS2_RCONPW}" \
        "${SV_SETSTEAMACCOUNT_ARGS}" \
        +sv_password "${CS2_PW}" \
        +sv_lan "${CS2_LAN}" \
        "${CS2_ADDITIONAL_ARGS}"