#!/bin/bash

WC_SERIAL=683941792
WED_SERIAL=683688378 

FTD_HEX_FILE="build/bin/ot-cli-ftd.hex"
MTD_HEX_FILE="build/bin/ot-cli-mtd.hex"

arm-none-eabi-objcopy -O ihex build/bin/ot-cli-ftd  ${FTD_HEX_FILE}
arm-none-eabi-objcopy -O ihex build/bin/ot-cli-mtd  ${MTD_HEX_FILE}

nrfjprog -f nrf52 -s ${WC_SERIAL} --chiperase --program ${FTD_HEX_FILE} --reset
nrfjprog -f nrf52 -s ${WED_SERIAL} --chiperase --program ${MTD_HEX_FILE} --reset
