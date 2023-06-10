build: FORCE
	scarb build

clean: FORCE
	scarb clean

fmt: FORCE
	scarb fmt

test: FORCE
	cargo run --bin cairo-test -- --starknet --path $(dir)
	
starknet-compile:
	mkdir -p out && \
	  starknet-compile  ${file} out/$(shell basename $(file) .cairo).json 

starknet-declare:
	starknet declare --contract ${file} --account version_2 

starknet-deploy:
	starknet deploy --class_hash ${hash} --account version_2 --inputs 

starknet-status:
	starknet get_state_update

# Local settings:

local: FORCE
	starknet-devnet \
	--accounts 3 \
	--gas-price 250 \
	--seed 0 \
	--port 5050


FORCE:
