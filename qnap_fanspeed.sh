#!/bin/bash

# temperature thresholds
TEMP_LOW=59
TEMP_MEDIUM_START=63
TEMP_MEDIUM_END=67
TEMP_HIGH=69

get_temperature() {
    getsysinfo systmp | awk '{print $1}'
}

set_fan_speed() {
    local temp=$1
    if [ "$temp" -lt "$TEMP_LOW" ]; then
        hal_app --se_sys_set_fan_mode enc_sys_id=root,obj_index=0,mode=0
    elif [ "$temp" -ge "$TEMP_LOW" ] && [ "$temp" -lt "$TEMP_MEDIUM_START" ]; then
        hal_app --se_sys_set_fan_mode enc_sys_id=root,obj_index=0,mode=1
    elif [ "$temp" -ge "$TEMP_MEDIUM_START" ] && [ "$temp" -lt "$TEMP_HIGH" ]; then
        hal_app --se_sys_set_fan_mode enc_sys_id=root,obj_index=0,mode=2
    else
        hal_app --se_sys_set_fan_mode enc_sys_id=root,obj_index=0,mode=7
    fi
}

# main loop
while true; do
    temperature=$(get_temperature)
    set_fan_speed "$temperature"
    sleep 15
done
