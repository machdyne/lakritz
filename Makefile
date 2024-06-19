blinky_lakritz:
	mkdir -p output
	yosys -q -p "synth_ecp5 -top blinky -json output/blinky_lakritz.json" rtl/blinky_lakritz.v
	nextpnr-ecp5 --25k --package CABGA256 --lpf lakritz_v0.lpf --json output/blinky_lakritz.json --textcfg output/lakritz_blinky_out.config
	ecppack -v --compress --freq 2.4 output/lakritz_blinky_out.config --bit output/lakritz.bit

prog:
	openFPGALoader -c dirtyJtag output/lakritz.bit
