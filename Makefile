# Run prototype cart.
prototype:
	@$(shell which pico8) \
		-gif_scale 10 \
		-home $(shell pwd) \
		-run $(shell pwd)/carts/prototype.p8
.PHONY: test
