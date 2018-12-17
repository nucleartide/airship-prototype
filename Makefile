# Run PICO-8 cart.
run:
	@open \
		-n \
		-a PICO-8 \
		--args \
			-gif_scale 10 \
			-home $(shell pwd) \
			-run $(shell pwd)/carts/flappy_airship.p8
.PHONY: run

# /Applications/PICO-8.app/Contents/MacOS/pico8
# start from command line, don't use open
# use printh

run2:
	@/Applications/PICO-8.app/Contents/MacOS/pico8 \
		-gif_scale 10 \
		$(shell pwd)/carts/wafflejs.p8
