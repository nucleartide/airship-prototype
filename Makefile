# Run prototype cart.
prototype:
	@$(shell which pico8) \
		-gif_scale 10 \
		-home $(shell pwd) \
		-run $(shell pwd)/carts/prototype.p8
.PHONY: test

# Print dev time for prototype.
devtime:
	@go run cmd/devtime/main.go
.PHONY: devtime

# Run lerp cart.
lerp:
	@$(shell which pico8) \
		-gif_scale 10 \
		-home $(shell pwd) \
		-run $(shell pwd)/carts/lerp.p8
.PHONY: test
