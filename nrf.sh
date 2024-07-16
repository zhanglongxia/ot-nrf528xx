#!/bin/sh

set -euxo pipefail

SERIAL_NUMBER_1=683688378
SERIAL_NUMBER_2=683152435
SERIAL_NUMBER_3=683129075

clear() {
    rm -rf build
}

build() {
    ./script/build nrf52840 UART_trans -DOT_LOG_OUTPUT=PLATFORM_DEFINED -DOT_LOG_LEVEL=DEBG -DOT_LOG_MAX_SIZE=1024 -DBUILD_TESTING=OFF -DOT_CLI_LOG=ON -DOT_CHANNEL_MONITOR=OFF -DOT_CHANNEL_MANAGER=OFF -DOT_WAKEUP_COORDINATOR=ON -DOT_WAKEUP_END_DEVICE=ON -DOT_CSL_RECEIVER=ON -DOT_PEER_TO_PEER=ON -DOT_SRP_SERVER=ON -DOT_SRP_CLIENT=ON -DOT_ECDSA=ON -DOT_SERVICE=ON
    arm-none-eabi-objcopy -O ihex ./build/bin/ot-cli-ftd ./build/bin/ot-cli-ftd.hex
}

flash() {
    nrfjprog -f nrf52 -s ${SERIAL_NUMBER_1} --chiperase --program ./build/bin/ot-cli-ftd.hex --reset
    nrfjprog -f nrf52 -s ${SERIAL_NUMBER_2} --chiperase --program ./build/bin/ot-cli-ftd.hex --reset
    nrfjprog -f nrf52 -s ${SERIAL_NUMBER_3} --chiperase --program ./build/bin/ot-cli-ftd.hex --reset
}

main()
{
    if [[ $# < 1 ]]; then
        clear
        build
        flash
        exit
    fi

    local operation="$1"

    if [[ "${operation}" == "clear" ]]; then
        clear
    elif [[ ${operation} == "build" ]]; then
        build
    elif [[ ${operation} == "flash" ]]; then
        flash
    else
        echo "Unknown operation: ${operation}"
    fi

}

main "$@"

