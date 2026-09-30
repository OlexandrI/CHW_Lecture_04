SHELL := /bin/bash
.NOTPARALLEL:
.PHONY: all software generate projects fpga test sim audit
all: software generate projects fpga test sim
software:
	@mkdir -p evidence/logs
	bash scripts/build_software.sh > evidence/logs/software_build.log 2>&1
generate:
	qsys-script --script=scripts/create_systems.tcl > evidence/logs/create_systems.log 2>&1
	! grep -q 'Error:' evidence/logs/create_systems.log
	cd task2_nios && qsys-generate nios_system.qsys --synthesis=VERILOG --simulation=VERILOG > ../evidence/logs/nios_generate.log 2>&1
	cd task1_hps && qsys-generate hps_system.qsys --synthesis=VERILOG --simulation=VERILOG > ../evidence/logs/hps_generate.log 2>&1
projects:
	quartus_sh -t scripts/create_projects.tcl > evidence/logs/create_projects.log 2>&1
	cp task2_nios/software/hardware.hex task2_nios/firmware.hex
	cp task2_nios/software/hardware.dat task2_nios/firmware.dat
fpga:
	bash scripts/compile_fpga.sh task2_nios
	bash scripts/compile_fpga.sh task1_hps
test:
	@mkdir -p build evidence/logs
	gcc -std=c11 -O2 -g -fsanitize=address,undefined -Wall -Wextra -Werror -Ishared tests/test_chaser.c shared/chaser.c -o build/test_chaser
	ASAN_OPTIONS=detect_leaks=0 ./build/test_chaser > evidence/logs/c_tests_hardware.log
	gcc -std=c11 -O2 -g -fsanitize=address,undefined -Wall -Wextra -Werror -DSIMULATION -Ishared tests/test_chaser.c shared/chaser.c -o build/test_chaser_sim
	ASAN_OPTIONS=detect_leaks=0 ./build/test_chaser_sim > evidence/logs/c_tests_simulation.log
sim:
	bash scripts/run_simulation.sh
audit:
	python3 scripts/check_submission.py > evidence/logs/submission_audit.log
	cat evidence/logs/submission_audit.log
