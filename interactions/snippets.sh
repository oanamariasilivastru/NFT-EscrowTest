PROXY=https://devnet-gateway.multiversx.com
CHAIN_ID=D
ALICE="./alice.pem"
ALICE_WALLET=erd1qyu5wthldzr8wx5c9ucg8kjagg0jfs53s8nr3zpz3hypefsdd8ssycr6th
NFT_ESCROW_WASM="../output/nft-escrow.wasm"
ADDRESS=erd1qqqqqqqqqqqqqpgq9akgmuzfu5laawl5hg4rdy0lqspr3ytsczfs9cn0l5

deploy() {
    mxpy --verbose contract deploy --bytecode=${NFT_ESCROW_WASM} --recall-nonce --pem=${ALICE} \
    --gas-limit=100000000 \
    --send --outfile="deploy-devnet.interaction.json" --proxy=${PROXY} --chain=${CHAIN_ID} || return

    TRANSACTION=$(mxpy data parse --file="deploy-devnet.interaction.json" --expression="data['emittedTransactionHash']")
    ADDRESS=$(mxpy data parse --file="deploy-devnet.interaction.json" --expression="data['contractAddress']")

    mxpy data store --key=address-devnet-governance --value=${ADDRESS}
    mxpy data store --key=deployTransaction-devnet --value=${TRANSACTION}

    echo ""
    echo "Smart contract address: ${ADDRESS}"
}

