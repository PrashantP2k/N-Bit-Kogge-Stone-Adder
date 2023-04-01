#!/bin/bash
export PATH="/home/prashant/venv/lib/python3.10/site-packages/siliconcompiler/tools/surelog/bin:/home/prashant/venv/bin:/home/prashant/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap/bin"
surelog -nocache -parse -nouhdm /home/prashant/Zero-ASIC/Adders/KoggeStoneAdder.v -top KoggeStoneAdder +libext+.sv+.v
